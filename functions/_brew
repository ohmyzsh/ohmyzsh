#compdef brew

# copied from _fink

_brew_all_formulae() {
  formulae=(`brew search`)
}

_brew_installed_formulae() {
  installed_formulae=(`brew list`)
}

local -a _1st_arguments
_1st_arguments=(
  'install:install a formula'
  'remove:remove a formula'
  'search:search for a formula (/regex/ or string)'
  'list:list files in a formula or not-installed formulae'
  'link:link a formula'
  'unlink:unlink a formula'
  'home:visit the homepage of a formula or the brew project'
  'info:information about a formula'
  'prune:remove dead links'
  'update:freshen up links'
  'log:git commit log for a formula'
  'create:create a new formula'
  'edit:edit a formula'
)

local expl
local -a formula installed_formulae

_arguments \
  '(-v --verbose)'{-v,--verbose}'[verbose]' \
  '(--version)--version[version information]' \
  '(--prefix)--prefix[where brew lives on this system]' \
  '(--cache)--cache[brew cache]' \
  '*:: :->subcmds' && return 0

if (( CURRENT == 1 )); then
  _describe -t commands "brew subcommand" _1st_arguments
  return
fi

case "$words[1]" in
  list)
    _arguments \
      '(--unbrewed)--unbrewed[files in brew --prefix not controlled by brew]' \
      '1: :->forms' &&  return 0
      
      if [[ "$state" == forms ]]; then
        _brew_installed_formulae
        _requested installed_formulae expl 'installed formulae' compadd -a installed_formulae
      fi ;;
  install|home|log|info)
    _brew_all_formulae
    _wanted formulae expl 'all formulae' compadd -a formulae ;;
  remove|edit|xo)
    _brew_installed_formulae
    _wanted installed_formulae expl 'installed formulae' compadd -a installed_formulae ;;
esac
