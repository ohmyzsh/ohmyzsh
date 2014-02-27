# JSON Tools
# Adds command line aliases useful for dealing with JSON

if [[ $(whence $JSONTOOLS_METHOD) = "" ]]; then
    JSONTOOLS_METHOD=""
fi

if [[ $(whence node) != "" && ( "x$JSONTOOLS_METHOD" = "x"  || "x$JSONTOOLS_METHOD" = "xnode" ) ]]; then
    alias pp_json='node -e "console.log(JSON.stringify(process.argv[1]), null, 4)"'
elif [[ $(whence python) != "" && ( "x$JSONTOOLS_METHOD" = "x" || "x$JSONTOOLS_METHOD" = "xpython" ) ]]; then
	alias pp_json='python -mjson.tool'
elif [[ $(whence ruby) != "" && ( "x$JSONTOOLS_METHOD" = "x" || "x$JSONTOOLS_METHOD" = "xruby" ) ]]; then
	alias pp_json='ruby -e "require \"json\"; require \"yaml\"; puts JSON.parse(STDIN.read).to_yaml"'
fi

unset JSONTOOLS_METHOD