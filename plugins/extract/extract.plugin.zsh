alias x=extract

extract() {
	local remove_archive
	local success
	local extract_dir

	if (( $# == 0 )); then
		cat <<-'EOF' >&2
			Usage: extract [-option] [file ...]

			Options:
			    -r, --remove    Remove archive after unpacking.
		EOF
	fi

	remove_archive=1
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

		success=0
		extract_dir="${1:t:r}"
		local full_path="${1:A}"
		case "${1:l}" in
			(*.tar.gz|*.tgz) (( $+commands[pigz] )) && { pigz -dc "$1" | tar xv } || tar zxvf "$1" ;;
			(*.tar.bz2|*.tbz|*.tbz2) tar xvjf "$1" ;;
			(*.tar.xz|*.txz)
				tar --xz --help &> /dev/null \
				&& tar --xz -xvf "$1" \
				|| xzcat "$1" | tar xvf - ;;
			(*.tar.zma|*.tlz)
				tar --lzma --help &> /dev/null \
				&& tar --lzma -xvf "$1" \
				|| lzcat "$1" | tar xvf - ;;
			(*.tar.zst|*.tzst)
				tar --zstd --help &> /dev/null \
				&& tar --zstd -xvf "$1" \
				|| zstdcat "$1" | tar xvf - ;;
			(*.tar) tar xvf "$1" ;;
			(*.tar.lz) (( $+commands[lzip] )) && tar xvf "$1" ;;
			(*.tar.lz4) lz4 -c -d "$1" | tar xvf - ;;
			(*.tar.lrz) (( $+commands[lrzuntar] )) && lrzuntar "$1" ;;
			(*.gz) (( $+commands[pigz] )) && pigz -dk "$1" || gunzip -k "$1" ;;
			(*.bz2) bunzip2 "$1" ;;
			(*.xz) unxz "$1" ;;
			(*.lrz) (( $+commands[lrunzip] )) && lrunzip "$1" ;;
			(*.lz4) lz4 -d "$1" ;;
			(*.lzma) unlzma "$1" ;;
			(*.z) uncompress "$1" ;;
			(*.zip|*.war|*.jar|*.ear|*.sublime-package|*.ipa|*.ipsw|*.xpi|*.apk|*.aar|*.whl) unzip "$1" -d "$extract_dir" ;;
			(*.rar) unrar x -ad "$1" ;;
			(*.rpm)
				command mkdir -p "$extract_dir" && builtin cd -q "$extract_dir" \
				&& rpm2cpio "$full_path" | cpio --quiet -id ;;
			(*.7z) 7za x "$1" ;;
			(*.deb)
				command mkdir -p "$extract_dir/control" "$extract_dir/data"
				builtin cd -q "$extract_dir"; ar vx "$full_path" > /dev/null
				builtin cd -q control; extract ../control.tar.*
				builtin cd -q ../data; extract ../data.tar.*
				builtin cd -q ..; command rm *.tar.* debian-binary ;;
			(*.zst) unzstd "$1" ;;
			(*.cab) cabextract -d "$extract_dir" "$1" ;;
			(*.cpio) cpio -idmvF "$1" ;;
			(*)
				echo "extract: '$1' cannot be extracted" >&2
				success=1
			;;
		esac

		(( success = success > 0 ? success : $? ))
		(( success == 0 && remove_archive == 0 )) && rm "$full_path"
		shift

		# Go back to original working directory in case we ran cd previously
		builtin cd -q "$pwd"
	done
}
