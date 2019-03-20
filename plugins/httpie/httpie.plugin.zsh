function _httpie_completion() {
  _arguments -C \
    '(- 1 *)--version[display version information]' \
    '(-j|--json)'{-j,--json}'[(default) Data items from the command line are serialized as a JSON object]' \
    '(-f|--form)'{-f,--form}'[Data items from the command line are serialized as form fields]' \
    '(--pretty)--pretty[<all,colors,format,none> Controls output processing]:options' \
    '(-s|--style)'{-s,--style}'[Output coloring style]' \
    '(-p|--print)'{-p,--print}'[String specifying what the output should contain: H(request headers), B(request body), h(response headers), b(response body)]' \
    '(-v|--verbose)'{-v,--verbose}'[Print the whole request as well as the response. Shortcut for --print=HBbh.]' \
    '(-h|--headers)'{-h,--headers}'[Print only the response headers. Shortcut for --print=h]' \
    '(-b|--body)'{-b,--body}'[Print only the response body. Shortcut for --print=b]' \
    '(-S|--stream)'{-S,--stream}'[Always stream the output by line, i.e., behave like `tail -f'"'"']' \
    '(-o|--output)'{-o,--output}'[Save output to FILE]:file:_files' \
    '(-d|--download)'{-d,--download}'[Do not print the response body to stdout. Rather, download it and store it in a file. The filename is guessed unless specified with --output filename. This action is similar to the default behaviour of wget.]' \
    '(-c|--continue)'{-c,--continue}'[Resume an interrupted download. Note that the --output option needs to be specified as well.]' \
    '(--session)--session[Create, or reuse and update a session. Within a session, custom headers, auth credential, as well as any cookies sent by the server persist between requests]:file:_files' \
    '(--session-read-only)--session-read-only[Create or read a session without updating it form the request/response exchange]:file:_files' \
    '(-a|--auth)'{-a,--auth}'[<USER:PASS> If only the username is provided (-a username), HTTPie will prompt for the password]' \
    '(--auth-type)--auth-type[<basic, digest> The authentication mechanism to be used. Defaults to "basic".]' \
    '(--proxy)--proxy[<PROTOCOL:PROXY_URL> String mapping protocol to the URL of the proxy]' \
    '(--follow)--follow[Set this flag if full redirects are allowed (e.g. re-POST-ing of data at new Location).]' \
    '(--verify)--verify[<VERIFY> Set to "no" to skip checking the host'"'"'s SSL certificate. You can also pass the path to a CA_BUNDLE file for private certs. You can also set the REQUESTS_CA_BUNDLE  environment variable. Defaults to "yes".]' \
    '(--timeout)--timeout[<SECONDS> The connection timeout of the request in seconds. The default value is 30 seconds]' \
    '(--check-status)--check-status[By default, HTTPie exits with 0 when no network or other fatal errors occur. This flag instructs HTTPie to also check the HTTP status code and exit with an error if the status indicates one.]' \
    '(--ignore-stdin)--ignore-stdin[Do not attempt to read stdin]' \
    '(--help)--help[Show this help message and exit]' \
    '(--traceback)--traceback[Prints exception traceback should one occur]' \
    '(--debug)--debug[Prints exception traceback should one occur, and also other information that is useful for debugging HTTPie itself and for reporting bugs]' \
    '1: :->cmds' \
    '*: :->args' && ret=0
}

compdef _httpie_completion http