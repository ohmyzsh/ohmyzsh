### A zsh plugin that executes a default command specified in the def.config file.
def () {
  if [ -z "$XDG_CONFIG_HOME" ]; then
    export XDG_CONFIG_HOME="$HOME/.config"
  fi
  local dir="$(pwd)"

  if [ "$1" = "init" ]; then
    ### If there's no def.config file, then we create one.
    if [ ! -f "$XDG_CONFIG_HOME/def/def.config" ]; then
      mkdir -p "$XDG_CONFIG_HOME"/def
      touch "$XDG_CONFIG_HOME/def"/def.config
      echo "A def.config file was created in $XDG_CONFIG_HOME/def."
      return
    fi
    echo "A 'def.config' file already exists in $XDG_CONFIG_HOME."
    return
  fi

  if [  "$1" = "add" ]; then
    if [ ! -f "$XDG_CONFIG_HOME/def/def.config" ]; then
      echo "No default config file found. Create one in with the 'def init' command."
      return
    fi
    echo "$dir ${@:2}" >> "$XDG_CONFIG_HOME/def/def.config"
    echo "Added '${@:2}' to the default config file."
    return
  fi

  if [ "$1" = "remove" ]; then
    if [ ! -f "$XDG_CONFIG_HOME/def/def.config" ]; then
      echo "No default config file found. Create one in with the 'def init' command"
      return
    fi
    if [ -f $dir/.def ]; then
      rm $dir/.def
      echo "Removed local .def file"
    fi
    while read line; do
      if [[ $line =~ ^$dir ]]; then
        sed -i "\%$line%d" "$XDG_CONFIG_HOME/def/def.config"
        echo "Removed '$line' from the default config file."
      fi
    done < "$XDG_CONFIG_HOME/def/def.config"
    return
  fi

  if [ -z "$1" ]; then
    if [ -f $dir/.def ] && [ "$dir" != "$XDG_CONFIG_HOME" ]; then
        . $dir/.def
    else
      if [ -f $XDG_CONFIG_HOME/def/def.config ]; then
        while read line; do
          if [ "$line" != "" ]; then
            local directory=$(echo $line | cut -d' ' -f1)
            local command=$(echo $line | cut -d' ' -f2-)

            if [[ $directory == *"~"* ]]; then
              directory=$(echo $directory | sed 's%~%'$HOME'%g')
            fi

            if [[ $dir =~ $directory ]]; then
              echo $(eval $command)
              return
            fi
          fi
        done < $XDG_CONFIG_HOME/def/def.config
        echo "No default command found for the current directory"
      else
        echo "No default config file found. Create one in with the 'def init' command dmdmd."
      fi
    fi
  else 
    echo "Unknown command '$1'"
  fi
}

