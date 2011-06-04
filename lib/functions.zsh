function zsh_stats() {
  history | awk '{print $2}' | sort | uniq -c | sort -rn | head
}

function uninstall_oh_my_zsh() {
  /bin/sh $ZSH/tools/uninstall.sh
}

function upgrade_oh_my_zsh() {
  /bin/sh $ZSH/tools/upgrade.sh
}

function take() {
  mkdir -p $1
  cd $1
}

function extract() {
    unset REMOVE_ARCHIVE
    
    if test "$1" = "-r"; then
        REMOVE=1
        shift
    fi
  if [[ -f $1 ]]; then
    case $1 in
      *.tar.bz2) tar xvjf $1;;
      *.tar.gz) tar xvzf $1;;
      *.tar.xz) tar xvJf $1;;
      *.tar.lzma) tar --lzma -xvf $1;;
      *.bz2) bunzip $1;;
      *.rar) unrar x $1;;
      *.gz) gunzip $1;;
      *.tar) tar xvf $1;;
      *.tbz2) tar xvjf $1;;
      *.tgz) tar xvzf $1;;
      *.zip) unzip $1;;
      *.Z) uncompress $1;;
      *.7z) 7z x $1;;
      *) echo "'$1' cannot be extracted via >extract<";;
    esac

    if [[ $REMOVE_ARCHIVE -eq 1 ]]; then
        echo removing "$1";
        /bin/rm "$1";
    fi

  else
    echo "'$1' is not a valid file"
  fi
}

function favorite_themes() {
    for theme in `ls $FAVORITE_THEMES_DIR`; do
        echo $theme
    done
}

function get_current_theme() {
    echo `basename $RANDOM_THEME`
}

function like_theme() {
    theme_name=`get_current_theme`
    link_name="$FAVORITE_THEMES_DIR/$theme_name"

    if [[ ! -L $link_name ]]; then
        ln -s $RANDOM_THEME $link_name
        echo "Added $theme_name to favorites"
    else
        echo "$theme_name already a favorite!"
    fi
}

function unlike_theme() {
    theme_name=`get_current_theme`
    link_name="$FAVORITE_THEMES_DIR/$theme_name"

    if [[ -L $link_name ]]; then
        # FIXME: What happens if we remove the last theme we have?
        rm $link_name
        echo "Removed $theme_name from favorites"
    else
        echo "$theme_name isn't a favorite"
    fi
}

function load_random_theme() {
    themes=($*)
    N=${#themes[@]}
    ((N=(RANDOM%N)+1))
    RANDOM_THEME=${themes[$N]}
    source "$RANDOM_THEME"
    echo "[oh-my-zsh] Random theme '$RANDOM_THEME' loaded..."
    export RANDOM_THEME
}
