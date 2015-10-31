## Load smart urls if available
<<<<<<< HEAD
# bracketed-paste-magic is known buggy in zsh 5.1.1 (only), so skip it there; see #4434
autoload -Uz is-at-least
if [[ $ZSH_VERSION != 5.1.1 ]]; then
  for d in $fpath; do
  	if [[ -e "$d/url-quote-magic" ]]; then
  		if is-at-least 5.1; then
  			autoload -Uz bracketed-paste-magic
  			zle -N bracketed-paste bracketed-paste-magic
  		fi
  		autoload -Uz url-quote-magic
  		zle -N self-insert url-quote-magic
      break
  	fi
  done
fi
=======
for d in $fpath; do
	if [[ -e "$d/url-quote-magic" ]]; then
		if [[ -e "$d/bracketed-paste-magic" ]]; then
			autoload -Uz bracketed-paste-magic
			zle -N bracketed-paste bracketed-paste-magic
		fi
		autoload -U url-quote-magic
		zle -N self-insert url-quote-magic
	fi
done
>>>>>>> c0134a9450e486251b247735e022d7efeb496b9c

## jobs
setopt long_list_jobs

## pager
export PAGER="less"
export LESS="-R"

## super user alias
alias _='sudo'
alias please='sudo'

## more intelligent acking for ubuntu users
<<<<<<< HEAD
if which ack-grep &> /dev/null; then
=======
if which ack-grep &> /dev/null;
then
>>>>>>> c0134a9450e486251b247735e022d7efeb496b9c
  alias afind='ack-grep -il'
else
  alias afind='ack -il'
fi

# only define LC_CTYPE if undefined
if [[ -z "$LC_CTYPE" && -z "$LC_ALL" ]]; then
	export LC_CTYPE=${LANG%%:*} # pick the first entry from LANG
fi

# recognize comments
setopt interactivecomments
