function zsh_stats() {
  history | awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl |  head -n20
}

function uninstall_oh_my_zsh() {
  /usr/bin/env ZSH=$ZSH /bin/sh $ZSH/tools/uninstall.sh
}

function upgrade_oh_my_zsh() {
  /usr/bin/env ZSH=$ZSH /bin/sh $ZSH/tools/upgrade.sh
}

function take() {
  mkdir -p $1
  cd $1
}

# Functions for gcc and g++
function my_c++ () { g++ -Wall -Wextra -pedantic $1 -o $2 }

function my_c () { gcc -Wall -Wextra -pedantic $1 -o $2 }

# Userful stuff I come across
function find_my_word () { grep -R $1 * }
