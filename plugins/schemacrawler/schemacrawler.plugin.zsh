 
# Override the mvn command with the colorized one.

# aliases
alias schemacrawler-help='schemacrawler -help'
alias schemacrawler-version='schemacrawler -version'

alias schemacrawler-help-db2='schemacrawler -help -server=db2'
alias schemacrawler-help-h2='schemacrawler -help -server=h2'
alias schemacrawler-help-hsqldb='schemacrawler -help -server=hsqldb'
alias schemacrawler-help-mariadb='schemacrawler -help -server=mariadb'
alias schemacrawler-help-mysql='schemacrawler -help -server=mysql'
alias schemacrawler-help-offline='schemacrawler -help -server=offline'
alias schemacrawler-help-oracle='schemacrawler -help -server=oracle'
alias schemacrawler-help-postgresql='schemacrawler -help -server=postgresql'
alias schemacrawler-help-sqlite='schemacrawler -help -server=sqlite'
alias schemacrawler-help-sqlserver='schemacrawler -help -server=sqlserver'
alias schemacrawler-help-sybaseiq='schemacrawler -help -server=sybaseiq'


alias schemacrawler-help-command-brief='schemacrawler -help -c=brief'
alias schemacrawler-help-command-count='schemacrawler -help -c=count'
alias schemacrawler-help-command-details='schemacrawler -help -c=details'
alias schemacrawler-help-command-dump='schemacrawler -help -c=dump'
alias schemacrawler-help-command-freemarker='schemacrawler -help -c=freemarker'
alias schemacrawler-help-command-graph='schemacrawler -help -c=graph'
alias schemacrawler-help-command-lint='schemacrawler -help -c=lint'
alias schemacrawler-help-command-list='schemacrawler -help -c=list'
alias schemacrawler-help-command-=quickdump'schemacrawler -help -c=quickdump'
alias schemacrawler-help-command-schema='schemacrawler -help -c=schema'
alias schemacrawler-help-command-script='schemacrawler -help -c=script'
alias schemacrawler-help-command-serialize='schemacrawler -help -c=serialize'
alias schemacrawler-help-command-thymeleaf='schemacrawler -help -c=thymeleaf'
alias schemacrawler-help-command-velocity='schemacrawler -help -c=velocity'


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
