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
              'audit:verifies installability of casks'
              'cat:dump raw source of the given Cask to the standard output'
              'cleanup:cleans up cached downloads and tracker symlinks'
              'create:creates the given Cask and opens it in an editor'
              'doctor:checks for configuration issues'
              'edit:edits the given Cask'
              'fetch:downloads remote application files to local cache'
              'home:opens the homepage of the given Cask'
              'info:displays information about the given Cask'
              'install:installs the given Cask'
              'list:with no args, lists installed Casks; given installed Casks, lists staged files'
              'search:searches all known casks'
              'style:checks Cask style using RuboCop'
              'uninstall:uninstalls the given Cask'
              "update:a synonym for 'brew update'"
              'zap:zaps all files associated with the given Cask'
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
        list|uninstall|zap)
          __brew_installed_casks
          _wanted installed_casks expl 'installed casks' compadd -a installed_casks ;;
        audit|cat|edit|fetch|home|info|install|style)
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
