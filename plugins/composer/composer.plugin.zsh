## Composer command completion
#
# Composer is a Symfony Console application, so since composer 2.4 it answers
# the "_complete" protocol and can describe its own commands, options and
# arguments. This is the frontend for it, adapted from the script shipped by
# symfony/console:
# https://github.com/symfony/symfony/blob/6.4/src/Symfony/Component/Console/Resources/completion.zsh
#
# Composer 2.2, the LTS line maintained until at least 2026-12-31, has no
# "_complete" command. _composer_legacy below is the previous completion of
# this plugin, kept as a fallback for it.
# Completion for composer older than 2.4, which cannot describe itself.
# It parses the human readable output and only knows about command names and
# the packages already required.
_composer_legacy() {
  local curcontext="$curcontext" state line
  typeset -A opt_args
  _arguments '*:: :->subcmds'

  if (( CURRENT == 1 )) || ( (( CURRENT == 2 )) && [[ "$words[1]" = "global" ]] ); then
    # Command list
    local -a subcmds
    subcmds=("${(@f)"$($_comp_command1 --no-ansi 2>/dev/null | awk '
      /Available commands/{ r=1 }
      r == 1 && /^[ \t]*[a-z]+/{
        gsub(/^[ \t]+/, "")
        gsub(/  +/, ":")
        print $0
      }
    ')"}")
    _describe -t commands 'composer command' subcmds
  else
    # Required list
    compadd $($_comp_command1 show -s --no-ansi 2>/dev/null \
      | sed '1,/requires/d' \
      | awk 'NF > 0 && !/^requires \(dev\)/{ print $1 }')
  fi
}

_composer() {
  local lastParam out comp composer_cmd
  local -a completions flagPrefix requestComp inputs

  # The user could have moved the cursor backwards on the command-line.
  # We need to trigger completion from the $CURRENT location, so we need
  # to truncate the command-line ($words) up to the $CURRENT location.
  # (We cannot use $CURSOR as its value does not work when a command is an alias.)
  words=("${=words[1,CURRENT]}") lastParam=${words[-1]}

  # When completing a flag with an = (e.g., composer -n=<TAB>)
  # completions must be prefixed with the flag
  setopt local_options BASH_REMATCH
  if [[ "${lastParam}" =~ '-.*=' ]]; then
    flagPrefix=(-P "${BASH_REMATCH}")
  fi

  # Prepare the command to obtain completions. An alias is resolved here,
  # because the request is not read again by the shell.
  composer_cmd="${words[1]}"
  if [[ -n "${aliases[$composer_cmd]}" ]]; then
    requestComp=(${(z)aliases[$composer_cmd]})
  else
    requestComp=(${~composer_cmd})
  fi

  # Users who prefer zsh's builtin composer completion, which is faster for
  # package names thanks to its disk cache, can opt out of the native one:
  #   zstyle ':completion:*:composer:*' native-completion no
  # The builtin only exists since zsh 5.7. When it is not available the autoload
  # fails, and the native completion below runs as before.
  if [[ "${composer_cmd:t}" == composer(|.phar) ]] \
    && zstyle -t ":completion:*:composer:*" native-completion no \
    && autoload +X -Uz _composer 2>/dev/null; then
    _composer
    return $?
  fi

  # Composer bundles symfony/console 5.4, which only knows the bash output and
  # names the version option "--symfony" (-S), not "--api-version" (-a). The
  # bash output is a plain list that the loop below reads just as well.
  requestComp+=(_complete --no-interaction -sbash -S1 "-c$((CURRENT-1))")

  for w in ${words[@]}; do
    w=$(printf -- '%b' "$w")
    # remove quotes from typed values
    quote="${w:0:1}"
    if [ "$quote" = \' ]; then
      w="${w%\'}"
      w="${w#\'}"
    elif [ "$quote" = \" ]; then
      w="${w%\"}"
      w="${w#\"}"
    fi
    # empty values are ignored
    if [ ! -z "$w" ]; then
      inputs+=("-i$w")
    fi
  done

  # Ensure at least 1 input
  if (( ! $#inputs )); then
    inputs=(-i' ')
  fi

  # The request is run without being read again by the shell, so that a
  # "$(...)" or a backtick typed on the command line is not executed
  out=$(SHELL_VERBOSITY=0 "${requestComp[@]}" "${inputs[@]}" 2>/dev/null)

  # Composer older than 2.4 exits with an error, "_complete" is not defined.
  # An installed composer with nothing to offer exits with 0 and no output.
  if (( $? )); then
    _composer_legacy
    return $?
  fi

  while IFS='\n' read -r comp; do
    if [ -n "$comp" ]; then
      # If requested, completions are returned with a description.
      # The description is preceded by a TAB character.
      # For zsh's _describe, we need to use a : instead of a TAB.
      # We first need to escape any : as part of the completion itself.
      comp=${comp//:/\\:}
      local tab=$(printf '\t')
      comp=${comp//$tab/:}
      completions+=${comp}
    fi
  done < <(printf "%s\n" "${out[@]}")

  # Let inbuilt _describe handle completions
  _describe "completions" completions "${flagPrefix[@]}"
  return $?
}

compdef _composer composer
compdef _composer composer.phar


## Aliases
alias c='composer'
alias ccp='composer create-project'
alias cdo='composer dump-autoload -o'
alias cdu='composer dump-autoload'
alias cget='curl -s https://getcomposer.org/installer | php'
alias cgr='composer global require'
alias cgrm='composer global remove'
alias cgu='composer global update'
alias ci='composer install'
alias co='composer outdated'
alias cod='composer outdated --direct'
alias cr='composer require'
alias crm='composer remove'
alias cs='composer show'
alias csu='composer self-update'
alias cu='composer update'
alias cuh='composer update --working-dir=$(composer config -g home)'


## If Composer not found, try to add known directories to $PATH
if (( ! $+commands[composer] )); then
  [[ -d "$HOME/.composer/vendor/bin" ]] && export PATH="$PATH:$HOME/.composer/vendor/bin"
  [[ -d "$HOME/.config/composer/vendor/bin" ]] && export PATH="$PATH:$HOME/.config/composer/vendor/bin"

  # If still not found, don't do the rest of the script
  (( $+commands[composer] )) || return 0
fi


## Add Composer's global binaries to PATH
autoload -Uz _store_cache _retrieve_cache _cache_invalid
_retrieve_cache composer

if [[ -z $__composer_bin_dir ]]; then
  __composer_bin_dir=$(composer global config bin-dir --absolute 2>/dev/null)
  _store_cache composer __composer_bin_dir
fi

# Add Composer's global binaries to PATH
export PATH="$PATH:$__composer_bin_dir"

unset __composer_bin_dir
