# Systemctl plugin

# Basic service operations
alias sc='sudo systemctl'
alias scr='sudo systemctl restart'
alias scs='sudo systemctl start'
alias sctp='sudo systemctl stop'
alias scst='sudo systemctl status'
alias sce='sudo systemctl enable'
alias scen='sudo systemctl enable --now'
alias scre='sudo systemctl reenable'
alias scd='sudo systemctl disable'
alias scdn='sudo systemctl disable --now'
alias screl='sudo systemctl reload'
alias scres='sudo systemctl restart'
alias sctr='sudo systemctl try-restart'
alias scisol='sudo systemctl isolate'
alias sckill='sudo systemctl kill'
alias scresfail='sudo systemctl reset-failed'
alias scpres='sudo systemctl preset'
alias scmask='sudo systemctl mask'
alias scunmask='sudo systemctl unmask'
alias scmaskn='sudo systemctl mask --now'
alias sclink='sudo systemctl link'
alias scload='sudo systemctl load'
alias sccnl='sudo systemctl cancel'
alias scstenv='sudo systemctl set-environment'
alias scunstenv='sudo systemctl unset-environment'
alias scedt='sudo systemctl edit'
alias scia='systemctl is-active'
alias scie='systemctl is-enabled'
alias scsh='systemctl show'
alias schelp='systemctl help'
alias scshenv='systemctl show-environment'
alias sccat='systemctl cat'

# User-level service operations (without sudo)
alias scu='systemctl --user'
alias scur='systemctl --user restart'
alias scus='systemctl --user start'
alias scup='systemctl --user stop'
alias scust='systemctl --user status'
alias scue='systemctl --user enable'
alias scud='systemctl --user disable'
alias scure='systemctl --user reload'

# List services
alias scls='systemctl list-units --type=service'               
alias sclsa='systemctl list-units --type=service --all'       
alias sclsf='systemctl list-units --type=service --failed'      
alias sclsr='systemctl list-units --type=service --state=running'
alias sclf='systemctl list-unit-files'
alias sclj='systemctl list-jobs'

# List timers
alias sclt='systemctl list-timers'                             
alias sclta='systemctl list-timers --all'                     

# Journalctl shortcuts
alias jc='sudo journalctl'
alias jcf='sudo journalctl -f'                                  
alias jcb='sudo journalctl -b'                                 
alias jcl='sudo journalctl --since "1 hour ago"'              
alias jcu='sudo journalctl -u'                                 

# Function to check service status with concise output
scheck() {
  if [ $# -eq 0 ]; then
    echo "Usage: scheck <service_name>"
    return 1
  fi
  
  local service=$1
  
  if ! systemctl list-unit-files --type=service | grep -q "$service"; then
    echo "Service $service not found!"
    return 1
  fi
  
  local svc_status=$(systemctl is-active "$service")
  local svc_enabled=$(systemctl is-enabled "$service" 2>/dev/null || echo "disabled")
  
  echo -n "Service $service is "
  if [ "$svc_status" = "active" ]; then
    echo -n "\033[32m$svc_status\033[0m"
  else
    echo -n "\033[31m$svc_status\033[0m"
  fi
  
  echo -n " and "
  if [ "$svc_enabled" = "enabled" ]; then
    echo "\033[32m$svc_enabled\033[0m"
  else
    echo "\033[33m$svc_enabled\033[0m"
  fi
}

# Function to toggle service state (start if stopped, stop if started)
stoggle() {
  if [ $# -eq 0 ]; then
    echo "Usage: stoggle <service_name>"
    return 1
  fi
  
  local service=$1
  
  if systemctl is-active "$service" >/dev/null 2>&1; then
    echo "Stopping $service..."
    sudo systemctl stop "$service"
  else
    echo "Starting $service..."
    sudo systemctl start "$service"
  fi
  
  sleep 1
  
  scheck "$service"
}

# Function to restart service and show its status
srestart() {
  if [ $# -eq 0 ]; then
    echo "Usage: srestart <service_name>"
    return 1
  fi
  
  local service=$1
  
  echo "Restarting $service..."
  sudo systemctl restart "$service"
  sleep 1  
  
  scheck "$service"
}

# Function to show the last few log entries for a service
slogs() {
  if [ $# -eq 0 ]; then
    echo "Usage: slogs <service_name> [number_of_lines]"
    return 1
  fi
  
  local service=$1
  local lines=${2:-20}
  
  sudo journalctl -u "$service" -n "$lines" --no-pager
}

# Function to watch logs in real-time for a service
swatchlog() {
  if [ $# -eq 0 ]; then
    echo "Usage: swatchlog <service_name>"
    return 1
  fi
  
  local service=$1
  
  sudo journalctl -u "$service" -f
}

# Function to manage multiple services at once
smulti() {
  if [ $# -lt 2 ]; then
    echo "Usage: smulti [start|stop|restart|status] service1 service2 ..."
    return 1
  fi
  
  local action=$1
  shift
  
  for service in "$@"; do
    echo "=== $service ==="
    case "$action" in
      start)
        sudo systemctl start "$service"
        ;;
      stop)
        sudo systemctl stop "$service"
        ;;
      restart)
        sudo systemctl restart "$service"
        ;;
      status)
        systemctl status "$service" --no-pager
        ;;
      *)
        echo "Unknown action: $action"
        return 1
        ;;
    esac
    echo ""
  done
}

# Function to search for systemd units
sfind() {
  if [ $# -eq 0 ]; then
    echo "Usage: sfind <search_pattern>"
    return 1
  fi
  
  systemctl list-unit-files | grep -i "$1"
}
