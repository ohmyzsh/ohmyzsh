# VScode zsh plugin
# Authors:
#   https://github.com/MarsiBarsi (original author)
#   https://github.com/babakks

# Use the stable VS Code release, unless the Insiders version is the only
# available installation
if ! which code > /dev/null && which code-insiders > /dev/null; then
  : ${VSCODE:=code-insiders}
else
  : ${VSCODE:=code}
fi

# Define aliases
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
