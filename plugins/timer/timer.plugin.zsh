preexec() {
  __timer_cmd_start_time=$(date '+%s')
}

precmd() {
  if [ -n "$__timer_cmd_start_time" ]; then
    local cmd_end_time=$(date '+%s')
    local tdiff=$((cmd_end_time - __timer_cmd_start_time))
    unset __timer_cmd_start_time
    local tdiffstr="$((tdiff / 60))m$((tdiff % 60))s"
    local cols=$((COLUMNS - ${#tdiffstr#0m} - 2))
    echo -e "\033[1A\033[${cols}C \`${tdiffstr#0m}"
  fi
}
