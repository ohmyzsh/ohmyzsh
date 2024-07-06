alias x=extract

extract() {
  setopt localoptions noautopushd

  if (( $# == 0 )); then
    cat >&2 <<'EOF'
Usage: extract [-option] [file ...]

Options:
    -r, --remove    Remove archive after unpacking.
EOF
  fi

  local remove_archive=1
  if [[ "$1" == "-r" ]] || [[ "$1" == "--remove" ]]; then
    remove_archive=0
    shift
  fi

  local pwd="$PWD"
  while (( $# > 0 )); do
    if [[ ! -f "$1" ]]; then
      echo "extract: '$1' is not a valid file" >&2
      shift
      continue
    fi

    local success=0
    local file="$1" full_path="${1:A}"
    local extract_dir="${1:t:r}"

    # Remove the .tar extension if the file name is .tar.*
    if [[ $extract_dir =~ '\.tar$' ]]; then
      extract_dir="${extract_dir:r}"
    fi

    # If there's a file or directory with the same name as the archive
    # add a random string to the end of the extract directory
    if [[ -e "$extract_dir" ]]; then
      local rnd="${(L)"${$(( [##36]$RANDOM*$RANDOM ))}":1:5}"
      extract_dir="${extract_dir}-${rnd}"
    fi

    # Create an extraction directory based on the file name
    command mkdir -p "$extract_dir"
    builtin cd -q "$extract_dir"
    echo "extract: extracting to $extract_dir" >&2

    case "${file:l}" in
      (*.tar.gz|*.tgz)
        (( $+commands[pigz] )) && { tar -I pigz -xvf "$full_path" } || tar zxvf "$full_path" ;;
      (*.tar.bz2|*.tbz|*.tbz2)
        (( $+commands[pbzip2] )) && { tar -I pbzip2 -xvf "$full_path" } || tar xvjf "$full_path" ;;
      (*.tar.xz|*.txz)
        (( $+commands[pixz] )) && { tar -I pixz -xvf "$full_path" } || {
        tar --xz --help &> /dev/null \
        && tar --xz -xvf "$full_path" \
        || xzcat "$full_path" | tar xvf - } ;;
      (*.tar.zma|*.tlz)
        tar --lzma --help &> /dev/null \
        && tar --lzma -xvf "$full_path" \
        || lzcat "$full_path" | tar xvf - ;;
      (*.tar.zst|*.tzst)
        tar --zstd --help &> /dev/null \
        && tar --zstd -xvf "$full_path" \
        || zstdcat "$full_path" | tar xvf - ;;
      (*.tar) tar xvf "$full_path" ;;
      (*.tar.lz) (( $+commands[lzip] )) && tar xvf "$full_path" ;;
      (*.tar.lz4) lz4 -c -d "$full_path" | tar xvf - ;;
      (*.tar.lrz) (( $+commands[lrzuntar] )) && lrzuntar "$full_path" ;;
      (*.gz) (( $+commands[pigz] )) && pigz -cdk "$full_path" > "${file:t:r}" || gunzip -ck "$full_path" > "${file:t:r}" ;;
      (*.bz2) (( $+commands[pbzip2] )) && pbzip2 -d "$full_path" || bunzip2 "$full_path" ;;
      (*.xz) unxz "$full_path" ;;
      (*.lrz) (( $+commands[lrunzip] )) && lrunzip "$full_path" ;;
      (*.lz4) lz4 -d "$full_path" ;;
      (*.lzma) unlzma "$full_path" ;;
      (*.z) uncompress "$full_path" ;;
      (*.zip|*.war|*.jar|*.ear|*.sublime-package|*.ipa|*.ipsw|*.xpi|*.apk|*.aar|*.whl) unzip "$full_path" ;;
      (*.rar) unrar x -ad "$full_path" ;;
      (*.rpm)
        rpm2cpio "$full_path" | cpio --quiet -id ;;
      (*.7z | *.7z.[0-9]*) 7za x "$full_path" ;;
      (*.deb)
        command mkdir -p "control" "data"
        ar vx "$full_path" > /dev/null
        builtin cd -q control; extract ../control.tar.*
        builtin cd -q ../data; extract ../data.tar.*
        builtin cd -q ..; command rm *.tar.* debian-binary ;;
      (*.zst) unzstd --stdout "$full_path" > "${file:t:r}" ;;
      (*.cab|*.exe) cabextract "$full_path" ;;
      (*.cpio|*.obscpio) cpio -idmvF "$full_path" ;;
      (*.zpaq) zpaq x "$full_path" ;;
      (*.zlib) zlib-flate -uncompress < "$full_path" > "${file:r}" ;;
      (*)
        echo "extract: '$file' cannot be extracted" >&2
        success=1 ;;
    esac

    (( success = success > 0 ? success : $? ))
    (( success == 0 && remove_archive == 0 )) && command rm "$full_path"
    shift

    # Go back to original working directory
    builtin cd -q "$pwd"

    # If content of extract dir is a single directory, move its contents up
    # Glob flags:
    # - D: include files starting with .
    # - N: no error if directory is empty
    # - Y2: at most give 2 files
    local -a content
    content=("${extract_dir}"/*(DNY2))
    if [[ ${#content} -eq 1 && -e "${content[1]}" ]]; then
      # The extracted file/folder (${content[1]}) may have the same name as $extract_dir
      # If so, we need to rename it to avoid conflicts in a 3-step process
      #
      # 1. Move and rename the extracted file/folder to a temporary random name
      # 2. Delete the empty folder
      # 3. Rename the extracted file/folder to the original name
      if [[ "${content[1]:t}" == "$extract_dir" ]]; then
        # =(:) gives /tmp/zsh<random>, with :t it gives zsh<random>
        local tmp_name==(:); tmp_name="${tmp_name:t}"
        command mv "${content[1]}" "$tmp_name" \
        && command rmdir "$extract_dir" \
        && command mv "$tmp_name" "$extract_dir"
      # Otherwise, if the extracted folder name already exists in the current
      # directory (because of a previous file / folder), keep the extract_dir
      elif [[ ! -e "${content[1]:t}" ]]; then
        command mv "${content[1]}" . \
        && command rmdir "$extract_dir"
      fi
    elif [[ ${#content} -eq 0 ]]; then
      command rmdir "$extract_dir"
    fi
  done
}
