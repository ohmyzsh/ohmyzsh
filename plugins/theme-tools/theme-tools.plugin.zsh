export ZSH_THEMES_PATH=$ZSH/themes

# Directly change a theme
function usetheme() {
  if [ $1 ] && theme_name=${1%.zsh-theme}; then
    printf "Changing theme to $1... "

    if [ -f $ZSH_THEMES_PATH/$theme_name.zsh-theme ]; then
      source $ZSH_THEMES_PATH/$theme_name.zsh-theme
      export ZSH_THEME=$theme_name
      echo "$fg_bold[green]Done"
    else
      printf "$fg_bold[red]Error$reset_color: "
      echo "Could not find theme: '$theme_name.zsh-theme' in $ZSH_THEMES_PATH"
    fi

  else
    echo "No theme given"
  fi
}

# Change themes through a menu style prompt
function changetheme() {
  if [ $1 ]; then
    usetheme "$1"
  else
    theme_files=($ZSH_THEMES_PATH/*)
    theme_names=(${${theme_files[@]##*/}[@]%.zsh-theme})

    PS3="Enter your selection: "
    SELECTION=""

    echo "Themes available:"
    select theme in ${theme_names[@]} Quit
    do
      case $theme in
        Quit)
          echo "Exiting... "
          exit;;
        *)
          SELECTION=$REPLY
          break
          ;;
      esac
    done

    theme="${theme_names[$SELECTION]}"
    usetheme $theme
  fi
}
