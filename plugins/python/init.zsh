# Prepend PEP 370 per user site packages directory, which defaults to
# ~/Library/Python on Mac OS X and ~/.local elsewhere, to PATH/MANPATH.
if [[ "$OSTYPE" == darwin* ]]; then
  path=($HOME/Library/Python/*/bin(N) $path)
  manpath=($HOME/Library/Python/*/{,share/}man(N) $manpath)
else
  # This is subject to change.
  path=($HOME/.local/bin $path)
  manpath=($HOME/.local/{,share/}man(N) $manpath)
fi

