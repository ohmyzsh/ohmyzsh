# Smart URLs
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

# Jobs
setopt long_list_jobs

# Pager
if [[ -z "$PAGER" ]]; then
  export PAGER=less
fi

# Localization
if [[ -z "$LC_CTYPE" ]]; then
  export LC_CTYPE=en_US.UTF-8
fi

