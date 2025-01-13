function otp() {
    if [ -z "$1" ]; then
        echo "Usage: otp <domain>"
        return 1
    fi
    if ! command -v apw &> /dev/null || ! command -v jq &> /dev/null || ! command -v awk &> /dev/null; then
        echo "This function requires apw, jq and awk to be installed"
        return 1
    fi
    CODES=$(apw otp get $1 2>/dev/null)
    STATUS=$?
    # ✋ If return code 9, not authenticated, run apw auth
    if [ $STATUS -eq 9 ]; then
        echo "🔐 Authenticating …"
        apw auth
        CODES=$(apw otp get $1)
    fi
    # ✋ If return code 3, domain not found, alert user
    if [ $STATUS -eq 3 ]; then
        echo "🚫 Domain not found"
        return 1
    fi
    # Grab available OTP codes for domain
    if [ $(echo $CODES | jq '.results | length') -gt 1 ]; then
        echo 'Multiple OTP codes found, select username:'
        echo $CODES | jq -r '.results | to_entries[] | "\(.key + 1). \(.value.username)"'
        read -k 1 index
        echo
        CODE=$(echo $CODES | jq -r ".results[$index - 1].code")
        tput cuu $(echo $CODES | jq '.results | length' | awk '{print $1 + 2}')
        tput ed
    else
        CODE=$(echo $CODES | jq -r '.results[0].code')
    fi
    echo $CODE | pbcopy
    echo "🔑 OTP code copied to clipboard"
}