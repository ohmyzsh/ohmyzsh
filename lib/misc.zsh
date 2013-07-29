## smart urls
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

## file rename magick
bindkey "^[m" copy-prev-shell-word

## jobs
setopt long_list_jobs

## pager
export PAGER="less"
export LESS="-R"

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

