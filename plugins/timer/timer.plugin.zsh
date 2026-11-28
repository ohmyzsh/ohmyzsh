zmodload zsh/datetime

__timer_current_time() {
  zmodload zsh/datetime
  echo $EPOCHREALTIME
}

__timer_format_duration() {
  local -i precision=${TIMER_PRECISION:-1}
  local -i scale=$(( 10 ** precision ))
  # Round to the displayed precision before splitting off the minutes,
  # so that e.g. 59.97s is shown as 1m0.0s instead of 60.0s
  local -i units
  (( units = $1 * scale + 0.5 ))
  local -i mins=$(( units / (60 * scale) ))
  local secs=$(printf "%.${precision}f" $(( (units - 60 * scale * mins) / (scale * 1.0) )))
  local duration_str=$(echo "${mins}m${secs}s")
  local format="${TIMER_FORMAT:-/%d}"
  echo "${format//\%d/${duration_str#0m}}"
}

__timer_save_time_preexec() {
  __timer_cmd_start_time=$(__timer_current_time)
}

__timer_display_timer_precmd() {
  if [ -n "${__timer_cmd_start_time}" ]; then
    local cmd_end_time=$(__timer_current_time)
    local tdiff=$((cmd_end_time - __timer_cmd_start_time))
    unset __timer_cmd_start_time
    if [[ -z "${TIMER_THRESHOLD}" || ${tdiff} -ge "${TIMER_THRESHOLD}" ]]; then
      local last_cmd="${history[$((HISTCMD - 1))]%% *}"
      if [[ "$last_cmd" != clear ]]; then
        local tdiffstr=$(__timer_format_duration ${tdiff})
        local cols=$((COLUMNS - ${#tdiffstr} - 1))
        echo -e "\033[1A\033[${cols}C ${tdiffstr}"
      fi 
    fi
  fi
}

autoload -U add-zsh-hook
add-zsh-hook preexec __timer_save_time_preexec
add-zsh-hook precmd __timer_display_timer_precmd
