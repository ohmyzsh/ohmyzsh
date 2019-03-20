# commands to control local mysql-server installation
# paths are for osx installation via macports

alias mysqlstart='sudo /opt/local/share/mysql5/mysql/mysql.server start'
alias mysqlstop='sudo /opt/local/share/mysql5/mysql/mysql.server stop'
alias mysqlrestart='sudo /opt/local/share/mysql5/mysql/mysql.server restart'

alias mysqlstatus='mysqladmin5 -u root -p ping'
