# web_search from terminal
function web_search() {
  emulate -L zsh

  # define search engine URLS
  typeset -A urls
  urls=(
    $ZSH_WEB_SEARCH_ENGINES  # Allow custom engine definitions
    google          "https://www.google.com/search?q="
    bing            "https://www.bing.com/search?q="
    brave           "https://search.brave.com/search?q="
    yahoo           "https://search.yahoo.com/search?p="
    duckduckgo      "https://www.duckduckgo.com/?q="
    startpage       "https://www.startpage.com/do/search?q="
    yandex          "https://yandex.ru/yandsearch?text="
    github          "https://github.com/search?q="
    baidu           "https://www.baidu.com/s?wd="
    ecosia          "https://www.ecosia.org/search?q="
    goodreads       "https://www.goodreads.com/search?q="
    qwant           "https://www.qwant.com/?q="
    givero          "https://www.givero.com/search?q="
    stackoverflow   "https://stackoverflow.com/search?q="
    wolframalpha    "https://www.wolframalpha.com/input/?i="
    archive         "https://web.archive.org/web/*/"
    scholar         "https://scholar.google.com/scholar?q="
    ask             "https://www.ask.com/web?q="
    youtube         "https://www.youtube.com/results?search_query="
    deepl           "https://www.deepl.com/translator#auto/auto/"
    dockerhub       "https://hub.docker.com/search?q="
    npmpkg          "https://www.npmjs.com/search?q="
    packagist       "https://packagist.org/?query="
    gopkg           "https://pkg.go.dev/search?m=package&q="
    chatgpt         "https://chat.openai.com"  # Updated to correct URL
    reddit          "https://www.reddit.com/search/?q="
  )

  # Function to print available search engines
  function print_engines() {
    echo "Available search engines:"
    for key in ${(k)urls}; do
      echo "  - $key"
    done
  }

  # Show help if no arguments or help flag
  if [[ $# -eq 0 ]] || [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
    echo "Usage: web_search <engine> [search terms]"
    echo "Example: web_search google hello world"
    print_engines
    return 0
  }

  # Check whether the search engine is supported
  if [[ -z "$urls[$1]" ]]; then
    echo "Error: Search engine '$1' not supported."
    print_engines
    return 1
  }

  # Search or go to main page depending on number of arguments passed
  if [[ $# -gt 1 ]]; then
    # Determine URL encoding parameter based on query string format
    local param="-P"
    [[ "$urls[$1]" == *\?*= ]] && param=""

    # Build search url by joining arguments and appending to search engine URL
    url="${urls[$1]}$(omz_urlencode $param ${@[2,-1]})"
  else
    # Build main page url by splitting and rejoining protocol and domain parts
    url="${(j://:)${(s:/:)urls[$1]}[1,2]}"
  fi

  # Open URL in default browser
  if command -v xdg-open >/dev/null 2>&1; then
    xdg-open "$url"  # Linux
  elif command -v open >/dev/null 2>&1; then
    open "$url"      # macOS
  elif command -v start >/dev/null 2>&1; then
    start "$url"     # Windows
  else
    echo "Error: Could not detect a command to open URLs"
    echo "URL: $url"
    return 1
  fi
}

# Define search engine aliases
alias bing='web_search bing'
alias brs='web_search brave'
alias google='web_search google'
alias yahoo='web_search yahoo'
alias ddg='web_search duckduckgo'
alias sp='web_search startpage'
alias yandex='web_search yandex'
alias github='web_search github'
alias baidu='web_search baidu'
alias ecosia='web_search ecosia'
alias goodreads='web_search goodreads'
alias qwant='web_search qwant'
alias givero='web_search givero'
alias stackoverflow='web_search stackoverflow'
alias wolframalpha='web_search wolframalpha'
alias archive='web_search archive'
alias scholar='web_search scholar'
alias ask='web_search ask'
alias youtube='web_search youtube'
alias deepl='web_search deepl'
alias dockerhub='web_search dockerhub'
alias npmpkg='web_search npmpkg'
alias packagist='web_search packagist'
alias gopkg='web_search gopkg'
alias chatgpt='web_search chatgpt'
alias reddit='web_search reddit'

# DuckDuckGo !bang searches
alias wiki='web_search duckduckgo \!w'
alias news='web_search duckduckgo \!n'
alias map='web_search duckduckgo \!m'
alias image='web_search duckduckgo \!i'
alias ducky='web_search duckduckgo \!'

# Add custom search engine aliases if defined
if [[ ${#ZSH_WEB_SEARCH_ENGINES} -gt 0 ]]; then
  typeset -A engines
  engines=($ZSH_WEB_SEARCH_ENGINES)
  for key in ${(k)engines}; do
    alias "$key"="web_search $key"
  done
  unset engines key
fi
