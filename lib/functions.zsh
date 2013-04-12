function zsh_stats() {
  history | awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl |  head -n20
}

function uninstall_oh_my_zsh() {
  /usr/bin/env ZSH=$ZSH /bin/sh $ZSH/tools/uninstall.sh
}

function upgrade_oh_my_zsh() {
  /usr/bin/env ZSH=$ZSH /bin/sh $ZSH/tools/upgrade.sh
}

function upgrade_forked_oh_my_zsh() {
	cd $ZSH
	git remote add robbyrussell https://github.com/robbyrussell/oh-my-zsh.git
	git fetch robbyrussell
	git merge robbyrussell/master
	git push origin master
	cd -
}

function take() {
  mkdir -p $1
  cd $1
}

