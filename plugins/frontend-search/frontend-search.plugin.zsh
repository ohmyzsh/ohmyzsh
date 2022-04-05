<<<<<<< HEAD
# frontend from terminal

function frontend() {

  # get the open command
  local open_cmd
  if [[ $(uname -s) == 'Darwin' ]]; then
    open_cmd='open'
  else
    open_cmd='xdg-open'
  fi

  # no keyword provided, simply show how call methods
  if [[ $# -le 1 ]]; then
    echo "Please provide a search-content and a search-term for app.\nEx:\nfrontend <search-content> <search-term>\n"
    return 1
  fi

  # check whether the search engine is supported
  if [[ ! $1 =~ '(jquery|mdn|compass|html5please|caniuse|aurajs|dartlang|qunit|fontello|bootsnipp|cssflow|codepen|unheap|bem|smacss|angularjs|reactjs|emberjs|stackoverflow)' ]];
  then
    echo "Search valid search content $1 not supported."
    echo "Valid contents: (formats 'frontend <search-content>' or '<search-content>')"
    echo "* jquery"
    echo "* mdn"
    echo "* compass"
    echo "* html5please"
    echo "* caniuse"
    echo "* aurajs"
    echo "* dartlang"
    echo "* lodash"
    echo "* qunit"
    echo "* fontello"
    echo "* bootsnipp"
    echo "* cssflow"
    echo "* codepen"
    echo "* unheap"
    echo "* bem"
    echo "* smacss"
    echo "* angularjs"
    echo "* reactjs"
    echo "* emberjs"
    echo "* stackoverflow"
    echo ""

    return 1
  fi

  local url="http://"
  local query=""

  case "$1" in
    "jquery")
      url="${url}api.jquery.com"
      url="${url}/?s=$2" ;;
    "mdn")
      url="${url}developer.mozilla.org"
      url="${url}/search?q=$2" ;;
    "compass")
      url="${url}compass-style.org"
      url="${url}/search?q=$2" ;;
    "html5please")
      url="${url}html5please.com"
      url="${url}/#$2" ;;
    "caniuse")
      url="${url}caniuse.com"
      url="${url}/#search=$2" ;;
    "aurajs")
      url="${url}aurajs.com"
      url="${url}/api/#stq=$2" ;;
    "dartlang")
      url="${url}api.dartlang.org/apidocs/channels/stable/dartdoc-viewer"
      url="${url}/dart-$2" ;;
    "qunit")
      url="${url}api.qunitjs.com"
      url="${url}/?s=$2" ;;
    "fontello")
      url="${url}fontello.com"
      url="${url}/#search=$2" ;;
    "bootsnipp")
      url="${url}bootsnipp.com"
      url="${url}/search?q=$2" ;;
    "cssflow")
      url="${url}cssflow.com"
      url="${url}/search?q=$2" ;;
    "codepen")
      url="${url}codepen.io"
      url="${url}/search?q=$2" ;;
    "unheap")
      url="${url}www.unheap.com"
      url="${url}/?s=$2" ;;
    "bem")
      url="${url}google.com"
      url="${url}/search?as_q=$2&as_sitesearch=bem.info" ;;
    "smacss")
      url="${url}google.com"
      url="${url}/search?as_q=$2&as_sitesearch=smacss.com" ;;
    "angularjs")
      url="${url}google.com"
      url="${url}/search?as_q=$2&as_sitesearch=angularjs.org" ;;
    "reactjs")
      url="${url}google.com"
      url="${url}/search?as_q=$2&as_sitesearch=facebook.github.io/react" ;;
    "emberjs")
      url="${url}emberjs.com"
      url="${url}/api/#stq=$2&stp=1" ;;
    "stackoverflow")
      url="${url}stackoverflow.com"
      url="${url}/search?q=$2" ;;
    *) echo "INVALID PARAM!"
       return ;;
  esac

  echo "$url"

  $open_cmd "$url"

}

# javascript
alias jquery='frontend jquery'
alias mdn='frontend mdn'

# pre processors frameworks
alias compassdoc='frontend compass'

# important links
alias html5please='frontend html5please'
alias caniuse='frontend caniuse'

# components and libraries
alias aurajs='frontend aurajs'
alias dartlang='frontend dartlang'
alias lodash='frontend lodash'

#tests
alias qunit='frontend qunit'

#fonts
alias fontello='frontend fontello'

# snippets
alias bootsnipp='frontend bootsnipp'
alias cssflow='frontend cssflow'
alias codepen='frontend codepen'
alias unheap='frontend unheap'

# css architecture
alias bem='frontend bem'
alias smacss='frontend smacss'

# frameworks
alias angularjs='frontend angularjs'
alias reactjs='frontend reactjs'
alias emberjs='frontend emberjs'

# search websites
alias stackoverflow='frontend stackoverflow'
=======
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
  # TODO substitute for proper urlencode method
  url="${urls[$1]}${(j:%20:)@[2,-1]}"

  echo "Opening $url ..."

  open_command "$url"
}
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
