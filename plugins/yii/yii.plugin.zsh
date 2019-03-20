# Yii basic command completion

_yii_get_command_list () {
	protected/yiic | awk '/^ - [a-z]+/ { print $2 }'
}

_yii () {
  if [ -f protected/yiic ]; then
    compadd `_yii_get_command_list`
  fi
}

compdef _yii protected/yiic
compdef _yii yiic

# Aliases
alias yiic='protected/yiic'
