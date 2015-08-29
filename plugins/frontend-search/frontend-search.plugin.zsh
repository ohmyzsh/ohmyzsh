# frontend from terminal

function frontend() {
  emulate -L zsh

  # define search content URLS
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

  # no keyword provided, simply show how call methods
  if [[ $# -le 1 ]]; then
    echo "Please provide a search-content and a search-term for app.\nEx:\nfrontend <search-content> <search-term>\n"
    return 1
  fi

  # check whether the search engine is supported
  if [[ -z "$urls[$1]" ]]; then
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
    echo "* npmjs"
    echo ""

    return 1
  fi

  # build search url:
  # join arguments passed with '+', then append to search engine URL
  # TODO substitute for proper urlencode method
  url="${urls[$1]}${(j:+:)@[2,-1]}"

  echo "$url"

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
