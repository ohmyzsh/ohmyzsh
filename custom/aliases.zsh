alias be='bundle exec'
alias -g rs='rspec -cf d'
alias fresh_coffee='coffee -wc -o public/javascripts app/coffee'
alias thog='thin start -d; tail -f log/development.log'
alias e='mvim'
alias g='git'

alias ll='ls -lFh'
alias lll='ls -laFh'

alias mongo_start='mongod --fork --config /usr/local/var/mongodb/mongod.conf'
alias mongo_stop='kill -15 `cat /usr/local/var/run/mongod.pid`'

alias mysql_start='/usr/local/Cellar/mysql/5.1.44/share/mysql/mysql.server start'
alias mysql_stop='/usr/local/Cellar/mysql/5.1.44/share/mysql/mysql.server stop'

alias postgres_start='pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start'
alias postgres_stop='pg_ctl -D /usr/local/var/postgres stop -s -m fast'

alias redis_start='redis-server /usr/local/etc/redis.conf'
alias redis_stop='kill `cat /usr/local/var/run/redis.pid`'

alias ruby192_mode='rvm use ruby-1.9.2-p180@general --default'
alias ruby187_mode='rvm use ree-1.8.7-2011.03@general --default'
