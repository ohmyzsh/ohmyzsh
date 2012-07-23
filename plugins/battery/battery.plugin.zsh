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
elif [[ -e /usr/bin/pmset ]] ; then
  function battery_pct_remaining() { echo "$(pmset -g ps | tr -cd '[:digit:][:blank:]:' | awk '{print $2}')"}
  function battery_time_remaining() { echo "$(pmset -g ps | tr -cd '[:digit:][:blank:]:' | awk '{print $3}')"}
  function battery_pct_prompt() {
    b=$(battery_pct_remaining)
    display=""
    if [[ $1 == steps ]] ; then
      fuel=$(( $b / 12.5 ))
      echo ${(r:$fuel::▁▂▃▄▅▆▇█:)}
    else ;
      fuel=$(( $b / 10 ))
      remainder=$(( 10 - $fuel ))
      echo ${(r:$fuel::▶:)}${(l:$remainder::▷:)}
    fi
  }
else
  error_msg='no battery'
  function battery_pct_remaining() { echo $error_msg }
  function battery_time_remaining() { echo $error_msg }
  function battery_pct_prompt() { echo '' }
fi
