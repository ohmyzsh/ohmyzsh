# Autocompletion for helm.
#
# Author: https://github.com/alzubaidi

if [ $commands[helm] ]; then
  source <(helm completion zsh)
fi

# Alias main helm command
alias h=helm

# Helm init
alias hini='h init'

# Generate autocompletions script for Helm for the specified shell
alias hcom='h completion'

# Create a new chart with the given name
alias hcre='h create'

# Given a release name, delete the release from Kubernetes
alias hdel='h delete'

# Manage chart dependencies
alias hdep='h dependency'

# Download a named release
alias hget='h get'

# Fetch release history
alias hhis='h history'

# Displays the location of HELM_HOME
alias hhom='h home'

# Inspect a chart
alias hinp='h inspect'

# Install a chart archive
alias hins='h install'

# Examines a chart for possible issues
alias hlin='h lint'

# List releases
alias hlis='h list'

# Package a chart directory into a chart archive
alias hpac='h package'

# Manage helm plugins
alias hplu='h plugin'

# Manage chart repository
alias hrep='h repo'

# Uninstalls Tiller from a cluster
alias hres='h reset'

# Roll back a release to a previous revision
alias hrol='h rollback'

# Search for a keyword in charts
alias hsea='h search'

# Start a local http web server
alias hser='h serve'

# Displays the status of the named release
alias hsta='h status'

# Locally render templates
alias htem='h template'

# Test a release
alias htes='h test'

# Upgrade a release
alias hupg='h upgrade'

# Verify that a chart at the given path has been signed and is valid
alias hver='h verify'

# Print the client/server version information
alias hvsn='h version'