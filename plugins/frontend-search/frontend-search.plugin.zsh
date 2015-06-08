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
