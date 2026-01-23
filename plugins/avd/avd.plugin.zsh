function find_emulator() {
  local emulator_found

  if [[ -n $(command -v emulator) ]]; then
    emulator_found="emulator"
  elif [[ -d "$ANDROID_HOME" ]]; then
    # If there is no emulator in the path, try to find it in $ANDROID_HOME if it
    # is defined.
    emulator_found=$(find "$ANDROID_HOME" -name emulator -type f | head -1)
  fi

  if [[ -n $emulator_found ]]; then
    echo "$emulator_found"
  else
    cat <<< "Emulator not found" 1>&2

    # Use "emulator" even if it's not found just to let the other functions fail
    # later.
    echo "emulator"
  fi
}

function avds() {
  _avds_usage() {
    echo "Usage: avds [-s]"
  }

  local OPTIND o emulator_path cmd_to_execute skip_numbers

  while getopts ":s" o; do
    case "$o" in
      s)
        skip_numbers=1;;
      *)
        _avds_usage; return;;
    esac
  done

  shift $((OPTIND-1))

  emulator_path=$(find_emulator)
  cmd_to_execute="$emulator_path -list-avds"

  if [[ $skip_numbers -eq 1 ]]; then
    # Just print all AVDs.
    eval "$cmd_to_execute"
  else
    # Print all AVDs and prepend each output line with a number, starting at 1.
    eval "$cmd_to_execute" | grep -n '^'
  fi
}

function avd() {
  _avd_usage() {
    echo "Usage: avd [-v] [AVD position on the list]"
    avds
  }

  local OPTIND o verbose avd_number avd_name avds_count emulator_path
  local cmd_to_execute

  while getopts ":v" o; do
    case "$o" in
      v)
        verbose=1;;
      *)
        _avd_usage; return;;
    esac
  done

  shift $((OPTIND-1))

  avd_number="$1"

  if [[ -z $avd_number ]]; then
    _avd_usage
    return
  fi

  avds_count=$(avds | wc -l | grep -Eo '[0-9]+') || return

  if [[ $avds_count -le 0 ]]; then
    echo "No AVDs found"
    return
  fi

  if [[ ($avd_number -lt 1 || $avd_number -gt $avds_count) ]]; then
    echo "The number must be in 1..${avds_count}"
    return
  fi

  # Print only the n-th AVD name.
  avd_name=$(avds -s | head -"$avd_number" | tail -1)
  echo "Starting emulator: $avd_name"

  emulator_path=$(find_emulator)
  cmd_to_execute="$emulator_path -avd $avd_name"

  if [[ $verbose -eq 1 ]]; then
    eval "$cmd_to_execute"
  else
    eval "$cmd_to_execute" > /dev/null 2>&1
  fi
}

alias emus="avds"
alias emu="avd"

