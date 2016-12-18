alias a=archive

archive() {
    if (( $# == 0 )); then
        cat <<-'EOF' >&2
            Usage: archive [file ...]
		EOF
    fi

    while (( $# > 0 )); do
        if [[ ! -f "$1" ]]; then
            echo "archive: '$1' is not a valid file" >&2
            shift
            continue
        fi

		case "$1" in
			(*.7z) 7z l "$1" ;;
            (*.rar) unrar l "$1" ;;
            (*.tar|*.tar.bz2|*.tar.gz|*.tar.lzma|*.tar.xz) tar tf "$1" ;;
            (*.zip) unzip -l "$1" ;;
            (*)
                echo "archive: '$1' cannot be listed" >&2
            ;;
        esac
        shift
    done
}
