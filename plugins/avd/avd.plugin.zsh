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
  local emulator_path
  emulator_path=$(find_emulator)

  # Print all AVDs and prepend each output line with a number, starting at 1.
  eval "$emulator_path -list-avds" | grep -n '^'
}

function avd() {
  help() {
    echo "Usage: avd [-v] [AVD position on the list]"
    avds
  }

  local OPTIND o verbose avd_number avd_name avds_count emulator_path cmd_to_execute
  while getopts ":v" o; do
    case "$o" in
      v)
        verbose=1;;
      *)
        help; return;;
    esac
  done

  shift $((OPTIND-1))

  avd_number="$1"

  if [[ -z $avd_number ]]; then
    help
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

  # Print only the n-th AVD and remove the number prefix added by 'grep -n'
  avd_name=$(avds | head -"$avd_number" | tail -1 | sed -E 's/^[0-9]+://')
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

