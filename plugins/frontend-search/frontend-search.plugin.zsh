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
    compass        'http://compass-style.org/search?q='
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
      print -P "  angularjs, aurajs, bem, bootsnipp, caniuse, codepen, compass, cssflow,"
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
    echo "  angularjs, aurajs, bem, bootsnipp, caniuse, codepen, compass, cssflow, "
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
alias npmjs='frontend npmjs'
