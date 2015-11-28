# with lots of 3rd-party amazing aliases installed, just need something to get it quickly.
# 
# use alias as prefix:
# - aliass: search alias
# - aliascs: cheatsheet, group alias by command
function aliass(){
    [[ $# -gt 0 ]] && alias | grep $@
}

function aliascs(){
    local script_root=$(cd `dirname $0` && pwd)
    alias | python $script_root/cheatsheet.py $@
}
