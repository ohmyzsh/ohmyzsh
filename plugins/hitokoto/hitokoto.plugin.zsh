if ! (( $+commands[curl] )); then
    echo "hitokoto plugin needs curl to work" >&2
    return
fi

function hitokoto {
    emulate -L zsh
    Q=$(curl -s --connect-timeout 2 "https://v1.hitokoto.cn" | jq -j '.hitokoto+"\t"+.from')

    TXT=$(echo "$Q" | awk -F '\t' '{print $1}')
    WHO=$(echo "$Q" | awk -F '\t' '{print $2}')

    [[ -n "$WHO" && -n "$TXT" ]] && print -P "%F{3}${WHO}%f: “%F{5}${TXT}%f”"
}
