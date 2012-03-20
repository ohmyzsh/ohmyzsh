function limitStringToWidthByMidpoint
{
  local string="$1"
  local width=$2
  if (( ${#string} > $width )); then
    local splitnum=$((collimit/2))
    echo "$(echo $string | cut -c1-$splitnum) ... $(echo $string | cut -c$((${#string}-$splitnum))-)"
  else
    echo $string
  fi
}

function ss
{
  local c=1
  local collimit=$((${COLUMNS-80}-10))
  dirs -p | tail -n+2 | \
  while read f
  do
    echo "$c) "$(limitStringToWidthByMidpoint $f $collimit)
    ((c=c+1))
  done
} 

function csd
{
  local num="${1-}"

  if ! echo "$num" | grep -q '^[0-9][0-9]*$'; then
    local re="$num"
    local num=$(dirs -p | tail -n+2 | grep -n $re | head | cut -f1 -d:)
    if [ -z $num ]; then
      echo "'$re' matched nothing" 1>&2
      return 1
    fi
  elif [ $num -lt 1 ]; then
    echo "usage: csd <number greater than 0 | regex>" 1>&2
    return 1
  fi
  cd +$num
  return $?
} 
