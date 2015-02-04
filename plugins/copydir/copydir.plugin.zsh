if [[ $(uname -s) != 'Darwin' ]]; then
  alias pbcopy='xclip -selection clipboard'
fi

function copydir {
  pwd | tr -d "\r\n" | pbcopy
}
