# Autocompletion for homebrew-cask.
#
# This script intercepts calls to the brew plugin and adds autocompletion
# for the cask subcommand.
#
# Author: https://github.com/pstadler

compdef _brew-cask brew

_brew-cask()
{
  local curcontext="$curcontext" state line
  typeset -A opt_args

  _arguments -C \
    ':command:->command' \
    ':subcmd:->subcmd' \
    '*::options:->options'

  case $state in
    (command)
      __call_original_brew
      cask_commands=(
        'cask:manage casks'
      )
      _describe -t commands 'brew cask command' cask_commands ;;

    (subcmd)
      case "$line[1]" in
        cask)
          if (( CURRENT == 3 )); then
            local -a subcommands
            subcommands=(
              "alfred:used to modify Alfred's scope to include the Caskroom"
              'audit:verifies installability of casks'
              'checklinks:checks for bad cask links'
              'cleanup:cleans up cached downloads'
              'create:creates a cask of the given name and opens it in an editor'
              'doctor:checks for configuration issues'
              'edit:edits the cask of the given name'
              'fetch:downloads Cask resources to local cache'
              'home:opens the homepage of the cask of the given name'
              'info:displays information about the cask of the given name'
              'install:installs the cask of the given name'
              'list:with no args, lists installed casks; given installed casks, lists installed files'
              'search:searches all known casks'
              'uninstall:uninstalls the cask of the given name'
              "update:a synonym for 'brew update'"
            )
            _describe -t commands "brew cask subcommand" subcommands
          fi ;;

        *)
          __call_original_brew ;;
      esac ;;

    (options)
      local -a casks installed_casks
      local expl
      case "$line[2]" in
        list|uninstall)
          __brew_installed_casks
          _wanted installed_casks expl 'installed casks' compadd -a installed_casks ;;
        audit|edit|home|info|install)
          __brew_all_casks
          _wanted casks expl 'all casks' compadd -a casks ;;
      esac ;;
  esac
}

__brew_all_casks() {
  casks=(`brew cask search`)
}

__brew_installed_casks() {
  installed_casks=(`brew cask list`)
}

__call_original_brew()
{
  local ret=1
  _call_function ret _brew
  compdef _brew-cask brew
}
