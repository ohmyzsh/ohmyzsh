if ! (( $+commands[curl] )); then
  echo "hitokoto plugin needs curl to work" >&2
  return
fi

function hitokoto {
  setopt localoptions nopromptsubst

  # Get hitokoto data
  local -a data
  data=("${(ps:\n:)"$(command curl -s --connect-timeout 2 "https://v1.hitokoto.cn" | command jq -j '.hitokoto+"\n"+.from')"}")

  # Exit if could not fetch hitokoto
  [[ -n "$data" ]] || return 0

  local quote="${data[1]}" author="${data[2]}"
  print -P "%F{3}${author}%f: “%F{5}${quote}%f”"
}
