# JSON Tools
# Adds command line aliases useful for dealing with JSON

# Check that user-defined method is installed
if [[ -n "$JSONTOOLS_METHOD" ]]; then
  (( $+commands[$JSONTOOLS_METHOD] )) || unset JSONTOOLS_METHOD
fi

# If method undefined, find the first one that is installed
if [[ ! -v JSONTOOLS_METHOD ]]; then
  for JSONTOOLS_METHOD in node python ruby; do
    # If method found, break out of loop
    (( $+commands[$JSONTOOLS_METHOD] )) && break
    # Otherwise unset the variable
    unset JSONTOOLS_METHOD
  done

  # If no methods were found, exit the plugin
  [[ -v JSONTOOLS_METHOD ]] || return 1
fi

# Define json tools for each method
case "$JSONTOOLS_METHOD" in
  node)
    # node doesn't make it easy to deal with stdin, so we pass it as an argument with xargs -0
    function pp_json() {
      xargs -0 node -e 'console.log(JSON.stringify(JSON.parse(process.argv[1]), null, 4));'
    }
    function is_json() {
      xargs -0 node -e '
        try {
          json = JSON.parse(process.argv[1]);
          console.log("true");
          process.exit(0);
        } catch (e) {
          console.log("false");
          process.exit(1);
        }
      '
    }
    function urlencode_json() {
      xargs -0 node -e "console.log(encodeURIComponent(process.argv[1]))"
    }
    function urldecode_json() {
      xargs -0 node -e "console.log(decodeURIComponent(process.argv[1]))"
    }
  ;;
  python)
    function pp_json() {
      python -c 'import sys; del sys.path[0]; import runpy; runpy._run_module_as_main("json.tool")'
    }
    function is_json() {
      python -c '
import sys; del sys.path[0];
import json
try:
  json.loads(sys.stdin.read())
  print("true"); sys.exit(0)
except ValueError:
  print("false"); sys.exit(1)
      '
    }
    function urlencode_json() {
      python -c '
import sys; del sys.path[0];
from urllib.parse import quote_plus
print(quote_plus(sys.stdin.read()))
      '
    }
    function urldecode_json() {
      python -c '
import sys; del sys.path[0];
from urllib.parse import unquote_plus
print(unquote_plus(sys.stdin.read()))
      '
    }
  ;;
  ruby)
    function pp_json() {
      ruby -e '
        require "json"
        require "yaml"
        puts JSON.parse(STDIN.read).to_yaml
      '
    }
    function is_json() {
      ruby -e '
        require "json"
        begin
          puts !!JSON.parse(STDIN.read); exit(0)
        rescue JSON::ParserError
          puts false; exit(1)
        end
      '
    }
    function urlencode_json() {
      ruby -e 'require "cgi"; puts CGI.escape(STDIN.read)'
    }
    function urldecode_json() {
      ruby -e 'require "cgi"; puts CGI.unescape(STDIN.read)'
    }
  ;;
esac
unset JSONTOOLS_METHOD

## Add NDJSON support

function {pp,is,urlencode,urldecode}_ndjson() {
  local json jsonfunc="${0//ndjson/json}"
  while read -r json; do
    $jsonfunc <<< "$json"
  done
}
