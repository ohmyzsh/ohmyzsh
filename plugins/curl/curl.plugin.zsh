alias curlj=jsoncurl
function jsoncurl()
{
    curl -s $1 |python -m json.tool
}

alias curlh="curl -siv -o /dev/null"
alias curls="curl -O"
alias curlt="curl -o /dev/null -s -w %{time_total}'\\n'"
alias curlrc="curl -s -o /dev/null -w %{http_code}'\\n'"
