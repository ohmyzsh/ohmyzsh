# install in /etc/zsh/zshrc or your personal .zshrc

# traffic_ctl
__traffic_ctl_complete() {

  typeset -a commands alarm_commands cluster_commands metric_commands server_commands storage_commands

  commands+=(
    'alarm[Manipulate alarms]'
    'cluster[Stop, restart and examine the cluster]'
    'config[Manipulate configuration records]'
    'metric[Manipulate performance metrics]'
    'server[Stop, restart and examine the server]'
    'storage[Manipulate cache storage]'
  )
  if (( CURRENT == 2 )); then
    # explain traffic_ctl commands
    _values 'traffic_ctl commands' ${commands[@]}
    return
  fi

  alarm_commands=(
    'clear[Clear all current alarms]'
    'list[List all current alarms]'
    'resolve[Resolve the listed alarms]'
  )

  cluster_commands=(
    'restart[Restart the Traffic Server cluster]'
    'status[Show the cluster status]'
  )

  config_commands=(
    'defaults[Show default information configuration values]'
    'describe[Show detailed information about configuration values]'
    'diff[Show non-default configuration values]'
    'get[Get one or more configuration values]'
    'match[Get configuration matching a regular expression]'
    'reload[Request a configuration reload]'
    'set[Set a configuration value]'
    'status[Check the configuration status]'
  )

  metric_commands=(
    'get[Get one or more metric values]'
    'clear[Clear all metric values]'
    'describe[Show detailed information about one or more metric values]'
    'match[Get metrics matching a regular expression]'
    'monitor[Display the value of a metric over time]'
    'zero[Clear one or more metric values]'
  )

  server_commands=(
    'restart[Restart Traffic Server]'
    'backtrace[Show a full stack trace of the traffic_server process]'
    'status[Show the proxy status]'
  )

  storage_commands=(
    'offline[Take one or more storage volumes offline]'
    'status[Show the storage configuration]'
  )

  case ${words[2]} in
  alarm)
    _values 'traffic_ctl alarm commands' ${alarm_commands[@]}
    ;;
  cluster)
    _values 'traffic_ctl cluster commands' ${cluster_commands[@]}
    ;;
  config)
    _values 'traffic_ctl config commands' ${config_commands[@]}
    ;;
  metric)
    _values 'traffic_ctl metric commands' ${metric_commands[@]}
    ;;
  server)
    _values 'traffic_ctl server commands' ${server_commands[@]}
    ;;
  storage)
    _values 'traffic_ctl storage commands' ${storage_commands[@]}
    ;;
  esac
}

# traffic_cop
__traffic_cop_complete() {

  typeset -a commands

  commands+=(
    '--debug[Enable debug logging]'
    '--stdout[Print log messages to standard output]'
    '--stop[Send child processes SIGSTOP instead of SIGKILL]'
    '--help[Print usage information]'
    '--version[Print version string]'
  )

  _values 'traffic_cop commands' ${commands[@]}
}

# traffic_line
__traffic_line_complete() {

  typeset -a commands 

  commands+=(
    '--query_deadhosts[Query congested sites]'
    '--read_var[Read Variable]'
    '--match_var[Match Variable]'
    '--set_var[Set Variable (requires -v option)]'
    '--value[Set Value (used with -s option)]'
    '--reread_config[Reread Config Files]'
    '--restart_cluster[Restart traffic_manager (cluster wide)]'
    '--restart_local[Restart traffic_manager (local node)]'
    '--shutdown[Shutdown traffic_server (local node)]'
    '--startup[Start traffic_server (local node)]'
    '--bounce_cluster[Bounce traffic_server (cluster wide)]'
    '--bounce_local[Bounce local traffic_server]'
    '--clear_cluster[Clear Statistics (cluster wide)]'
    '--clear_node[Clear Statistics (local node)]'
    '--zero_cluster[Zero Specific Statistic (cluster wide)]'
    '--zero_node[Zero Specific Statistic (local node)]'
    '--offline[Mark cache storage offline]'
    '--alarms[Show all alarms]'
    '--clear_alarms[Clear specified, or all,  alarms]'
    '--status[Show proxy server status]'
    '--backtrace[Show proxy stack backtrace]'
    '--drain[Wait for client connections to drain before restarting]'
    '--help[Print usage information]'
    '--version[Print version string]'
  )

  _values 'traffic_line commands' ${commands[@]}
}

# traffic_logstats
__traffic_logstats_complete() {

  typeset -a commands

  commands+=(
    '--log_file[Specific logfile to parse]'
    '--origin_list[Only show stats for listed Origins]'
    '--origin_file[File listing Origins to show]'
    '--max_orgins[Max number of Origins to show]'
    '--urls[Produce JSON stats for URLs, argument is LRU size]'
    '--show_urls[Only show max this number of URLs]'
    '--as_object[Produce URL stats as a JSON object instead of array]'
    '--incremental[Incremental log parsing]'
    '--statetag[Name of the state file to use]'
    '--tail[Parse the last <sec> seconds of log]'
    '--summary[Only produce the summary]'
    '--json[Produce JSON formatted output]'
    '--cgi[Produce HTTP headers suitable as a CGI]'
    '--min_hits[Minimum total hits for an Origin]'
    '--max_age[Max age for log entries to be considered]'
    '--line_len[Output line length]'
    '--debug_tags[Colon-Separated Debug Tags]'
    '--help[Print usage information]'
    '--version[Print version string]'
  )

  _values 'traffic_logstats commands' ${commands[@]}
}

# traffic_sac
__traffic_sac_complete() {

  typeset -a commands

  commands+=(
    '--help[Print usage information]'
    '--version[Print version string]'
  )

  _values 'traffic_sac commands' ${commands[@]}
}

# traffic_crashlog
__traffic_crashlog_complete() {

  typeset -a commands

  commands+=(
    '--target[Target process ID]'
    '--host[Host triplet for the process being logged]'
    '--wait[Stop until signalled at startup]'
    '--syslog[Syslog after writing a crash log]'
    '--debug[Enable debugging mode]'
    '--help[Print usage information]'
    '--version[Print version string]'
  )

  _values 'traffic_crashlog commands' ${commands[@]}
}

# traffic_layout
__traffic_layout_complete() {

  typeset -a commands

  commands+=(
    '--layout[Show the layout (this is the default with no options given)]'
    '--features[Show the compiled features]'
    '--json[Produce output in JSON format (when supported)]'
    '--help[Print usage information]'
    '--version[Print version string]'
  )

  _values 'traffic_layout commands'  ${commands[@]}
}

# traffic_logcat
__traffic_logcat_complete() {

  typeset -a commands

  commands+=(
    '--output_file[Specify output file]'
    '--auto_filenames[Automatically generate output names]'
    '--follow[Follow the log file as it grows]'
    '--clf[Convert to Common Logging Format]'
    '--elf[Convert to Extended Logging Format]'
    '--squid[Convert to Squid Logging Format]'
    '--debug_tags[Colon-Separated Debug Tags]'
    '--overwrite_output[Overwrite existing output file(s)]'
    '--elf2[Convert to Extended2 Logging Format]'
    '--help[Print usage information]'
    '--version[Print version string]'
  )

  _values 'traffic_logcat commands' ${commands[@]}
}

# traffic_manager
__traffic_manager_complete() {

  typeset -a commands

  commands+=(
    '--proxyOff[Disable proxy]'
    '--aconfPort[Autoconf port]'
    '--clusterMCPort[Cluster multicast port]'
    '--clusterRSPort[Cluster reliable service port]'
    '--groupAddr[Multicast group address]'
    '--path[Path to the management socket]'
    '--recordsConf[Path to records.config]'
    '--tsArgs[Additional arguments for traffic_server]'
    '--proxyPort[HTTP port descriptor]'
    '--proxyBackDoor[Management port]'
    '--bind_stdout[Regular file to bind stdout to]'
    '--bind_stderr[Regular file to bind stderr to]'
    '--debug[Vertical-bar-separated Debug Tags]'
    '--action[Vertical-bar-separated Behavior Tags]'
    '--nosyslog[Do not log to syslog]'
    '--help[Print usage information]'
    '--version[Print version string]'
  )

  _values 'traffic_manager commands' ${commands[@]}
}

# traffic_server
__traffic_server_complete() {

  typeset -a commands

  commands+=(
    '--net_threads[Number of Net Threads]'
    '--cluster_threads[Number of Cluster Threads]'
    '--udp_threads[Number of UDP Threads]'
    '--accept_thread[Use an Accept Thread]'
    '--accept_till_done[Accept Till Done]'
    '--httpport[Port descriptor for HTTP Accept]'
    '--cluster_port[Cluster Port Number]'
    '--dprintf_level[Debug output level]'
    '--disable_freelist[Disable the freelist memory allocator]'
    '--regression[Regression Level (quick:1..long:3)]'
    '--regression_test[Run Specific Regression Test]'
    '--debug_tags[Vertical-bar-separated Debug Tags]'
    '--action_tags[Vertical-bar-separated Behavior Tags]'
    '--interval[Statistics Interval]'
    '--remote_management[Remote Management]'
    '--command[Maintenance Command to Execute]'
    '--conf_dir[config dir to verify]'
    '--clear_hostdb[Clear HostDB on Startup]'
    '--clear_cache[Clear Cache on Startup]'
    '--bind_stdout[Regular file to bind stdout to]'
    '--bind_stderr[Regular file to bind stderr to]'
    '--read_core[Read Core file]'
    '--accept_mss[MSS for client connections]'
    '--poll_timeout[poll timeout in milliseconds]'
    '--help[Print usage information]'
    '--version[Print version string]'
  )

  _values 'traffic_server commands' ${commands[@]}
}

# traffic_via
__traffic_via_complete() {

  typeset -a commands

  commands+=(
    '--help[Print usage information]'
    '--version[Print version string]'
  )

  _values 'traffic_via commands' ${commands[@]}
}


compdef __traffic_ctl_complete traffic_ctl
compdef __traffic_cop_complete traffic_cop
compdef __traffic_line_complete traffic_line
compdef __traffic_logstats_complete traffic_logstats
compdef __traffic_sac_complete traffic_sac
compdef __traffic_crashlog_complete traffic_crashlog
compdef __traffic_layout_complete traffic_layout
compdef __traffic_logcat_complete traffic_logcat
compdef __traffic_manager_complete traffic_manager
compdef __traffic_server_complete traffic_server
compdef __traffic_via_complete traffic_via
