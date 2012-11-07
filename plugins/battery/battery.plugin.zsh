if [[ $(acpi 2&>/dev/null | grep -c '^Battery.*Discharging') -gt 0 ]] ; then
  function battery_pct_remaining() { echo "$(acpi | cut -f2 -d ',' | tr -cd '[:digit:]')" }
  function battery_time_remaining() { echo $(acpi | cut -f3 -d ',') }
  function battery_pct_prompt() {
    b=$(battery_pct_remaining)
    if [ $b -gt 50 ] ; then
      color='green'
    elif [ $b -gt 20 ] ; then
      color='yellow'
    else
      color='red'
    fi
    echo "%{$fg[$color]%}[$(battery_pct_remaining)%%]%{$reset_color%}"
  }
else
  error_msg='no battery'
  function battery_pct_remaining() { echo $error_msg }
  function battery_time_remaining() { echo $error_msg }
  function battery_pct_prompt() { echo '' }
fi
