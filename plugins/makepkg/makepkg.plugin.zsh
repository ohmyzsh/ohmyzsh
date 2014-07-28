# Zsh aliases for makepkg, Arch Linux package build tool.
if [[ -x `which makepkg` ]]; then
  alias mpkg='makepkg' # Build package using current sources
  alias mpkgsy='makepkg -s' # Synchronize sources and build package
  alias mpkgsr='makepkg -S' # Build sources package(src.tar.xz usually)
  alias mpkgg='makepkg -g' # Sync sources and generate fresh hash sums for source files.
  alias mpkgo='makepkg -o' # Only sync sources and unpack them.
  alias mpkge='makepkg -e' # Use exist sources in ./src
  alias mpkgre='makepkg -R' # Only repack(use exist files in ./pkg) package
  alias mpkgf='makepkg -f' # Force rebuild package
  alias mpkgi='makepkg -i' # Install build package
else
  # Notification if makepkg not availble
  echo "Did you enable makepkg plugin, but makepkg doesn't exist in your system(or in $PATH)."
  echo "Please, run `sudo pacman -S base-devel` or disable plugin into your ~/.zshrc"
fi
  
