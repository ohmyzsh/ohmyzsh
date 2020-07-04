# VScode zsh plugin
# Authors:
#   https://github.com/MarsiBarsi (original author)
#   https://github.com/babakks
#   https://github.com/SteelShot

# This will pick an appropriate executable in order:
# VSCode > VSCode Insiders > VSCodium
if which code > /dev/null; then
  : ${VSCODE:=code}
elif which code-insiders > /dev/null; then
  : ${VSCODE:=code-insiders}
elif which codium > /dev/null; then
  : ${VSCODE:=codium}
fi

# Only if a flavour of VSCode is available the aliases
# will be available
if ! [ -z ${VSCODE+x} ]; then
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
fi
