## smart urls
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

## jobs
setopt long_list_jobs

## pager
export PAGER="less"
export LESS="-R"

## super user alias
alias _='sudo'
alias please='sudo'

## more intelligent acking for ubuntu users
alias afind='ack-grep -il'

## how to interpret text characters
if [[ -z "$LC_CTYPE" && -z "$LC_ALL" ]]; then # only define if undefined
	export LC_CTYPE=${LANG%%:*}                 # pick the first entry from LANG
	[[ -z "$LC_CTYPE" ]] && \
		export LC_CTYPE=`locale -a | grep en_US.utf8 | head -1`
	[[ -z "$LC_CTYPE" ]] && \
		export LC_CTYPE=`locale -a | grep en_US | head -1`
	[[ -z "$LC_CTYPE" ]] && \
		export LC_CTYPE=C                         # default to internal encoding.
fi

