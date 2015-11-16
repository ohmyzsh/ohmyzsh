__timer_current_time() {
  perl -MTime::HiRes=time -e'print time'
}

__timer_format_duration() {
  local mins=$(printf '%.0f' $(($1 / 60)))
  local secs=$(printf '%.1f' $(($1 - 60 * mins)))
  local duration_str=$(echo "${mins}m${secs}s")
  echo "\`${duration_str#0m}"
}

preexec() {
  __timer_cmd_start_time=$(__timer_current_time)
}

precmd() {
  if [ -n "${__timer_cmd_start_time}" ]; then
    local cmd_end_time=$(__timer_current_time)
    local tdiff=$((cmd_end_time - __timer_cmd_start_time))
    unset __timer_cmd_start_time
    local tdiffstr=$(__timer_format_duration ${tdiff})
    local cols=$((COLUMNS - ${#tdiffstr} - 1))
    echo -e "\033[1A\033[${cols}C ${tdiffstr}"
  fi
}
