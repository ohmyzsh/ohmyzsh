## smart urls
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

## jobs
setopt long_list_jobs

## pager
export PAGER="less"
export LESS="-R"

export LC_CTYPE=$LANG

## super user alias
alias _='sudo'
alias please='sudo'

## more intelligent acking for ubuntu users
alias afind='ack-grep -il'
