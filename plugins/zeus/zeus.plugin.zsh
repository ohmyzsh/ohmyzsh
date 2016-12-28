# Some aliases for zeus. (See: https://github.com/burke/zeus)
# Zeus preloads your Rails environment and forks that process whenever
# needed. This effectively speeds up Rails' boot process to under 1 sec.

# Init
alias zi='zeus init'
alias zinit='zeus init'

# Start
alias zs='zeus start'
alias ztart='zeus start'

# Console
alias zc='zeus console'
alias zonsole='zeus console'

# Server
alias zsr='zeus server'
alias zerver='zeus server'

# Rake
alias zr='noglob zeus rake'
alias zake='noglob zeus rake'

# Generate
alias zg='zeus generate'
alias zenerate='zeus generate'

# Runner
alias zrn='zeus runner'
alias zunner='zeus runner'

# Cucumber
alias zcu='zeus cucumber'
alias zucumber='zeus cucumber'

# Rspec
alias zspec='zeus rspec'

# Test
alias zt='zeus test'
alias zest='zeus test'

alias zu='zeus test test/unit/*'
alias zunits='zeus test test/unit/*'

alias zf='zeus test test/functional/*'
alias zunctional='zeus test test/functional/*'

alias za='zeus test test/unit/*; zeus test test/functional/; zeus cucumber'
alias zall='zeus test test/unit/*; zeus test test/functional/; zeus cucumber'

# Clean up crashed zeus instances.
alias zsw='rm .zeus.sock'
alias zweep='rm .zeus.sock'

# Reset database
alias zdbr='zeus rake db:reset db:test:prepare'
alias zdbreset='zeus rake db:reset db:test:prepare'

# Migrate and prepare database
alias zdbm='zeus rake db:migrate db:test:prepare'
alias zdbmigrate='zeus rake db:migrate db:test:prepare'

# Create database
alias zdbc='zeus rake db:create'

# Create, migrate and prepare database
alias zdbcm='zeus rake db:create db:migrate db:test:prepare'