#!zsh
#
# Author: Joshua Bedford
# URL: github.com/joshuabedford/lando-zsh

#
# A simple collection of alias functions to enable the use of CLIs within Lando without having to type 'lando'.
#
# WARNING: This could conflict with any aliases previously installed. If you have any of the CLIs installed globally (outside of lando)
#      : The functions *should* enable the ability to not have to type 'lando' before a command by prepending lando for all commands done in the same directory as a .lando.yml file.


SITES_DIRECTORY="$HOME/Sites"

CONFIG_FILE=./.lando.yml

# Enable wp command with lando.
function wp(){
  
  if checkForFile $CONFIG_FILE $SITES_DIRECTORY ; then
    # Run Lando wp
    lando wp "$@"
  else
    # Run System wp
    command wp "$@"
  fi
}

# Enable composer command.
function composer(){
  
  if checkForFile $CONFIG_FILE $SITES_DIRECTORY ; then
    # Run Lando composer
    echo "Using 'lando composer'"
    lando composer "$@"
  else
    # Run System composer
    command composer "$@"
  fi
}

# Enable artisan command.
function artisan(){
  
  if checkForFile $CONFIG_FILE $SITES_DIRECTORY ; then
    # Run Lando artisan
    lando artisan "$@"
  else
    # Run System artisan
    command artisan "$@"
  fi
}

# Enable npm command for lando if lando file exists in directory.
function npm(){
  
  if checkForFile $CONFIG_FILE $SITES_DIRECTORY ; then
    echo "Running Lando npm...";
    # Run Lando NPM
    lando npm "$@"
  else
    echo "Running System npm...";
    # Run System NPM
    command npm "$@"
  fi
}

# Enable gulp command.
function gulp(){
  
  if checkForFile $CONFIG_FILE $SITES_DIRECTORY ; then
    echo "Running Lando gulp...";
    # Run Lando gulp
    lando gulp "$@"
  else
    echo "Running System gulp...";
    # Run System gulp
    command gulp "$@"
  fi
}


# Check for the file in the current and parent directories.
# $1: The file to search for (string)
# $2: The directory to search up to.
checkForFile(){
  
  local current_directory="$PWD"

  # Bash is backwards. 0 is true 1 (non-zero) is false.
  flag="1"

  # Only bother checking for lando within the Sites directory.
  if [[ ":$PWD:" == *":$2"* ]]; then

    echo "Checking for file: $1 within $2..."

    while true; do
      if [ $current_directory != "$2" ]; then
          if [ -f "$current_directory/$1" ]; then
            return "0"
          fi
        current_directory="$(dirname $current_directory)"
      else
        break;
      fi
    done

    if [[ "$flag" == "1" ]]; then
      echo "Could not find $1 in the current directory or in any of its parents up to $2."
    fi

  else

    echo "Checking for file: $1"

    if [ -f "$1" ]; then
      echo "Found it"
      return 0
    else
      echo "Not Found"
      return "1"
    fi

    if [[ "$flag" == "1" ]]; then
      echo "Could not find $1."
    fi

  fi

  return $flag

}