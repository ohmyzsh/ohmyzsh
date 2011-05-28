fpath=($ZSH/plugins/rvm $fpath)
autoload -U compinit
compinit -i

local ruby18='ruby-1.8.7-p334'
local ruby19='ruby-1.9.2-p180'

function rb18 {
	if [ -z "$1" ]; then
		rvm use "$ruby18"
	else
		rvm use "$ruby18@$1"
	fi
}

_rb18() {compadd `ls -1 $rvm_path/gems | grep "^$ruby18@" | sed -e "s/^$ruby18@//" | awk '{print $1}'`}
compdef _rb18 rb18

function rb19 {
	if [ -z "$1" ]; then
		rvm use "$ruby19"
	else
		rvm use "$ruby19@$1"
	fi
}

_rb19() {compadd `ls -1 $rvm_path/gems | grep "^$ruby19@" | sed -e "s/^$ruby19@//" | awk '{print $1}'`}
compdef _rb19 rb19
