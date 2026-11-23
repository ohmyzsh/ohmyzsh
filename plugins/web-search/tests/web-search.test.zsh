#!/usr/bin/env zsh

# Run with: zsh -df plugins/web-search/tests/web-search.test.zsh
emulate -L zsh

source "${0:A:h:h:h:h}/lib/functions.zsh"
source "${0:A:h:h}/web-search.plugin.zsh"

# Print the URL instead of opening a browser.
open_command() { print -r -- "$1" }

local -i failures=0

check_url() {
  local expected=$1; shift
  local actual=$(web_search "$@")
  if [[ $actual != "$expected" ]]; then
    print -u2 -r -- "FAIL: web_search ${(j: :)${(q-)@}}"
    print -u2 -r -- "  expected: $expected"
    print -u2 -r -- "  actual:   $actual"
    (( ++failures ))
    return
  fi
  print -r -- "PASS: web_search ${(j: :)${(q-)@}}"
}

# Query-string engines: reserved characters must not leak into the URL.
check_url 'https://www.google.com/search?q=c%2B%2B+templates' google 'c++' templates
check_url 'https://www.google.com/search?q=AT%26T+stock' google 'AT&T' stock
check_url 'https://www.duckduckgo.com/?q=a%3Db%3B+c' duckduckgo 'a=b;' c
check_url 'https://www.google.com/search?q=what+is+50%25+of+10%3F' google what is 50% of '10?'

# Unchanged cases: plain words, bangs, path-style engines and the main page.
check_url 'https://www.google.com/search?q=hello+world' google hello world
check_url 'https://www.duckduckgo.com/?q=!w+zsh' duckduckgo '!w' zsh
check_url 'https://www.deepl.com/translator#auto/auto/hello%20world' deepl hello world
check_url 'https://web.archive.org/web/*/https://example.com/a' archive https://example.com/a
check_url 'https://www.google.com' google

(( failures == 0 )) || exit 1
print 'All web-search tests passed.'
