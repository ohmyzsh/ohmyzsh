# bc - An arbitrary precision calculator language
function = 
{
  echo "$@" | bc -l
}

alias calc="="