if [[ $(acpi 2&>/dev/null | grep -c '^Battery.*Discharging') -gt 0 ]] ; then
  function battery_pct_remaining() { echo "$(acpi | cut -f2 -d ',' | tr -cd '[:digit:]')" }
  function battery_time_remaining() { echo $(acpi | cut -f3 -d ',') }
elif [[ $(pmset -g ps 2&>/dev/null | grep -c -- '-InternalBattery-') -gt 0 ]] ; then
  function battery_pct_remaining() { echo "$(pmset -g ps | tr -cd '[:digit:][:blank:]:' | awk '{print $2}')" }
  function battery_time_remaining() { echo "$(pmset -g ps | tr -cd '[:digit:][:blank:]:' | awk '{print $3}')" }
else
  error_msg='no battery'
  function battery_pct_remaining() { echo $error_msg }
  function battery_time_remaining() { echo $error_msg }
fi

function battery_pct_prompt() {
  b=$(battery_pct_remaining)
  if [[ $b == <-> ]] ; then
    if [ $b -gt 50 ] ; then
      color='green'
    elif [ $b -gt 20 ] ; then
      color='yellow'
    else
      color='red'
    fi
    echo "%{$fg[$color]%}[$b%%]%{$reset_color%}"
  else
    echo ''
  fi
}
