# Load a theme
# 
# Usage:
#   "theme <name>" loads the named theme
#   "theme random" or "theme" with no argument loads a random theme
# Return value:
#   0 on success
#   Nonzero on failure, such as requested theme not being found
function theme() {
  if [[ -z "$1" ]] || [[ "$1" = "random" ]]; then
    # Select a random theme
    local themes n random_theme
    themes=($(lstheme))
    n=${#themes[@]}
    ((n=(RANDOM%n)+1))
    random_theme=${themes[$n]}
    echo "[oh-my-zsh] Loading random theme '$random_theme'..."
    theme $random_theme
  else
    # Main case: load named theme
    local name theme_dir found
    name=$1
    found=false
    for theme_dir ($ZSH_CUSTOM $ZSH_CUSTOM/themes $ZSH/themes); do
      if [[ -f "$theme_dir/$name.zsh-theme" ]]; then
        source "$theme_dir/$name.zsh-theme"
        found=true
        break
      fi
    done
    if [[ $found == false ]]; then
      echo "[oh-my-zsh] Theme not found: $name"
      return 1
    fi
  fi
}

# List available themes by name
#
# The list will always be in sorted order, so you can index in to it.
function lstheme(){
  local themes x theme_dir
  themes=()
  for theme_dir ($ZSH_CUSTOM $ZSH_CUSTOM/themes $ZSH/themes); do
    if [[ -d $theme_dir ]]; then
      themes+=($(_omz_lstheme_dir $theme_dir))
    fi
  done
  echo ${(F)themes} | sort | uniq
}

# List themes defined in a given dir
function _omz_lstheme_dir() {
  ls $1 | grep '.zsh-theme$' | sed 's,\.zsh-theme$,,'
}