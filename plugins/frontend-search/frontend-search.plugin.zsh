alias angular='frontend angular'
alias angularjs='frontend angularjs'
alias bem='frontend bem'
alias bootsnipp='frontend bootsnipp'
alias bundlephobia='frontend bundlephobia'
alias caniuse='frontend caniuse'
alias codepen='frontend codepen'
alias compassdoc='frontend compassdoc'
alias cssflow='frontend cssflow'
alias dartlang='frontend dartlang'
alias emberjs='frontend emberjs'
alias flowtype='frontend flowtype'
alias fontello='frontend fontello'
alias github='frontend github'
alias html5please='frontend html5please'
alias jestjs='frontend jestjs'
alias jquery='frontend jquery'
alias lodash='frontend lodash'
alias mdn='frontend mdn'
alias nodejs='frontend nodejs'
alias npmjs='frontend npmjs'
alias packagephobia='frontend packagephobia'
alias qunit='frontend qunit'
alias reactjs='frontend reactjs'
alias smacss='frontend smacss'
alias stackoverflow='frontend stackoverflow'
alias typescript='frontend typescript'
alias unheap='frontend unheap'
alias vuejs='frontend vuejs'

function _frontend_fallback() {
  case "$FRONTEND_SEARCH_FALLBACK" in
    duckduckgo) echo "https://duckduckgo.com/?sites=$1&q=" ;;
    *) echo "https://google.com/search?as_sitesearch=$1&as_q=" ;;
  esac
}

function frontend() {
  emulate -L zsh

  # define search context URLS
  local -A urls
  urls=(
    angular        'https://angular.io/?search='
    angularjs      $(_frontend_fallback 'angularjs.org')
    bem            $(_frontend_fallback 'bem.info')
    bootsnipp      'https://bootsnipp.com/search?q='
    bundlephobia   'https://bundlephobia.com/result?p='
    caniuse        'https://caniuse.com/#search='
    codepen        'https://codepen.io/search/pens?q='
    compassdoc     'http://compass-style.org/search?q='
    cssflow        'http://www.cssflow.com/search?q='
    dartlang       'https://api.dartlang.org/apidocs/channels/stable/dartdoc-viewer/dart:'
    emberjs        $(_frontend_fallback 'emberjs.com/')
    flowtype       $(_frontend_fallback 'flow.org/en/docs/')
    fontello       'http://fontello.com/#search='
    github         'https://github.com/search?q='
    html5please    'https://html5please.com/#'
    jestjs         $(_frontend_fallback 'jestjs.io')
    jquery         'https://api.jquery.com/?s='
    lodash         'https://devdocs.io/lodash/index#'
    mdn            'https://developer.mozilla.org/search?q='
    nodejs         $(_frontend_fallback 'nodejs.org/en/docs/')
    npmjs          'https://www.npmjs.com/search?q='
    packagephobia  'https://packagephobia.now.sh/result?p='
    qunit          'https://api.qunitjs.com/?s='
    reactjs        $(_frontend_fallback 'reactjs.org/')
    smacss         $(_frontend_fallback 'smacss.com')
    stackoverflow  'https://stackoverflow.com/search?q='
    typescript     $(_frontend_fallback 'www.typescriptlang.org/docs')
    unheap         'http://www.unheap.com/?s='
    vuejs          $(_frontend_fallback 'vuejs.org')
  )

  # show help for command list
  if [[ $# -lt 2 ]]; then
    print -P "Usage: frontend %Ucontext%u %Uterm%u [...%Umore%u] (or just: %Ucontext%u %Uterm%u [...%Umore%u])"
    print -P ""
    print -P "%Uterm%u and what follows is what will be searched for in the %Ucontext%u website,"
    print -P "and %Ucontext%u is one of the following:"
    print -P ""
    print -P "  angular, angularjs, bem, bootsnipp, caniuse, codepen, compassdoc, cssflow, packagephobia"
    print -P "  dartlang, emberjs, fontello, flowtype, github, html5please, jestjs, jquery, lodash,"
    print -P "  mdn, npmjs, nodejs, qunit, reactjs, smacss, stackoverflow, unheap, vuejs, bundlephobia"
    print -P ""
    print -P "For example: frontend npmjs mocha (or just: npmjs mocha)."
    print -P ""
    return 1
  fi

  # check whether the search context is supported
  if [[ -z "$urls[$1]" ]]; then
    echo "Search context \"$1\" currently not supported."
    echo ""
    echo "Valid contexts are:"
    echo ""
    echo "  angular, angularjs, bem, bootsnipp, caniuse, codepen, compassdoc, cssflow, packagephobia"
    echo "  dartlang, emberjs, fontello, github, html5please, jest, jquery, lodash,"
    echo "  mdn, npmjs, nodejs, qunit, reactjs, smacss, stackoverflow, unheap, vuejs, bundlephobia"
    echo ""
    return 1
  fi

  # build search url:
  # join arguments passed with '%20', then append to search context URL
  url="${urls[$1]}$(omz_urlencode -P ${@[2,-1]})"

  echo "Opening $url ..."

  open_command "$url"
}
