#!zsh
alias magento='bin/magento'

# Setup
alias mup='bin/magento setup:upgrade'
alias mdeploy='bin/magento setup:static-content:deploy -f'
alias mdi='bin/magento setup:di:compile'

# Cache
alias mcc='bin/magento cache:clean'
alias mcf='bin/magento cache:flush'
alias mccf='bin/magento cache:flush && bin/magento cache:clean'

# Database
alias mreindex='bin/magento indexer:reindex'
alias minf='bin/magento indexer:info'
alias mid='bin/magento indexer:disable'
alias mien='bin/magento indexer:enable'

# Maintenance
alias mmt='bin/magento maintenance:enable'
alias mmf='bin/magento maintenance:disable'

# Admin
alias mrp='bin/magento admin:reset-password'

# Queue
alias mqs='bin/magento queue:consumers:start'

# Logs
alias mlog='tail -f var/log/*.log'
alias mslog='tail -f var/log/system.log'
alias melog='tail -f var/log/exeption.log'

# Custom
alias mperm='chmod -R 777 var pub generated vendor app/etc'
alias mmode='bin/magento deploy:mode:show'
alias mmset='bin/magento deploy:mode:set'

# Deployment
alias mms='bin\magento module:status'
alias mme='bin\magento module:enable'
alias mmd='bin\magento module:disable'
alias ml='bin\magento list'
alias mac='bin\magento a:u:c'
alias mau='bin\magento a:u:u'
alias maurl='bin/magento i:a'
