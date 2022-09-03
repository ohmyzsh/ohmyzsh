# It's created by Serkan UYSAL; github:uysalserkan

# Set up git variables
autoload -Uz vcs_info
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '%F{red}*'
zstyle ':vcs_info:*' stagedstr '%F{yellow}+'
zstyle ':vcs_info:*' actionformats '%F{5}[%F{2}%b%F{3}|%F{1}%a%c%u%F{5}]%f '
zstyle ':vcs_info:*' formats '%F{5}[%F{2}%b%c%u%F{5}]%f '
zstyle ':vcs_info:svn:*' branchformat '%b'
zstyle ':vcs_info:svn:*' actionformats '%F{5}[%F{2}%b%F{1}:%F{3}%i%F{3}|%F{1}%a%c%u%F{5}]%f '
zstyle ':vcs_info:svn:*' formats '%F{5}[%F{2}%b%F{1}:%F{3}%i%c%u%F{5}]%f '
zstyle ':vcs_info:*' enable git cvs svn

# Functions
theme_precmd () {
  vcs_info
}

# Git variables
ZSH_THEME_GIT_PROMPT_PREFIX="Ξ %{$fg_bold[blue]%}git::%{$fg_no_bold[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[blue]%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[yellow]%} ⚡ %{$fg_bold[blue]%}"

# Prompt variables
setopt prompt_subst
PROMPT='─ %B%{$FG[040]%}[%n]%{$reset_color%} Ʃ '
PROMPT+='%{$FG[033]%}%B[%~/]%{$reset_color%} '
PROMPT+='$(git_prompt_info)'
PROMPT+='
%{$fg[cyan]%}➭%{$reset_color%} '
# # current-time - status Ʃ Ξ
RPROMPT="%* %(?.%{$fg[cyan]%}✓.%{$fg[red]%}✗%{$reset_color%})"


autoload -U add-zsh-hook
add-zsh-hook precmd theme_precmd
