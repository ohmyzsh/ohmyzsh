alias x=extract

extract() {
	local remove_archive
	local success
	local extract_dir
	local files
	local unrar
	local _7za
	local unzip

	if (( $# == 0 )); then
		cat <<-'EOF' >&2
			Usage: extract [-option] [file ...]

			Options:
			    -r, --remove                Remove archive after unpacking.
			    -p, --password {password}   Use the password to extract.
		EOF
	fi

	remove_archive=1
	unrar="unrar x -ad"
	unzip="unzip"
	_7za="7za x"
	
	files=()

	while (( $# > 0 )); do
		if [[ "$1" == "-r" ]] || [[ "$1" == "--remove" ]]; then
			remove_archive=0
			shift
			continue
		fi

		if [[ "$1" == "-p" ]] || [[ "$1" == "--password" ]]; then
			unrar="unrar x -ad \"-p$2\""
			_7za="7za x -p\"$2\""
			unzip="unzip -P \"$2\""
			shift 2
			continue
		fi

		if [[ ! -f "$1" ]]; then
			echo "extract: '$1' is not a valid file" >&2
			shift
			continue
		fi
		files+="$1"
		shift
	done

	

	for file in ${files[*]}; do
		success=0
		extract_dir="${file:t:r}"
		case "$file" in
			(*.tar.gz|*.tgz) (( $+commands[pigz] )) && { pigz -dc "$file" | tar xv } || tar zxvf "$file" ;;
			(*.tar.bz2|*.tbz|*.tbz2) tar xvjf "$file" ;;
			(*.tar.xz|*.txz)
				tar --xz --help &> /dev/null \
				&& tar --xz -xvf "$file" \
				|| xzcat "$file" | tar xvf - ;;
			(*.tar.zma|*.tlz)
				tar --lzma --help &> /dev/null \
				&& tar --lzma -xvf "$file" \
				|| lzcat "$file" | tar xvf - ;;
			(*.tar) tar xvf "$file" ;;
			(*.gz) (( $+commands[pigz] )) && pigz -d "$file" || gunzip "$file" ;;
			(*.bz2) bunzip2 "$file" ;;
			(*.xz) unxz "$file" ;;
			(*.lzma) unlzma "$file" ;;
			(*.Z) uncompress "$file" ;;
			(*.zip|*.war|*.jar|*.sublime-package|*.ipsw|*.xpi|*.apk|*.aar|*.whl) eval $unzip "$file" -d $extract_dir ;;
			(*.rar) eval $unrar "$file" ;;
			(*.7z) eval $_7za "$file" ;;
			(*.deb)
				mkdir -p "$extract_dir/control"
				mkdir -p "$extract_dir/data"
				cd "$extract_dir"; ar vx "../${file}" > /dev/null
				cd control; tar xzvf ../control.tar.gz
				cd ../data; extract ../data.tar.*
				cd ..; rm *.tar.* debian-binary
				cd ..
			;;
			(*)
				echo "extract: '$file' cannot be extracted" >&2
				success=1
			;;
		esac

		(( success = $success > 0 ? $success : $? ))
		(( $success == 0 )) && (( $remove_archive == 0 )) && rm "$file"
	done
}
