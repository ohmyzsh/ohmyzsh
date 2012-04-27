# Grep out of ps.  Cut to 80 chars
function psgrep 
{ 
   /bin/ps alxw |head -1
   /bin/ps alxw |grep $1 |grep -v "grep $1" |cut -c 1-$COLUMNS
}

