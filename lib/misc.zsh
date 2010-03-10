## smart urls
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

## file rename magick
autoload -U zmv
bindkey "^[m" copy-prev-shell-word

## jobs
setopt long_list_jobs

## pager
export PAGER='less -R'
export LC_CTYPE=en_US.UTF-8

## pretty man pages
function pman() {
    man $1 -t | open -f -a Preview
}