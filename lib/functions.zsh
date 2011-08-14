function zsh_stats() {
  history | awk '{print $2}' | sort | uniq -c | sort -rn | head
}

function uninstall_oh_my_zsh() {
  /bin/sh $ZSH/tools/uninstall.sh
}

function upgrade_oh_my_zsh() {
  /bin/sh $ZSH/tools/upgrade.sh
}

function take() {
  mkdir -p $1
  cd $1
}

function show_processes() {
    if (($# == 0)); then
        ps -ef
    else
        echo "  UID   PID  PPID   C     STIME TTY           TIME CMD"
        ps -ef | grep $*
    fi
}