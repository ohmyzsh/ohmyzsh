# VS Code (stable / insiders) / VSCodium zsh plugin
# Authors:
#   https://github.com/MarsiBarsi (original author)
#   https://github.com/babakks
#   https://github.com/SteelShot

_vscode-register-aliases () {
  alias vsc="$VSCODE ."
  alias vsca="$VSCODE --add"
  alias vscd="$VSCODE --diff"
  alias vscg="$VSCODE --goto"
  alias vscn="$VSCODE --new-window"
  alias vscr="$VSCODE --reuse-window"
  alias vscw="$VSCODE --wait"
  alias vscu="$VSCODE --user-data-dir"

  alias vsced="$VSCODE --extensions-dir"
  alias vscie="$VSCODE --install-extension"
  alias vscue="$VSCODE --uninstall-extension"

  alias vscv="$VSCODE --verbose"
  alias vscl="$VSCODE --log"
  alias vscde="$VSCODE --disable-extensions"
}

# Verify if any manual user choice of VS Code exists first.
# Otherwise, try to detect a flavour of VS Code.
if ! [ -z ${VSCODE+x} ] && which $VSCODE > /dev/null; then
  _vscode-register-aliases
else
  if which code > /dev/null; then
    : ${VSCODE:=code}
  elif which code-insiders > /dev/null; then
    : ${VSCODE:=code-insiders}
  elif which codium > /dev/null; then
    : ${VSCODE:=codium}
  else
    return -1
  fi

  _vscode-register-aliases
fi
