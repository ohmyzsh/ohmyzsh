# An informative prompt that gives you hg and git repository info,
#  as well as return code, RVM/rubenv info, and standard hostname, path, user.
# by Avery Yen <haplesshero13@gmail.com>
#
# Hosted at <https://github.com/haplesshero13/my-tools>
#
# Requires hg-prompt <http://stevelosh.com/projects/hg-prompt/>
#
# Stolen mostly from <http://stevelosh.com/blog/2010/02/my-extravagant-zsh-prompt/>
#  and alanpeabody.zsh-theme from Oh-My-Zsh.
#
# Left prompt is modified version of the Bash prompt by AntiGenX
#  <http://hintsforums.macworld.com/showthread.php?t=17068>

# From Steve Losh
function prompt_char {
    git branch >/dev/null 2>/dev/null && echo 'λ' && return
    hg root >/dev/null 2>/dev/null && echo '☿' && return
    echo '$'
}

function hg_prompt_info {
    hg prompt --angle-brackets "\
< %{$fg[magenta]%}<branch>%{$reset_color%}>\
< %{$fg[yellow]%}<tags|%{$reset_color%}, %{$fg[yellow]%}>%{$reset_color%}>\
%{$fg[green]%}<status|modified|unknown><update>%{$reset_color%}<
patches: <patches|join( → )|pre_applied(%{$fg[yellow]%})|post_applied(%{$reset_color%})|pre_unapplied(%{$fg_bold[black]%})|post_unapplied(%{$reset_color%})>>" 2>/dev/null
}

HGPROMPT='$(hg_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[magenta]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN=""

# From Alan Peabody
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%} ✚"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[blue]%} ✹"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%} ✖"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[magenta]%} ➜"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[yellow]%} ═"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%} ✭"

local rvm=''
if which rvm-prompt &> /dev/null; then
  rvm='%{$fg[green]%}‹$(rvm-prompt i v g)›%{$reset_color%}'
else
  if which rbenv &> /dev/null; then
    rvm='%{$fg[green]%}‹$(rbenv version | sed -e "s/ (set.*$//")›%{$reset_color%}'
  fi
fi
local return_code='%(?..%{$fg[red]%}%? ↵%{$reset_color%})'
local git_branch='$(git_prompt_status)%{$reset_color%}$(git_prompt_info)%{$reset_color%}'

# Inspired by AntiGenX's Bash prompt
PROMPT='%{$fg[cyan]%}%m:%{$reset_color%}%~:%{$fg[blue]%}%n%{$reset_color%}$(prompt_char) '
RPROMPT="${return_code} $HGPROMPT ${git_branch} ${rvm}"
