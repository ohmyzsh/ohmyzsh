if [[ $(acpi | grep -c ^Battery) -gt 0 ]] ; then
  function battery_pct_remaining() { echo "$(acpi | cut -f2 -d ',' | tr -cd '[:digit:]')" }
  function battery_time_remaining() { echo $(acpi | cut -f3 -d ',') }
  function battery_pct_prompt() { echo "%{$fg[red]%}[$(battery_pct_remaining)]%{$reset_color%}" }
else
  error_msg='no battery'
  function battery_pct_remaining() { echo $error_msg }
  function battery_time_remaining() { echo $error_msg }
  function battery_pct_prompt() { echo '' }
fi
