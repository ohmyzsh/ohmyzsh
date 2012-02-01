#
# Defines bundler aliases.
#
# Authors:
#   Myron Marston <myron.marston@gmail.com>
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Aliases
alias b='bundle'
alias be='b exec'
alias bi='b install --path vendor'
alias bl='b list'
alias bo='b open'
alias bp='b package'
alias bu='b update'
alias binit="bi && b package && print '\nvendor/ruby' >>! .gitignore"

