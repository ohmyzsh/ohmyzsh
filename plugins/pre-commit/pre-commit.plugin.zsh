# Aliases for pre-commit (uses prek if available, else pre-commit)
if command -v prek &> /dev/null; then
    _prc_cmd='prek'
else
    _prc_cmd='pre-commit'
fi

alias prc="$_prc_cmd"

alias prcau="$_prc_cmd autoupdate"

alias prcr="$_prc_cmd run"
alias prcra="$_prc_cmd run --all-files"
alias prcrf="$_prc_cmd run --files"

