alias angularjs='frontend angularjs'
alias aurajs='frontend aurajs'
alias bem='frontend bem'
alias bootsnipp='frontend bootsnipp'
alias caniuse='frontend caniuse'
alias codepen='frontend codepen'
alias compassdoc='frontend compassdoc'
alias cssflow='frontend cssflow'
alias dartlang='frontend dartlang'
alias emberjs='frontend emberjs'
alias fontello='frontend fontello'
alias html5please='frontend html5please'
alias jquery='frontend jquery'
alias lodash='frontend lodash'
alias mdn='frontend mdn'
alias npmjs='frontend npmjs'
alias qunit='frontend qunit'
alias reactjs='frontend reactjs'
alias smacss='frontend smacss'
alias stackoverflow='frontend stackoverflow'
alias unheap='frontend unheap'

function frontend() {
  emulate -L zsh

  # define search context URLS
  typeset -A urls
  urls=(
    angularjs      'https://google.com/search?as_sitesearch=angularjs.org&as_q='
    aurajs         'http://aurajs.com/api/#stq='
    bem            'https://google.com/search?as_sitesearch=bem.info&as_q='
    bootsnipp      'http://bootsnipp.com/search?q='
    caniuse        'http://caniuse.com/#search='
    codepen        'http://codepen.io/search?q='
    compassdoc     'http://compass-style.org/search?q='
    cssflow        'http://www.cssflow.com/search?q='
    dartlang       'https://api.dartlang.org/apidocs/channels/stable/dartdoc-viewer/dart:'
    emberjs        'http://emberjs.com/api/#stp=1&stq='
    fontello       'http://fontello.com/#search='
    html5please    'http://html5please.com/#'
    jquery         'https://api.jquery.com/?s='
    lodash         'https://devdocs.io/lodash/index#'
    mdn            'https://developer.mozilla.org/search?q='
    npmjs          'https://www.npmjs.com/search?q='
    qunit          'https://api.qunitjs.com/?s='
    reactjs        'https://google.com/search?as_sitesearch=facebook.github.io/react&as_q='
    smacss         'https://google.com/search?as_sitesearch=smacss.com&as_q='
    stackoverflow  'http://stackoverflow.com/search?q='
    unheap         'http://www.unheap.com/?s='
  )

  # show help for command list
  if [[ $# -lt 2 ]]
  then
      print -P "Usage: frontend %Ucontext%u %Uterm%u [...%Umore%u] (or just: %Ucontext%u %Uterm%u [...%Umore%u])"
      print -P ""
      print -P "%Uterm%u and what follows is what will be searched for in the %Ucontext%u website,"
      print -P "and %Ucontext%u is one of the following:"
      print -P ""
      print -P "  angularjs, aurajs, bem, bootsnipp, caniuse, codepen, compassdoc, cssflow,"
      print -P "  dartlang, emberjs, fontello, html5please, jquery, lodash, mdn, npmjs,"
      print -P "  qunit, reactjs, smacss, stackoverflow, unheap"
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
    echo "  angularjs, aurajs, bem, bootsnipp, caniuse, codepen, compassdoc, cssflow, "
    echo "  dartlang, emberjs, fontello, html5please, jquery, lodash, mdn, npmjs,  "
    echo "  qunit, reactjs, smacss, stackoverflow, unheap"
    echo ""
    return 1
  fi

  # build search url:
  # join arguments passed with '+', then append to search context URL
  # TODO substitute for proper urlencode method
  url="${urls[$1]}${(j:+:)@[2,-1]}"

  echo "Opening $url ..."

  open_command "$url"
}
