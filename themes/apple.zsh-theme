function toon {
  echo -n "%B%f"  # 使用默认前景色
}

autoload -Uz vcs_info
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '%F{red}*'
zstyle ':vcs_info:*' stagedstr '%F{yellow}+'
zstyle ':vcs_info:*' actionformats '%F{8}[%F{2}%b%F{3}|%F{1}%a%c%u%F{8}]%f '
zstyle ':vcs_info:*' formats '%F{8}[%F{2}%b%c%u%F{8}]%f '
zstyle ':vcs_info:svn:*' branchformat '%b'
zstyle ':vcs_info:svn:*' actionformats '%F{8}[%F{2}%b%F{1}:%F{3}%i%F{3}|%F{1}%a%c%u%F{8}]%f '
zstyle ':vcs_info:svn:*' formats '%F{8}[%F{2}%b%F{1}:%F{3}%i%c%u%F{8}]%f '
zstyle ':vcs_info:*' enable git cvs svn

theme_precmd () {
  vcs_info
}

setopt prompt_subst
# 使用默认前景色(:和苹果图标)，保持粗体效果
PROMPT='%B%f: $(toon)%b %~ ${vcs_info_msg_0_}%f'

autoload -U add-zsh-hook
add-zsh-hook precmd theme_precmd
