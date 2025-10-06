###########################################
# Battery plugin for oh-my-zsh            #
# Original Author: Peter hoeg (peterhoeg) #
# Email: peter@speartail.com              #
###########################################
# Author: Sean Jones (neuralsandwich)     #
# Email: neuralsandwich@gmail.com         #
# Modified to add support for Apple Mac   #
###########################################
# Author: J (927589452)                   #
# Modified to add support for FreeBSD     #
###########################################
# Author: Avneet Singh (kalsi-avneet)     #
# Modified to add support for Android     #
###########################################
# Author: Not Pua (im-notpua)             #
# Modified to add support for OpenBSD     #
###########################################

: ${BATTERY_SHOW_WATTS:=false}


if [[ "$OSTYPE" = darwin* ]]; then
  function get_charger_power() {
    echo "$(ioreg -rc AppleSmartBattery | grep -o '"Watts"=[0-9]\+' | head -1 | grep -o '[0-9]\+')W "
  }
  function battery_is_charging() {
    ioreg -rc AppleSmartBattery | command grep -q '^.*"ExternalConnected"\ =\ Yes'
  }
  function battery_pct() {
    pmset -g batt | grep -Eo "\d+%" | cut -d% -f1
  }
  function battery_pct_remaining() {
    if battery_is_charging; then
      echo "External Power"
    else
      battery_pct
    fi
  }
  function battery_time_remaining() {
    local smart_battery_status="$(ioreg -rc "AppleSmartBattery")"
    if [[ $(echo $smart_battery_status | command grep -c '^.*"ExternalConnected"\ =\ No') -eq 1 ]]; then
      timeremaining=$(echo $smart_battery_status | command grep '^.*"AvgTimeToEmpty"\ =\ ' | sed -e 's/^.*"AvgTimeToEmpty"\ =\ //')
      if [ $timeremaining -gt 720 ]; then
        echo "::"
      else
        echo "~$((timeremaining / 60)):$((timeremaining % 60))"
      fi
    else
      echo "∞"
    fi
  }
  function battery_pct_prompt () {
    local battery_pct color
    if ioreg -rc AppleSmartBattery | command grep -q '^.*"ExternalConnected"\ =\ No'; then
      battery_pct=$(battery_pct_remaining)
      if [[ $battery_pct -gt 50 ]]; then
        color='green'
      elif [[ $battery_pct -gt 20 ]]; then
        color='yellow'
      else
        color='red'
      fi
      echo "%{$fg[$color]%}[${battery_pct}%%]%{$reset_color%}"
    else
      if [[ "${BATTERY_SHOW_WATTS}" = "true" ]] ; then
        watts=$(get_charger_power)
      fi
      echo "${watts}${BATTERY_CHARGING-⚡️}"
    fi
  }

elif [[ "$OSTYPE" = freebsd* ]]; then
  function battery_is_charging() {
    [[ $(sysctl -n hw.acpi.battery.state) -eq 2 ]]
  }
  function battery_pct() {
    if (( $+commands[sysctl] )); then
      sysctl -n hw.acpi.battery.life
    fi
  }
  function battery_pct_remaining() {
    if ! battery_is_charging; then
      battery_pct
    else
      echo "External Power"
    fi
  }
  function battery_time_remaining() {
    local remaining_time
    remaining_time=$(sysctl -n hw.acpi.battery.time)
    if [[ $remaining_time -ge 0 ]]; then
      ((hour = $remaining_time / 60 ))
      ((minute = $remaining_time % 60 ))
      printf %02d:%02d $hour $minute
    fi
  }
  function battery_pct_prompt() {
    local battery_pct color
    battery_pct=$(battery_pct_remaining)
    if battery_is_charging; then
      echo "∞"
    else
      if [[ $battery_pct -gt 50 ]]; then
        color='green'
      elif [[ $battery_pct -gt 20 ]]; then
        color='yellow'
      else
        color='red'
      fi
      echo "%{$fg[$color]%}${battery_pct}%%%{$reset_color%}"
    fi
  }
elif [[ "$OSTYPE" = linux-android ]] && (( ${+commands[termux-battery-status]} )); then
  function battery_is_charging() {
    termux-battery-status 2>/dev/null | command awk '/status/ { exit ($0 ~ /DISCHARGING/) }'
  }
  function battery_pct() {
    # Sample output:
    # {
    #   "health": "GOOD",
    #   "percentage": 93,
    #   "plugged": "UNPLUGGED",
    #   "status": "DISCHARGING",
    #   "temperature": 29.0,
    #   "current": 361816
    # }
    termux-battery-status 2>/dev/null | command awk '/percentage/ { gsub(/[,]/,""); print $2}'
  }
  function battery_pct_remaining() {
    if ! battery_is_charging; then
      battery_pct
    else
      echo "External Power"
    fi
  }
  function battery_time_remaining() { } # Not available on android
  function battery_pct_prompt() {
    local battery_pct color
    battery_pct=$(battery_pct_remaining)
    if battery_is_charging; then
      echo "∞"
    else
      if [[ $battery_pct -gt 50 ]]; then
        color='green'
      elif [[ $battery_pct -gt 20 ]]; then
        color='yellow'
      else
        color='red'
      fi
      echo "%{$fg[$color]%}${battery_pct}%%%{$reset_color%}"
    fi
  }
elif [[ "$OSTYPE" = openbsd* ]]; then
  function battery_is_charging() {
    [[ $(apm -b) -eq 3 ]]
  }
  function battery_pct() {
    apm -l
  }
  function battery_pct_remaining() {
    if ! battery_is_charging; then
      battery_pct
    else
      echo "External Power"
    fi
  }
  function battery_time_remaining() {
    local remaining_time
    remaining_time=$(apm -m)
    if [[ $remaining_time -ge 0 ]]; then
      ((hour = $remaining_time / 60 ))
      ((minute = $remaining_time % 60 ))
      printf %02d:%02d $hour $minute
    fi
  }
  function battery_pct_prompt() {
    local battery_pct color
    battery_pct=$(battery_pct_remaining)
    if battery_is_charging; then
      echo "∞"
    else
      if [[ $battery_pct -gt 50 ]]; then
        color='green'
      elif [[ $battery_pct -gt 20 ]]; then
        color='yellow'
      else
        color='red'
      fi
      echo "%{$fg[$color]%}${battery_pct}%%%{$reset_color%}"
    fi
  }

elif [[ "$OSTYPE" = linux*  ]]; then
  function battery_is_charging() {
    if (( $+commands[acpitool] )); then
      ! acpitool 2>/dev/null | command grep -qE '^\s+Battery.*Discharging'
    elif (( $+commands[acpi] )); then
      ! acpi 2>/dev/null | command grep -v "rate information unavailable" | command grep -q '^Battery.*Discharging'
    fi
  }
  function battery_pct() {
    if (( $+commands[acpitool] )); then
      # Sample output:
      #   Battery #1     : Unknown, 99.55%
      #   Battery #2     : Discharging, 49.58%, 01:12:05
      #   All batteries  : 62.60%, 02:03:03
      local -i pct=$(acpitool 2>/dev/null | command awk -F, '
        /^\s+All batteries/ {
          gsub(/[^0-9.]/, "", $1)
          pct=$1
          exit
        }
        !pct && /^\s+Battery/ {
          gsub(/[^0-9.]/, "", $2)
          pct=$2
        }
        END { print pct }
        ')
      echo $pct
    elif (( $+commands[acpi] )); then
      # Sample output:
      # Battery 0: Discharging, 0%, rate information unavailable
      # Battery 1: Full, 100%
      acpi 2>/dev/null | command awk -F, '
        /rate information unavailable/ { next }
        /^Battery.*: /{ gsub(/[^0-9]/, "", $2); print $2; exit }
      '
    fi
  }
  function battery_pct_remaining() {
    if ! battery_is_charging; then
      battery_pct
    else
      echo "External Power"
    fi
  }
  function battery_time_remaining() {
    if ! battery_is_charging; then
      acpi 2>/dev/null | command grep -v "rate information unavailable" | cut -f3 -d ','
    fi
  }
  function battery_pct_prompt() {
    local battery_pct color
    battery_pct=$(battery_pct_remaining)
    if battery_is_charging; then
      echo "∞"
    else
      if [[ $battery_pct -gt 50 ]]; then
        color='green'
      elif [[ $battery_pct -gt 20 ]]; then
        color='yellow'
      else
        color='red'
      fi
      echo "%{$fg[$color]%}${battery_pct}%%%{$reset_color%}"
    fi
  }
else
  # Empty functions so we don't cause errors in prompts
  function battery_is_charging { false }
  function battery_pct \
    battery_pct_remaining \
    battery_time_remaining \
    battery_pct_prompt { }
fi

function battery_level_gauge() {
  local gauge_slots=${BATTERY_GAUGE_SLOTS:-10}
  local green_threshold=${BATTERY_GREEN_THRESHOLD:-$(( gauge_slots * 0.6 ))}
  local yellow_threshold=${BATTERY_YELLOW_THRESHOLD:-$(( gauge_slots * 0.4 ))}
  local color_green=${BATTERY_COLOR_GREEN:-%F{green}}
  local color_yellow=${BATTERY_COLOR_YELLOW:-%F{yellow}}
  local color_red=${BATTERY_COLOR_RED:-%F{red}}
  local color_reset=${BATTERY_COLOR_RESET:-%{%f%k%b%}}
  local battery_prefix=${BATTERY_GAUGE_PREFIX:-'['}
  local battery_suffix=${BATTERY_GAUGE_SUFFIX:-']'}
  local filled_symbol=${BATTERY_GAUGE_FILLED_SYMBOL:-'▶'}
  local empty_symbol=${BATTERY_GAUGE_EMPTY_SYMBOL:-'▷'}
  local charging_color=${BATTERY_CHARGING_COLOR:-$color_yellow}
  local charging_symbol=${BATTERY_CHARGING_SYMBOL:-'⚡'}

  local -i battery_remaining_percentage=$(battery_pct)
  local filled empty gauge_color

  if [[ $battery_remaining_percentage =~ [0-9]+ ]]; then
    filled=$(( ($battery_remaining_percentage * $gauge_slots) / 100 ))
    empty=$(( $gauge_slots - $filled ))

    if [[ $filled -gt $green_threshold ]]; then
      gauge_color=$color_green
    elif [[ $filled -gt $yellow_threshold ]]; then
      gauge_color=$color_yellow
    else
      gauge_color=$color_red
    fi
  else
    filled=$gauge_slots
    empty=0
    filled_symbol=${BATTERY_UNKNOWN_SYMBOL:-'.'}
  fi

  local charging=' '
  battery_is_charging && charging=$charging_symbol

  # Charging status and prefix
  print -n ${charging_color}${charging}${color_reset}${battery_prefix}${gauge_color}
  # Filled slots
  [[ $filled -gt 0 ]] && printf ${filled_symbol//\%/\%\%}'%.0s' {1..$filled}
  # Empty slots
  [[ $filled -lt $gauge_slots ]] && printf ${empty_symbol//\%/\%\%}'%.0s' {1..$empty}
  # Suffix
  print -n ${color_reset}${battery_suffix}${color_reset}
}
