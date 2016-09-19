# ------------------------------------------------------------------------------
#  @brief oh-my-zsh plugin for ROS framework.
#  @author Mickael GERMAIN (https://github.com/migermain)
#  @version 1.0.0
#
#  This oh-my-zsh plugin attempts to help manage ros ecosystem settings and
#  perform automatic configurations as often as possible.
#  It also supplies prompt integration to give informations about ros state.
#
# ------------------------------------------------------------------------------

[ -z "$_OMZ_ROS_DIR" ] && readonly _OMZ_ROS_DIR="${0:A:h}"

rosmaster() {

  [ $# -eq 0 ] && echo "$ROS_MASTER_URI" | sed -r 's#http://([^:]+):11311#\1#' \
  && return 0

  local master_ip_tag='master_ip'
  local masters="$(_omz_ros_config_get_line $master_ip_tag)"
  local finded=""

  [ $# -eq 2 ] && finded=$(echo "$masters" | grep -o "$2")

  case "$1" in
    list)
      [ $# -ne 1 ] && >&2 echo "Usage : $0 list" && return 1
      echo "$masters" | sed -r 's#\s+#\n#g'
      ;;

    add)
      [ $# -ne 2 ] && >&2 echo "Usage : $0 add <new_ros_master_ip>" && return 1
      [ "$finded" ] && >&2 echo "Master IP $2 is already registered" && return 3
      _omz_ros_config_add_to_line "$master_ip_tag" "$2"
      ;;

    remove)
      [ $# -ne 2 ] && \
      >&2 echo "Usage : $0 remove <ros_registered_master_ip_to_remove>" &&
      return 1
      [ -z "$finded" ] && >&2 echo "Master IP $2 is not registered" && return 3
      _omz_ros_config_remove_from_line "$master_ip_tag" "$2"
      ;;

    default)
      local master_ip_default_tag='master_ip_default'
      [ $# -ne 2 ] && >&2 echo "Usage : $0 default <ros_master_ip>" && return 1
      [ ! "$finded" ] && _omz_ros_config_add_to_line "$master_ip_default_tag" "$2"
      _omz_ros_config_set_line "$master_ip_default_tag" "$2"
      ;;

    set)
      if [ $# -eq 3 ]; then
        rosinterface set "$3" && \
        export ROS_MASTER_URI="http://$2:11311" || return "$?"
      elif [ $# -eq 2 ]; then
        export ROS_MASTER_URI="http://$2:11311"
      else
        >&2 echo "Usage : $0 set <ros_master_ip> <ros_workspace>" && return 1
      fi
      ;;

    autoset)
      [ $# -ne 1 ] && >&2 echo "Usage : $0 autoset" && return 1
      local master_ip_default=$(_omz_ros_config_get_line 'master_ip_default')
      rosmaster set "$master_ip_default"
      ;;

    *)
      >&2 echo "Usage : $0 <command> [option]" && return 1
      ;;
  esac

  return 0
}

rosinterface() {

  [ $# -eq 0 ] && echo "$ROS_IP" && return 0

  local ros_interface_tag='ros_interface'
  local ros_interfaces="$(_omz_ros_config_get_line $ros_interface_tag)"
  local finded=""

  [ $# -eq 2 ] && finded=$(echo "$ros_interfaces" | grep -o "$2")

  case "$1" in
    list)
      [ $# -ne 1 ] && >&2 echo "Usage : $0 list" && return 1
      echo "$ros_interfaces" | sed -r 's#\s+#\n#g'
      ;;

    add)
      [ $# -ne 2 ] && >&2 echo "Usage : $0 add <new_ros_interface>" && return 1
      local exist=$(_omz_ros_interface_get_list | grep -o "$2")
      [ ! "$exist" ] && >&2 echo "Interface $2 does not exist" && return 3
      [ "$finded" ] && >&2 echo "Interface $2 is already registered" && return 3
      _omz_ros_config_add_to_line "$ros_interface_tag" "$2"
      ;;

    remove)
      [ $# -ne 2 ] && \
      >&2 echo "Usage : $0 remove <ros_registered_ros_interface_to_remove>" && \
      return 1
      [ ! "$finded" ] && >&2 echo "Interface $2 is not registered" && return 3
      _omz_ros_config_remove_from_line "$ros_interface_tag" "$2"
      ;;

    up)
      [ $# -ne 2 ] && >&2 echo "Usage : $0 up <ros_registered_interface>" && \
      return 1
      [ ! "$finded" ] && >&2 echo "Interface $2 is not registered" && return 3
      _omz_ros_config_up "$ros_interface_tag" "$2"
      ;;

    down)
      [ $# -ne 2 ] && >&2 echo "Usage : $0 down <ros_registered_interface>" && \
      return 1
      [ ! "$finded" ] && >&2 echo "Interface $2 is not registered" && return 3
      _omz_ros_config_down "$ros_interface_tag" "$2"
      ;;

    set)
      [ $# -ne 2 ] && >&2 echo "Usage : $0 set <ros_interface>" && return 1
      local available=$(_omz_ros_interface_get_available | grep -o "$2")
      [ ! "$available" ] && >&2 echo "Interface $2 is not available" && return 3
      export ROS_IP=$(_omz_ros_interface_to_ip "$2")
      ;;

    autoset)
      [ $# -ne 1 ] && >&2 echo "Usage : $0 autoset" && return 1
      local ros_interfaces_candidate="$(echo "$ros_interfaces" |
      egrep "$(_omz_ros_interface_get_available | tr ' ' '|')")"
      local ros_interface=""
      for ros_interface in $(echo "$ros_interfaces_candidate"); do
        local ip=$(_omz_ros_interface_to_ip "$ros_interface")
        if [ "$ip" ]; then
          export ROS_IP="$ip"
          break
        fi
      done
      ;;

    *)
      >&2 echo "Usage : $0 <command> [option]" && return 1
      ;;
  esac

  return 0
}

rosdistro() {

  [ $# -eq 0 ] && \
  echo "$ROS_DISTRO" && return 0

  case "$1" in
    list)
      [ $# -ne 1 ] && >&2 echo "Usage : $0 list" && return 1
      _omz_ros_distro_get_list | sed -r 's#\s+#\n#g'
      ;;

    default)
      [ $# -ne 2 ] && >&2 echo "Usage : $0 default <ros_distro>" && return 1
      local exist=$(_omz_ros_distro_get_list | grep -o "$2")
      [ ! "$exist" ] && >&2 echo "Distro $2 is not available" && return 3
      _omz_ros_config_set_line "ros_distro_default" "$2"
      ;;

    set)
      [ $# -ne 2 ] && >&2 echo "Usage : $0 set <ros_distro>" && return 1
      local exist=$(_omz_ros_distro_get_list | grep -o "$2")
      [ ! "$exist" ] && >&2 echo "Distro $2 is not available" && return 3
      source "/opt/ros/$2/setup.zsh"
      ;;

    autoset)
      [ $# -ne 1 ] && >&2 echo "Usage : $0 autoset" && return 1
      local ros_distro_default=$(_omz_ros_config_get_line 'ros_distro_default')
      [ ! "$ros_distro_default" ] && >&2 echo "Default distro not set" && \
      return 3
      rosdistro set "$ros_distro_default"
      ;;

    *)
      >&2 echo "Usage : $0 <command> [option]" && return 1
      ;;
  esac

  return 0
}

rosworkspace() {

  [ $# -eq 0 ] && echo "$ROS_PACKAGE_PATH" | tr ':' '\n' | grep -v '/opt/ros/' |
  sed 's#/src$##' && return 0

  local ros_workspace_tag='ros_workspace'
  local workspaces="$(_omz_ros_config_get_line "$ros_workspace_tag")"
  local finded=""
  local workspace_candidate=""

  [ $# -eq 2 ] && workspace_candidate="$(readlink -e "$2")" && \
  finded=$(echo "$workspaces" | grep -o "$workspace_candidate")
  case "$1" in
    list)
      [ $# -ne 1 ] && >&2 echo "Usage : $0 list" && return 1
      echo "$workspaces" | sed -r 's#\s+#\n#g'
      ;;

    add)
      [ $# -ne 2 ] && >&2 echo "Usage : $0 add <new_ros_workspace>" && return 1
      [ ! -f "$workspace_candidate/.catkin_workspace" ] && \
      >&2 echo "Workspace $workspace_candidate does not exist" && return 3
      [ "$finded" ] && \
      >&2 echo "Workspace $workspace_candidate is already registered" && \
      return 3
      _omz_ros_config_add_to_line "$ros_workspace_tag" "$workspace_candidate"
      ;;

    remove)
      [ $# -ne 2 ] && \
       echo "Usage : $0 remove <ros_registered_workspace_to_remove>" && \
      return 1
      [ ! "$finded" ] && \
      >&2 echo "Workspace $workspace_candidate is not registered" && return 3
      _omz_ros_config_remove_from_line "$ros_workspace_tag" \
      "$workspace_candidate"
      ;;

      ;;

    *)
      >&2 echo "Usage : $0 <command> [option]" && return 1
      ;;
  esac

  return 0
}

_omz_ros_config_init() {
  [ ! -d "$ZSH_CACHE_DIR" ] && mkdir -p "$ZSH_CACHE_DIR"
  if [ ! -f "$ZSH_CACHE_DIR/ros.cache" ]; then
    cp "$_OMZ_ROS_DIR/ros.cache.default" "$ZSH_CACHE_DIR/ros.cache" || \
    return "$?"
    [ ! "$(_omz_ros_config_get_line 'ros_distro_default')" ] && \
    _omz_ros_config_set_line 'ros_distro_default' \
    $(_omz_ros_distro_get_list | tail -n 1) || return "$?"
  fi

  return 0
}

_omz_ros_config_get_line() {
  cat "$ZSH_CACHE_DIR/ros.cache" |
  grep "^\s*$1\s*=" | sed -r 's#^.*=\s*(.*)$#\1#'
}

_omz_ros_config_set_line() {
  _omz_ros_config_do "$1" '=.*$' "= $2"
}

_omz_ros_config_up() {
  _omz_ros_config_do "$1" "([^\s=]+)\s+$2" "$2 \1"
}

_omz_ros_config_down() {
  _omz_ros_config_do "$1" "$2\s+([^\s]*)" "\1 $2"
}

_omz_ros_config_add_to_line() {
  _omz_ros_config_do "$1" '\s*$' " $2"
}

_omz_ros_config_remove_from_line() {
  _omz_ros_config_do "$1" "\s*$2\s*" ' '
}

_omz_ros_config_do() {
  local line_exist="$(cat "$ZSH_CACHE_DIR/ros.cache" | grep "^\s*$1\s*=" )"
  [ ! "$line_exist" ] && echo "$1 =" >> "$ZSH_CACHE_DIR/ros.cache"
  sed -ir "\#^\s*$1\s*=#s#$2#$3#" "$ZSH_CACHE_DIR/ros.cache"
}

_omz_ros_workspace_get_list() {
  echo "$ROS_PACKAGE_PATH" | tr ':' '\n' | grep -v '/opt/ros' |
  sed -r 's#/src$##' | paste -sd ' '
}

_omz_ros_interface_get_list() {
   ip link show | egrep '^[0-9]+: ' | sed -r 's# ##g' | cut -d ':' -f 2 |
   paste -sd ' '
}

_omz_ros_interface_get_available() {
   ifconfig | egrep -o '^[[:alnum:]]+' | paste -sd ' '
}

_omz_ros_interface_to_ip() {
  ifconfig | sed '/./{H;$!d};x;/'"$1"'/!d' | egrep -o 'inet addr:[0-9.]+' |
  cut -d ':' -f 2
}

_omz_ros_distro_get_list() {
  ls -l '/opt/ros' | grep '^d' | tr -s ' ' | cut --complement -d ' ' -f 1-8 |
  paste -sd ' '
}

ros_prompt_info() {
  local ros_status=""
  local master_ip=$(rosmaster)
  if [ "$master_ip" ]; then
    ros_status+="$ZSH_THEME_ROS_PROMPT_PREFIX%{$fg_no_bold[white]%}"
    LC_ALL=C curl -m 0.1 -s -o /dev/null \
    --request POST "$ROS_MASTER_URI/RPC2" --data "<?xml version='1.0'?>
    <methodCall><methodName>getUri</methodName><params><param><value><string>
    </string></value></param></params></methodCall>"
    case "$?" in
      0)
        # master up and responding
        [ "$(rosparam get use_sim_time 2>&1 | grep "true")" ] && \
        ros_status+="$ZSH_THEME_ROS_PROMPT_USE_SIM_TIME%{$fg_no_bold[white]%}"
        ros_status+="$ZSH_THEME_ROS_PROMPT_MASTER_UP"
        ;;
      7)
        # master down and machine responding
        ros_status+="$ZSH_THEME_ROS_PROMPT_MASTER_DOWN"
        ;;
      6|28)
        # Could not resolve host
        # Connection timeout
        ros_status+="$ZSH_THEME_ROS_PROMPT_MASTER_OUT"
        ;;
      *)
        # Unexpected
        ros_status+="$ZSH_THEME_ROS_PROMPT_MASTER_UNEXPECTED[$?]"
        ;;
    esac
    ros_status+="$master_ip%{$fg_no_bold[white]%}"
    ros_status+="$ZSH_THEME_ROS_PROMPT_SUFFIX%{$fg_no_bold[white]%}"
  fi
  echo "$ros_status"
  return 0
}

_omz_ros_config_init

[ ! "$ROS_IP" ] && rosinterface autoset
[ ! "$ROS_MASTER_URI" ] && rosmaster autoset
[ ! "$(rosworkspace)" ] && rosworkspace autoset
[ ! "$(rosdistro)" ] && rosdistro autoset


# Default values for the appearance of the prompt.
if [ "$(fc-list | grep 'FontAwesome')" ]; then
  ZSH_THEME_ROS_PROMPT_PREFIX="%{$fg[blue]%} %{$fg_bold[blue]%}("
  ZSH_THEME_ROS_PROMPT_USE_SIM_TIME="%{$fg_bold[yellow]%} "
else
  ZSH_THEME_ROS_PROMPT_PREFIX="%{$fg_bold[blue]%}ros:("
  ZSH_THEME_ROS_PROMPT_USE_SIM_TIME="%{$fg[yellow]%}⌚ "
fi

ZSH_THEME_ROS_PROMPT_SUFFIX="%{$fg_bold[blue]%})"
ZSH_THEME_ROS_PROMPT_MASTER_UP="%{$fg_bold[green]%}"
ZSH_THEME_ROS_PROMPT_MASTER_DOWN="%{$fg_bold[red]%}"
ZSH_THEME_ROS_PROMPT_MASTER_OUT="%{$fg_bold[magenta]%}"
ZSH_THEME_ROS_PROMPT_MASTER_UNEXPECTED="$ZSH_THEME_ROS_PROMPT_MASTER_OUT"

