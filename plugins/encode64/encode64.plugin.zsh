encode64() {
    if [[ $# -eq 0 ]]; then
        cat | base64
    else
        printf '%s' "$1" | base64
    fi
}

encodefile64() {
    if [[ $# -ne 1 || ! -f "$1" || ! -r "$1" ]]; then
        print -u2 -- 'Usage: encodefile64 <file>'
        return 1
    fi

    local file="$1" output="${1}.txt" tmp_file
    [[ $output == /* ]] || output="./$output"

    tmp_file=$(mktemp "${output}.XXXXXX") || return 1
    if ! base64 < "$file" > "$tmp_file"; then
        command rm -f "$tmp_file"
        return 1
    fi
    if ! command mv "$tmp_file" "$output"; then
        command rm -f "$tmp_file"
        return 1
    fi

    print -- "$file's content encoded in base64 and saved as ${file}.txt"
}

decode64() {
    if [[ $# -eq 0 ]]; then
        cat | base64 -d
    else
        printf '%s' "$1" | base64 -d
    fi
}
alias e64=encode64
alias ef64=encodefile64
alias d64=decode64
