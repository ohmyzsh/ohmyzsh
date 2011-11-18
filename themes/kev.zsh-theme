# Grab the current version of ruby and the current gemset in use (via RVM): ruby-1.9.2@foo
KEV_CURRENT_RUBY_=" %{$fg_bold[red]%}♦ \$(~/.rvm/bin/rvm-prompt v g)%{$reset_color%}"

# Grab the current filepath, use shortcuts: ~/Desktop
# Append the current git branch, if in a git repository
KEV_CURRENT_LOCA_="%{$fg[green]%}%~%{$reset_color%}"

# Grab the current git status
KEV_GIT_STATUS_=" \$(git_prompt_info)"
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}(%{$fg[white]%}± "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[green]%})%{$reset_color%}"
# Do nothing if the branch is clean (no changes).
ZSH_THEME_GIT_PROMPT_CLEAN="%{$reset_color%}"
# Add a red ⚡ if the branch is dirty
ZSH_THEME_GIT_PROMPT_DIRTY="%{$reset_color%}%{$fg[red]%}⚡"
# Add a yello ? if the branch is untracked
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[yellow]%}?"

# Put it all together!
PROMPT="
$KEV_CURRENT_LOCA_$KEV_GIT_STATUS_$KEV_CURRENT_RUBY_
[%n@%m]$ "
