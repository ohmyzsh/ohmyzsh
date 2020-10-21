if type op  >/dev/null 2>&1 ; then
    eval "$(op completion zsh)"; compdef _op op
fi

# opswd puts the password of the named service into the clipboard. If there's a
# one time password, it will be copied into the clipboard after 5 seconds. The
# clipboard is cleared after another 10 seconds.
function opswd() {
    if [[ $# < 1 ]]; then
	echo "Usage: opswd <service>"
	return 1
    fi

    if ! type pbcopy >/dev/null 2>&1; then
	if ! type xclip >/dev/null 2>&1; then
	    echo "must have pbcopy or xclip"
	    return 1
	else
	    alias pbcopy='xclip -selection clipboard'
	fi
    fi

    local service=$1

    (( ! oploggedin )) && opsignin

    op get item $service \
	| jq -r '.details.fields[] | select(.designation=="password").value'\
	| pbcopy

    ( sleep 5 && op get totp $service | pbcopy
      sleep 10 && pbcopy < /dev/null 2>&1 & ) &!
}

function oploggedin() {
    op list users &> /dev/null
}
