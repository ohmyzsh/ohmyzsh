ZSH_THEMES=$ZSH/themes

function change_theme() {
  if [ $1 ] && theme_name=${1%.zsh-theme}; then
    printf "Changing theme... "

    if [ -f $ZSH_THEMES/$theme_name.zsh-theme ]; then
      source $ZSH_THEMES/$theme_name.zsh-theme
      export ZSH_THEME=$theme_name
      echo "$fg_bold[green]Done"
    else
      printf "$fg_bold[red]Notice$reset_color: "
      echo "Could not find theme: '$theme_name.zsh-theme' in $ZSH_THEMES"
    fi

  else
    echo "change_theme: no theme given"
  fi
}

function list_themes() {
  more < <(
    echo "Themes available (press 'q' to quit)"
    echo "===================================="
    for theme ($ZSH_THEMES/*)
    do
      echo "${${theme%.zsh-theme}##*/}"
    done)
}
