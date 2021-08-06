# with lots of 3rd-party amazing aliases installed, just need something to explore it quickly.
#
# - acs: alias cheatsheet
#   group alias by command, pass addition argv to grep.
ALIASES_PLUGIN_ROOT=$(cd `dirname $0` && pwd)
function acs(){
    which python >>/dev/null
    [[ $? -eq 1 ]] && echo "[error]no python executable detected!" && return
    alias | python $ALIASES_PLUGIN_ROOT/cheatsheet.py $@
}
