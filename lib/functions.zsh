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

function string_hash() {
	HASHSTR=$1
	HASHSIZE=$2

	HASHVAL=0
	for i in {1..${#HASHSTR}}; do;
		THISCHAR=$HASHSTR[$i]
		HASHVAL=$(( $HASHVAL + $((#THISCHAR)) ))
	done
	HASHSIZE=$(( $HASHSIZE - 1 ))
	HASHVAL=$(( $HASHVAL % $HASHSIZE ))
	HASHVAL=$(( $HASHVAL + 1 ))
	echo $HASHVAL
}
