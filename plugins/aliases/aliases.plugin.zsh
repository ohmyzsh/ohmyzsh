# with lots of 3rd-party amazing aliases installed, just need something to explore it quickly.
#
# - acs: alias cheatsheet
#   group alias by command, pass addition argv to grep.
function acs(){
  (( $+commands[python] )) || {
    echo "[error] No python executable detected"
    return
  }
  alias | python ${functions_source[$0]:h}/cheatsheet.py $@
}
