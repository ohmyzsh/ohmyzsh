## smart urls
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

## file rename magick
autoload -U zmv
bindkey "^[m" copy-prev-shell-word

## jobs
setopt long_list_jobs

## pager
export PAGER=less
export LC_CTYPE=$LANG
