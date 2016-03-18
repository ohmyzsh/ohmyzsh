 
# Override the mvn command with the colorized one.

# aliases
alias sc-help='schemacrawler -help'
alias sc-version='schemacrawler -version'

alias sc-help-db2='schemacrawler -help -server=db2'
alias sc-help-h2='schemacrawler -help -server=h2'
alias sc-help-hsqldb='schemacrawler -help -server=hsqldb'
alias sc-help-mariadb='schemacrawler -help -server=mariadb'
alias sc-help-mysql='schemacrawler -help -server=mysql'
alias sc-help-offline='schemacrawler -help -server=offline'
alias sc-help-oracle='schemacrawler -help -server=oracle'
alias sc-help-postgresql='schemacrawler -help -server=postgresql'
alias sc-help-sqlite='schemacrawler -help -server=sqlite'
alias sc-help-sqlserver='schemacrawler -help -server=sqlserver'
alias sc-help-sybaseiq='schemacrawler -help -server=sybaseiq'


alias sc-help-command-brief='schemacrawler -help -c=brief'
alias sc-help-command-count='schemacrawler -help -c=count'
alias sc-help-command-details='schemacrawler -help -c=details'
alias sc-help-command-dump='schemacrawler -help -c=dump'
alias sc-help-command-freemarker='schemacrawler -help -c=freemarker'
alias sc-help-command-graph='schemacrawler -help -c=graph'
alias sc-help-command-lint='schemacrawler -help -c=lint'
alias sc-help-command-list='schemacrawler -help -c=list'
alias sc-help-command-=quickdump'schemacrawler -help -c=quickdump'
alias sc-help-command-schema='schemacrawler -help -c=schema'
alias sc-help-command-script='schemacrawler -help -c=script'
alias sc-help-command-serialize='schemacrawler -help -c=serialize'
alias sc-help-command-thymeleaf='schemacrawler -help -c=thymeleaf'
alias sc-help-command-velocity='schemacrawler -help -c=velocity'


function listSchemacrawlerCompletions { 
     reply=(
        # available servers
		-server=db2 -server=h2 -server=hsqldb -server=mariadb -server=mysql -server=offline -server=oracle -server=postgresql -server=sqlite -server=sqlserver -server=sybaseiq
		
		# connection options
        -url= -user= -password=
		
		# info level options
		-infolevel=minimum -infolevel=standard -infolevel=detailed -infolevel=maximum
		
		# filtering options
		-schemas= -tabletypes= -tables= -excludecolumns= -routinetypes= -routines= -excludeinout= -synonyms= -sequences=
		
		# Grep options
		-grepcolumns= -grepinout= -grepdef= -invert-match -only-matching -hideemptytables -parents= -children=

		# Configuration options
		-configfile= -configfile=schemacrawler.config.properties -additionalconfigfile=
		
		# Application options
		-loglevel= -loglevel=OFF -loglevel=SEVERE -loglevel=WARNING -loglevel=INFO -loglevel=CONFIG -loglevel=FINE -loglevel=FINER -loglevel=FINEST  -loglevel=ALL
		
		# help commands
		-? -h -help --help
		
		# version command
		-V --version
		
		# commands
		-command= -command=brief -command=count -command=details -command=dump -command=freemarker -command=graph -command=lint -command=list -command=quickdump -command=schema -command=script -command=serialize -command=thymeleaf -command=velocity
    ); 
}

compctl -K listSchemacrawlerCompletions schemacrawler
