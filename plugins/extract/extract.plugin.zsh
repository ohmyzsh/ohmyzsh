alias x=extract

extract() {
  setopt localoptions noautopushd

  # Print explanation if "extract" is called with no args
  if (( $# == 0 )); then
    cat >&2 <<'EOF'
Usage: extract [options] [files...]

Options:
    -r, --remove    Remove archive(s) after unpacking.
    -t, --to-directory [DIRECTORY NAME]   Extract into an existing directory.
EOF
    return
  fi
  
  # needed to set internal states by searching CLI args for flags
  local remove_archive=0
  local extract_dir=""

  while : 
  do
    if [[ "$1" == "-r" ]] || [[ "$1" == "--remove" ]]; then
      remove_archive=1
      shift
      continue
    fi
  
    # this sets the extraction directory to the argument after the -t flag
    if [[ "$1" == "-t" ]] || [[ "$1" == "--to-directory" ]]; then
      shift
      if [[ ! -d "$1" ]]; then
        echo "extract: specified output directory $1 is not a valid directory." >&2
        return 1
      fi
      extract_dir="$1"
      shift
      continue
    fi
    
    # if none of the flags were found in the first arg, break the loop
    break
  done
  
  # variables used for saving the current working directory and the 
  # directory where the archive will be unpacked
  local work_dir="$PWD"

  while (( $# > 0 )); do
    
    if [[ ! -f "$1" ]]; then
      echo "extract: '$1' is not a valid file" >&2
      shift
      continue
    fi
  
    if [[ $extract_dir == "" ]]; then
      extract_dir="$PWD"
    fi
  
    local file="$1" 
    local full_path="${1:A}"
    
    builtin cd -q "$extract_dir"
    echo "extract: extracting to $extract_dir" >&2
    
    local success=0
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
          (*.zip|*.war|*.jar|*.ear|*.sublime-package|*.ipa|*.ipsw|*.xpi|*.apk|*.aar|*.whl|*.vsix|*.crx) unzip "$full_path" ;;
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
      esac # end case
      
    
    (( success = success > 0 ? success : $? ))
    (( success == 0 && remove_archive == 1 )) && command rm "$full_path"

    # Go back to original working directory
    builtin cd -q "${work_dir}"
    
    shift
  done
}