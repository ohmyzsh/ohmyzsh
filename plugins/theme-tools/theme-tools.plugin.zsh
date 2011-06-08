# Directly change a theme
function usetheme() {
  if [ $1 ] && theme_name=${1%.zsh-theme}; then
    if [ $theme_name = $ZSH_THEME ]; then
      print "Maintaining theme... "

      # A work-around when used through changetheme
      source "$ZSH/themes/$theme_name.zsh-theme"
    else
      printf "Changing theme to $1... "

      if [ -f "$ZSH/themes/$theme_name.zsh-theme" ]; then
        source "$ZSH/themes/$theme_name.zsh-theme"
        export ZSH_THEME=$theme_name
        echo "$fg_bold[green]Done$reset_color"
      else
        printf "$fg_bold[red]Error$reset_color: "
        echo "Could not find theme: '$theme_name.zsh-theme' in $ZSH_THEMES_PATH"
      fi
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
    theme_files=($ZSH/themes/*)
    theme_names=(${${theme_files[@]##*/}[@]%.zsh-theme})

    PS3="Enter your selection: "
    print "Themes available:"
    select theme_name in ${theme_names[@]} Quit
    do
      case $theme_name in
        Quit)
          echo "Exiting... "
          exit;;
        *)
          theme_selection=$REPLY
          printf "Would you like to preview this theme before applying? [yn]: "
          read confirmation
          case $confirmation in
            y*)
              source "${theme_files[$theme_selection]}"

              PS3="$PROMPT"
              echo "Apply theme? ";
              select theme_confirmation in yes no
              do
                case $theme_confirmation in
                  yes)
                    theme="${theme_names[$theme_selection]}"
                    break;;
                  no)
                    theme="$ZSH_THEME.zsh-theme"
                    break;;
                esac
              done;
              break;;
            n*) break;;
          esac
          break;;
      esac
    done
    unset PS3
    usetheme $theme
  fi
}
