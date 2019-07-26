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
alias qunit='frontend qunit'
alias reactjs='frontend reactjs'
alias smacss='frontend smacss'
alias stackoverflow='frontend stackoverflow'
alias typescript='frontend typescript'
alias unheap='frontend unheap'
alias vuejs='frontend vuejs'

function frontend() {
  emulate -L zsh

  # define search context URLS
  typeset -A urls
  urls=(
    angular        'https://angular.io/?search='
    angularjs      'https://google.com/search?as_sitesearch=angularjs.org&as_q='
    bem            'https://google.com/search?as_sitesearch=bem.info&as_q='
    bootsnipp      'https://bootsnipp.com/search?q='
    bundlephobia   'https://bundlephobia.com/result?p='
    caniuse        'https://caniuse.com/#search='
    codepen        'https://codepen.io/search?q='
    compassdoc     'http://compass-style.org/search?q='
    cssflow        'http://www.cssflow.com/search?q='
    dartlang       'https://api.dartlang.org/apidocs/channels/stable/dartdoc-viewer/dart:'
    emberjs        'https://www.google.com/search?as_sitesearch=emberjs.com/&as_q='
    flowtype       'https://google.com/search?as_sitesearch=flow.org/en/docs/&as_q='
    fontello       'http://fontello.com/#search='
    github         'https://github.com/search?q='
    html5please    'https://html5please.com/#'
    jestjs         'https://www.google.com/search?as_sitesearch=jestjs.io&as_q='
    jquery         'https://api.jquery.com/?s='
    lodash         'https://devdocs.io/lodash/index#'
    mdn            'https://developer.mozilla.org/search?q='
    nodejs         'https://www.google.com/search?as_sitesearch=nodejs.org/en/docs/&as_q='
    npmjs          'https://www.npmjs.com/search?q='
    qunit          'https://api.qunitjs.com/?s='
    reactjs        'https://google.com/search?as_sitesearch=facebook.github.io/react&as_q='
    smacss         'https://google.com/search?as_sitesearch=smacss.com&as_q='
    stackoverflow  'https://stackoverflow.com/search?q='
    typescript     'https://google.com/search?as_sitesearch=www.typescriptlang.org/docs&as_q='
    unheap         'http://www.unheap.com/?s='
    vuejs          'https://www.google.com/search?as_sitesearch=vuejs.org&as_q='
  )

  # show help for command list
  if [[ $# -lt 2 ]]
  then
      print -P "Usage: frontend %Ucontext%u %Uterm%u [...%Umore%u] (or just: %Ucontext%u %Uterm%u [...%Umore%u])"
      print -P ""
      print -P "%Uterm%u and what follows is what will be searched for in the %Ucontext%u website,"
      print -P "and %Ucontext%u is one of the following:"
      print -P ""
      print -P "  angular, angularjs, bem, bootsnipp, caniuse, codepen, compassdoc, cssflow,"
      print -P "  dartlang, emberjs, fontello, flowtype, github, html5please, jestjs, jquery, lodash,"
      print -P "  mdn, npmjs, nodejs, qunit, reactjs, smacss, stackoverflow, unheap, vuejs, bundlephobia"
      print -P ""
      print -P "For example: frontend npmjs mocha (or just: npmjs mocha)."
      print -P ""
      return 1
  fi

  # check whether the search context is supported
  if [[ -z "$urls[$1]" ]]
  then
    echo "Search context \"$1\" currently not supported."
    echo ""
    echo "Valid contexts are:"
    echo ""
    echo "  angular, angularjs, bem, bootsnipp, caniuse, codepen, compassdoc, cssflow,"
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
