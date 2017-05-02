# magerun basic command completion

_magerun_get_command_list () {
	php vendor/bin/n98-magerun --no-ansi | sed "1,/Available commands/d" | awk '/^  [a-z]+/ { print $1 }'
}

_magerun () {
  if [ -f vendor/bin/n98-magerun ]; then
    compadd `_magerun_get_command_list`
  fi
}

compdef _magerun vendor/bin/n98-magerun
compdef _magerun magento
compdef _magerun mage

#Alias
alias mage='vendor/bin/n98-magerun'
alias magento='vendor/bin/n98-magerun'
alias magecc='vendor/bin/n98-magerun cache:clean'
