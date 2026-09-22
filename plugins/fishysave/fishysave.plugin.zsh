local base_dir="${ZSH_SAVE_DIR:-$HOME/.zshrc_fishy}"

function fishysave() {
  local name="$1"

  local base_dir="${ZSH_SAVE_DIR:-$HOME/.zshrc_fishy}"
  local alias_dir="$base_dir/aliases"
  local func_dir="$base_dir/functions"
  
  if [[ -z "$name" ]]; then
    echo "No parameter provided"
    echo "Usage: save <alias or function>"
    return 1
  fi

  if alias "$name" &>/dev/null; then
    local alias_def
    alias_def=$(alias "$name")

    echo "alias $alias_def" > "$alias_dir/$name.zsh"
    echo "Alias $name saved to $alias_dir/$name.zsh"
  elif whence -w "$name" | grep -q function; then
    local func_def
    func_def=$(functions "$name")
    echo "$func_def" > "$func_dir/$name.zsh"
    echo "Function $name saved to $func_dir/$name.zsh"
  else
    echo "Couldn't find a declared function or alias named '$name'"
    return 2
  fi
}

mkdir -p "$base_dir/aliases" "$base_dir/functions"

setopt localoptions nullglob

for file in "$base_dir"/aliases/*.zsh "$base_dir"/functions/*.zsh; do
  [[ -f $file ]] && source "$file"
done
