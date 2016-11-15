#
# Magento2 oh-my-zsh plugin
#
# Copyright (c) 2016 Denis Ristic <me@denisristic.com>
# Depend of Oh My Zsh (https://github.com/robbyrussell/oh-my-zsh)
#
# Distributed under the GNU GPL v2. For full terms see the file LICENSE.
#


_magento2_console () {
  echo "php $(find . -maxdepth 2 -mindepth 1 -name 'magento' -type f | head -n 1)"
}

_magento2_get_command_list () {
	`_magento2_console` --no-ansi | awk '/ ([a-z\:])*  .*/ { print $1 }'
}

_magento2 () {
   compadd `_magento2_get_command_list`
}

compdef _magento2 '`_magento2_console`'

#aliases
alias m2='`_magento2_console`'
alias m2clean='`_magento2_console` cache:clean'
alias m2reindex='`_magento2_console` indexer:reindex'
alias m2compile='`_magento2_console` setup:di:compile'
alias m2upgrade='`_magento2_console` setup:upgrade'
alias m2deploy='`_magento2_console` setup:static-content:deploy'