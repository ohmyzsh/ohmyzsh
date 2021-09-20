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
    alias pp_json='xargs -0 node -e "console.log(JSON.stringify(JSON.parse(process.argv[1]), null, 4));"'
    alias is_json='xargs -0 node -e "try {json = JSON.parse(process.argv[1]);} catch (e) { console.log(false); json = null; } if(json) { console.log(true); }"'
    alias urlencode_json='xargs -0 node -e "console.log(encodeURIComponent(process.argv[1]))"'
    alias urldecode_json='xargs -0 node -e "console.log(decodeURIComponent(process.argv[1]))"'
  ;;
  python)
    alias pp_json='python -c "import sys; del sys.path[0]; import runpy; runpy._run_module_as_main(\"json.tool\")"'
    alias is_json='python -c "
import sys; del sys.path[0];
import json;
try: 
    json.loads(sys.stdin.read())
except ValueError, e: 
    print False
else:
    print True
sys.exit(0)"'
    alias urlencode_json='python -c "
import sys; del sys.path[0];
import urllib, json;
print urllib.quote_plus(sys.stdin.read())
sys.exit(0)"'
    alias urldecode_json='python -c "
import sys; del sys.path[0];
import urllib, json;
print urllib.unquote_plus(sys.stdin.read())
sys.exit(0)"'
  ;;
  ruby)
    alias pp_json='ruby -e "require \"json\"; require \"yaml\"; puts JSON.parse(STDIN.read).to_yaml"'
    alias is_json='ruby -e "require \"json\"; begin; JSON.parse(STDIN.read); puts true; rescue Exception => e; puts false; end"'
    alias urlencode_json='ruby -e "require \"uri\"; puts URI.escape(STDIN.read)"'
    alias urldecode_json='ruby -e "require \"uri\"; puts URI.unescape(STDIN.read)"'
  ;;
esac

unset JSONTOOLS_METHOD
