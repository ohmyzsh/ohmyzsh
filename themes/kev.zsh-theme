# Grab the current version of ruby and the current gemset in use (via RVM): ruby-1.9.2@foo
KEV_CURRENT_RUBY_="  %{$fg_bold[red]%}♦ \$(~/.rvm/bin/rvm-prompt v g)%{$reset_color%}"

# Grab the current filepath, use shortcuts: ~/Desktop
# Append the current git branch, if in a git repository
KEV_CURRENT_LOCA_="%{$fg[green]%}%~%{$reset_color%}"

# Grab the current git status
KEV_GIT_STATUS_="  \$(git_prompt_info)%{$reset_color%}\$(git_prompt_status)%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[white]%}±"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%} ☀"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[yellow]%} ✭"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%} ⚒"

ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[cyan]%} ✚"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%} ✖"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[blue]%} ➜"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%} ⚡"

# Put it all together!
PROMPT="
$KEV_CURRENT_LOCA_$KEV_GIT_STATUS_$KEV_CURRENT_RUBY_
[%n@%m]$ "
