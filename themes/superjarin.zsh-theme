# Grab the current version of ruby in use (via RVM): [ruby-1.8.7]
JARIN_CURRENT_RUBY_="%{$fg[white]%}[%{$fg[red]%}\$(~/.rvm/bin/rvm-prompt i v)%{$fg[white]%}]%{$reset_color%}"

# Grab the current filepath, use shortcuts: ~/Desktop
# Append the current git branch, if in a git repository
JARIN_CURRENT_LOCA_="%{$fg_bold[cyan]%}%~\$(git_prompt_info)%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[white]%} <%{$fg[magenta]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"

# Do nothing if the branch is clean (no changes).
ZSH_THEME_GIT_PROMPT_CLEAN="%{$reset_color%}>"

# Add a yellow ✗ if the branch is dirty
ZSH_THEME_GIT_PROMPT_DIRTY="%{$reset_color%}> %{$fg[yellow]%}✗"

# Put it all together!
PROMPT="$JARIN_CURRENT_RUBY_ $JARIN_CURRENT_LOCA_ "

