alias jcurl=jsoncurl
function jsoncurl()
{
    curl -s $1 |python -m json.tool
}
