# commands to control local mysql-server installation
# paths are for osx installtion via macports

alias mysqlstart='sudo /opt/local/bin/mysqld_safe5'
alias mysqlstop='/opt/local/bin/mysqladmin5 -u root -p shutdown'
alias mysqlstatus='mysqladmin5 -u root -p ping'