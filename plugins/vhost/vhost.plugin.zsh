# frontend from terminal

function vhost() {


  local hosts_file
  hosts_file='/etc/hosts'

  # no keyword provided, simply show how call methods
  if [[ "$#" -le 1 && $1 -ne "ls" ]]; then
    echo "Please provide a command with params.\nEx:\nvhost <command> <params>\n"
    return 1
  fi

  # check whether the search engine is supported
  if [[ ! $1 =~ "(add|ls|rm)" ]];
  then
    echo "Option '$1' is not supported."
    echo "Usage: vhost <ip> <host>"
    echo "\t* add <ip> <host>"
    echo "\t* ls"
    echo "\t* rm <ip> <host>"
    echo ""

    return 1
  fi

  case "$1" in
    "ls")
      cat $hosts_file
      ;;
    "add")
      if [[ $# -le 2 ]]; then
        echo "This method should receive 2 params <ip> <host>"
      fi
      vhost="$2 $3"
      sudo echo "$vhost" >> $hosts_file
      echo "New virtual host '$3' created!"
      ;;
    "rm")
      if [[ $# -le 2 ]]; then
        echo "This method should receive 2 params <ip> <host>"
      fi

    	sudo -v
      vhost="$2 $3"

      echo -n "  - Removing '$vhost' from $hosts_file... "
      cat $hosts_file | grep -v $vhost > /tmp/hosts.tmp
      if [[ -s /tmp/hosts.tmp ]]; then
        sudo mv /tmp/hosts.tmp $hosts_file
      fi
      echo "Virtual host '$3' removed!"
      ;;
    *) echo "Command '$1' doesn't exist, sir."
       return 1
       ;;
  esac

}
