# Some aliases for spring. (See: https://github.com/rails/spring)
# Spring is a Rails application preloader
# Rspec needed the spring-commands-rspec gem

# Spring
alias s='spring'
alias sstatus='spring status'
alias sstop='spring stop'

# Rails
alias sr='spring rails'
alias srails='sr'

# Console
alias sc='spring rails console'
alias sconsole='sc'

# Server
alias ssr='spring rails server'
alias sserver='ssr'

# Generate
alias sg='spring rails generate'
alias sgenerate='sg'

# Rspec
alias sspec='spring rspec'

alias ssf='spring rspec spec/features/'
alias ssfeature='ssf'

alias ssm='spring rspec spec/models/'
alias ssmodel='ssm'

alias ssc='spring rspec spec/controllers/'
alias sscontroller='ssc'

# Rake
alias srk='spring rake'
alias srake='srk'

# Reset database
alias sdbr='spring rake db:reset && spring rake db:test:prepare'
alias sdbreset='sdbr'

# Migrate and prepare database
alias sdbm='spring rake db:migrate db:test:prepare'
alias sdbmigrate='sdbm'

# Create database
alias sdbc='spring rake db:create'

# Create, migrate and prepare database
alias sdbcm='spring rake db:create db:migrate db:test:prepare'