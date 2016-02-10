function set_iterm_profile() {
  echo -e "\033]50;SetProfile=$1\a"
}

function start_dynamic_theme() {
  HOUR=`date +%H`
  if [ $HOUR -ge 8 -a $HOUR -le 17 ]; then
    set_iterm_profile light
  else
    set_iterm_profile dark
  fi
}

start_dynamic_theme &!

while true
do
  start_dynamic_theme
  sleep 600
done
