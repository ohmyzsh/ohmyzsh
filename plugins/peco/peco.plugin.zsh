# select-history
function peco-select-history() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(\history -n 1 | eval $tac | awk '!a[$0]++' | peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history

function peco-cd () {
    local selected_dir=$(find ~/ -type d | peco)
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
    zle clear-screen
}
zle -N peco-cd
bindkey '^x^f' peco-cd

function peco-kill-process () {
    ps -ef | peco | awk '{ print $2 }' | xargs kill
    zle clear-screen
}
zle -N peco-kill-process
bindkey '^xk' peco-kill-process

function peco-find-file-emacs () {
    ls | peco | xargs emacsclient -n
    zle clear-screen
}
zle -N peco-find-file-emacs
bindkey '^x^f' peco-find-file-emacs

function peco-kill-tmux-windows () {
    tmux list-windows | peco | awk -F':' '{print $1}' | xargs tmux kill-window -t
    zle clear-screen
}
zle -N peco-kill-tmux-windows
bindkey '^x^pp' peco-kill-tmux-windows

function peco-kill-ps () {
    ps aux | peco | awk -F' ' '{print $2}' | xargs kill
    zle clear-screen
}
zle -N peco-kill-ps
bindkey '^x^pk' peco-kill-ps

function peco-git-checkout () {
    branch=$(git branch -a | peco | tr -d ' ')
    if [ -n "$branch" ]; then
        if [[ "$branch" =~ "remotes/" ]]; then
            b=$(echo $branch | awk -F'/' '{print $3}')
            git checkout -b ${b} ${branch}
        else
            git checkout ${branch}
        fi
    fi
    zle clear-screen
}
zle -N peco-git-checkout
bindkey '^xg' peco-git-checkout

# ghq
function peco-ghq-list () {
  local selected_dir=$(ghq list -p | peco --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N peco-ghq-list
bindkey '^]' peco-ghq-list

# ag
function peco-ag-emacs () {
    ag $@ | peco --query "$LBUFFER" | awk -F : '{print "+" $2 " " $1}' | xargs emacsclient -n
}
