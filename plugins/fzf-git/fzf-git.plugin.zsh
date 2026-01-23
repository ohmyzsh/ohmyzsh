# Git completions powered by FZF
#
# Based on:
# - https://github.com/junegunn/fzf/wiki/Examples-(completion)
# - https://gist.github.com/junegunn/8b572b8d4b5eddd8b85e5f4d40f17236
# - https://github.com/hschne/fzf-git

fzf-git::is_in_git_repo() { git rev-parse HEAD > /dev/null 2>&1 }

fzf-git::fzf_down() { fzf --height 50% "$@" --border }

fzf-git::join-lines() {
  local item
  while read item; do
    echo -n "${(q)item} "
  done
}

# Git Status [C-g C-s] {{{

fzf-git::status() {
  fzf-git::is_in_git_repo || return
  git -c color.status=always status --short |
  fzf-git::fzf_down -m --ansi --nth 2..,.. \
    --preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1}) | head -500' |
  cut -c4- | sed 's/.* -> //'
}

fzf-git::status-widget() {
  local result=$(fzf-git::status | fzf-git::join-lines)
  zle reset-prompt
  LBUFFER+=$result
}

zle -N fzf-git::status-widget

bindkey '^g^s' fzf-git::status-widget

# }}}

# Git Branch [C-g C-b] {{{

fzf-git::branch() {
  fzf-git::is_in_git_repo || return
  git branch -a --color=always | grep -v '/HEAD\s' | sort |
  fzf-git::fzf_down --ansi --multi --tac --preview-window right:70% \
    --preview 'git log --oneline --graph --date=short --color=always --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1) | head -'$LINES |
  sed 's/^..//' | cut -d' ' -f1 |
  sed 's#^remotes/##'
}

fzf-git::branch-widget() {
  local result=$(fzf-git::branch | fzf-git::join-lines)
  zle reset-prompt
  LBUFFER+=$result
}

zle -N fzf-git::branch-widget

bindkey '^g^b' fzf-git::branch-widget

# }}}

# Git Tag [C-g C-t] {{{

fzf-git::tag() {
  fzf-git::is_in_git_repo || return
  git tag --sort -creatordate |
  fzf-git::fzf_down --multi --preview-window right:70% \
    --preview 'git show --color=always {} | head -'$LINES
}

fzf-git::tag-widget() {
  local result=$(fzf-git::tag | fzf-git::join-lines)
  zle reset-prompt
  LBUFFER+=$result
}

zle -N fzf-git::tag-widget

bindkey '^g^t' fzf-git::tag-widget

# }}}

# Git Log [C-g C-l] {{{

fzf-git::log() {
  fzf-git::is_in_git_repo || return
  git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always |
  fzf-git::fzf_down --ansi --no-sort --reverse --multi --bind 'ctrl-s:toggle-sort' \
    --header 'Press CTRL-S to toggle sort' \
    --preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --color=always | head -'$LINES |
  grep -o "[a-f0-9]\{7,\}"
}

fzf-git::log-widget() {
  local result=$(fzf-git::log | fzf-git::join-lines)
  zle reset-prompt
  LBUFFER+=$result
}

zle -N fzf-git::log-widget

bindkey '^g^l' fzf-git::log-widget

# }}}

# Git Remote [C-g C-r] {{{

fzf-git::remote() {
  fzf-git::is_in_git_repo || return
  git remote -v | awk '{print $1 "\t" $2}' | uniq |
  fzf-git::fzf_down --tac \
    --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" {1} | head -200' |
  cut -d$'\t' -f1
}

fzf-git::remote-widget() {
  local result=$(fzf-git::remote | fzf-git::join-lines)
  zle reset-prompt
  LBUFFER+=$result
}

zle -N fzf-git::remote-widget

bindkey '^g^r' fzf-git::remote-widget

# }}}
