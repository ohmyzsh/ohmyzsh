# Smart URLs
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

# Jobs
setopt long_list_jobs

# Locale
[[ -z "$LANG" ]] && export LANG="en_US.UTF-8"
[[ -z "$LC_ALL" ]] && export LC_ALL="en_US.UTF_8"
[[ -z "$LC_COLLATE" ]] && export LC_COLLATE="en_US.UTF-8"
[[ -z "$LC_CTYPE" ]] && export LC_CTYPE="en_US.UTF-8"
[[ -z "$LC_MESSAGES" ]] && export LC_MESSAGES="en_US.UTF-8"
[[ -z "$LC_MONETARY" ]] && export LC_MONETARY="en_US.UTF-8"
[[ -z "$LC_NUMERIC" ]] && export LC_NUMERIC="en_US.UTF-8"
[[ -z "$LC_TIME" ]] && export LC_TIME="en_US.UTF-8"

# Pager
[[ -z "$PAGER" ]] && export PAGER=less

# Grep
if [[ "$DISABLE_COLOR" != 'true' ]]; then
  [[ -z "$GREP_OPTIONS" ]] && export GREP_OPTIONS='--color=auto'
  [[ -z "$GREP_COLOR" ]] && export GREP_COLOR='37;45'
else
  export GREP_OPTIONS='--color=none'
  export GREP_COLOR=''
fi

