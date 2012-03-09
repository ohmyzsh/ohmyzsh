## smart urls
if [ -f "/usr/share/zsh/functions/Zle/url-quote-magic" ] ; then
    autoload -U url-quote-magic && zle -N self-insert url-quote-magic
fi

## file rename magick
bindkey "^[m" copy-prev-shell-word

## jobs
setopt long_list_jobs

## pager
export PAGER=less
export LC_CTYPE=$LANG
