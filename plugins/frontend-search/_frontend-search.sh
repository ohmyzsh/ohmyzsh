#compdef frontend

zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion::complete:frontend:*:commands' group-name commands
zstyle ':completion::complete:frontend:*:frontend_points' group-name frontend_points
zstyle ':completion::complete:frontend::' list-grouped

zmodload zsh/mapfile

function _frontend() {
  local CONFIG=$HOME/.frontend-search
  local ret=1

  local -a commands
  local -a frontend_points

  frontend_points=( "${(f)mapfile[$CONFIG]//$HOME/~}" )

  commands=(
    'angular: Search in Angular.io website'
    'angularjs: Search in docs.angularjs.org website'
    'bem: Search in BEM website'
    'bootsnipp: Search in bootsnipp website'
    'bundlephobia: Search in Bundlephobia website'
    'caniuse: Search in Can I Use website'
    'codepen: Search in codepen website'
    'compassdoc: Search in COMPASS website'
    'cssflow: Search in cssflow website'
    'dartlang: Search in Dart website'
    'emberjs: Search in Ember website'
    'flowtype: Search in Flowtype website'
    'fontello: Search in fontello website'
    'github: Search in GitHub website'
    'html5please: Search in HTML5 Please website'
    'jestjs: Search in Jest website'
    'jquery: Search in jQuery website'
    'lodash: Search in Lo-Dash website'
    'mdn: Search in MDN website'
    'nodejs: Search in NodeJS website'
    'npmjs: Search in NPMJS website'
    'qunit: Search in Qunit website'
    'reactjs: Search in React website'
    'smacss: Search in SMACSS website'
    'stackoverflow: Search in StackOverflow website'
    'typescript: Search in TypeScript website'
    'unheap: Search in unheap website'
    'vuejs: Search in VueJS website'
  )

  _arguments -C \
    '1: :->first_arg' \
    '2: :->second_arg' && ret=0

  case $state in
    first_arg)
      _describe -t frontend_points "Warp points" frontend_points && ret=0
      _describe -t commands "Commands" commands && ret=0
      ;;
    second_arg)
      case $words[2] in
        jquery)
          _describe -t points "Warp points" frontend_points && ret=0
          ;;
        mdn)
          _describe -t points "Warp points" frontend_points && ret=0
          ;;
        compassdoc)
          _describe -t points "Warp points" frontend_points && ret=0
          ;;
        html5please)
          _describe -t points "Warp points" frontend_points && ret=0
          ;;
        caniuse)
          _describe -t points "Warp points" frontend_points && ret=0
          ;;
        dartlang)
          _describe -t points "Warp points" frontend_points && ret=0
          ;;
        lodash)
          _describe -t points "Warp points" frontend_points && ret=0
          ;;
        qunit)
          _describe -t points "Warp points" frontend_points && ret=0
          ;;
        fontello)
          _describe -t points "Warp points" frontend_points && ret=0
          ;;
        github)
          _describe -t points "Warp points" frontend_points && ret=0
          ;;
        bootsnipp)
          _describe -t points "Warp points" frontend_points && ret=0
          ;;
        cssflow)
          _describe -t points "Warp points" frontend_points && ret=0
          ;;
        codepen)
          _describe -t points "Warp points" frontend_points && ret=0
          ;;
        unheap)
          _describe -t points "Warp points" frontend_points && ret=0
          ;;
        bem)
          _describe -t points "Warp points" frontend_points && ret=0
          ;;
        smacss)
          _describe -t points "Warp points" frontend_points && ret=0
          ;;
        angularjs)
          _describe -t points "Warp points" frontend_points && ret=0
          ;;
        reactjs)
          _describe -t points "Warp points" frontend_points && ret=0
          ;;
        emberjs)
          _describe -t points "Warp points" frontend_points && ret=0
          ;;
        stackoverflow)
          _describe -t points "Warp points" frontend_points && ret=0
          ;;
        npmjs)
          _describe -t points "Warp points" frontend_points && ret=0
          ;;
        bundlephobia)
          _describe -t points "Warp points" frontend_points && ret=0
          ;;
        flowtype)
          _describe -t points "Warp points" frontend_points && ret=0
          ;;
        typescript)
          _describe -t points "Warp points" frontend_points && ret=0
          ;;
        vuejs)
          _describe -t points "Warp points" frontend_points && ret=0
          ;;
        nodejs)
          _describe -t points "Warp points" frontend_points && ret=0
          ;;
        jestjs)
          _describe -t points "Warp points" frontend_points && ret=0
          ;;
      esac
      ;;
  esac

  return $ret
}

_frontend "$@"

# Local Variables:
# mode: Shell-Script
# sh-indentation: 2
# indent-tabs-mode: nil
# sh-basic-offset: 2
# End:
# vim: ft=zsh sw=2 ts=2 et
