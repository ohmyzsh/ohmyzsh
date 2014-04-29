function zerve {
    case $1 in
        ("stop")
            __zerve:cleanup 2>/dev/null
            return;;
        ("help")
            __zerve:usage
            return;;
        (*)
            if [[ -d $1 || -f $1 ]]; then
                _ZRV_DOCROOT="$1"
            elif [[ -n $1 ]]; then
                __zerve:usage
                return
            fi;;
    esac

    if ! whence zstat >/dev/null; then
        zmodload -F zsh/stat +b:zstat
    fi

    zmodload zsh/datetime
    zmodload zsh/net/tcp
    zmodload -F zsh/system +b:sysread -b:syswrite -b:syserror -b:zsystem

    : ${_ZRV_PORT:=8080}
    : ${_ZRV_DOCROOT:="$PWD"}
    : ${_ZRV_PROMPT:="(H:$_ZRV_PORT)-$PROMPT"}
    : ${_ZRV_OLDPROMPT:="$PROMPT"}

    __http:listen || { __zerve:cleanup >/dev/null; return 1 }
    _ZRV_LISTENFD=$REPLY

    PROMPT="$_ZRV_PROMPT"

    zle -F $_ZRV_LISTENFD __zerve:handler
}

function __zerve:usage {
    print "Usage: zerve [optional command] <file or dir>"
    print "Available Commands: stop"
}

function __zerve:cleanup {
    print "Closing zerve..."
    zle -F $_ZRV_LISTENFD
    ztcp -c

    PROMPT="$_ZRV_OLDPROMPT"

    zmodload -u zsh/datetime
    zmodload -u zsh/net/tcp
    zmodload -u zsh/system

    unset _ZRV_DOCROOT _ZRV_LISTENFD _ZRV_OLDPROMPT
}

function __zerve:handler {
    local fd
    local -A req_headers

    setopt local_options nomultibyte nomonitor

    __http:accept $1
    fd=$REPLY

    trap '' PIPE
    if __http:parse_request && __http:check_request; then
        __zerve:srv 1>&$fd 2>/dev/null
    fi

    ztcp -c $fd
}

function __zerve:srv {
    local pathname

    pathname="${_ZRV_DOCROOT}${$(__url:decode $req_headers[url])%/}"
    { if [[ -f $pathname ]]; then
        __http:return_header "200 Ok" "Content-type: $(__util:mime_type $pathname); charset=UTF-8" "Content-Length: $(zstat -L +size "$pathname")"
        __http:send_raw "$pathname"
    elif [[ -d $pathname ]]; then
        if [[ -f $pathname/index.html ]]; then
            __http:return_header "200 Ok" "Content-type: $(__util:mime_type $pathname/index.html); charset=UTF-8" "Content-Length: $(zstat -L +size $pathname/index.html)"
            __http:send_raw "$pathname/index.html"
        else
            __http:return_header "200 Ok" "Content-type: text/html; charset=UTF-8" "Transfer-Encoding: chunked"
            __util:html_template "$pathname" $(__util:dir_list "$pathname") | __http:send_chunk
        fi
    else
        __http:error_header 404
    fi } || __http:error_header 500
}

function __http:listen {
    ztcp -l $_ZRV_PORT 2>/dev/null || { print "Could not bind to port $_ZRV_PORT" >&2; return 1 }
    print "Listening on $_ZRV_PORT"
}

function __http:accept {
    ztcp -a $1
}

function __http:parse_request {
    local method url version line key value

    read -t 5 -r -u $fd line || return 1
    for method url version in ${(s. .)line%$'\r'}; do
        req_headers[method]="$method"
        req_headers[url]="${url%\?*}"
        req_headers[version]="$version"
    done

    while read -t 5 -r -u $fd line; do
        [[ -n $line && $line != $'\r' ]] || break
        for key value in ${(s/: /)line%$'\r'}; do
            req_headers[${(L)key}]="$value"
        done
    done
}

function __http:error_header {
    local message

    case "$1" in
        (404)
            message="404 Not Found";;
        (500)
            message="500 Internal Server Error";;
        (501)
            message="501 Not Implemented";;
        (505)
            message="505 HTTP Version Not Supported";;
    esac

    __http:return_header "$message" "Content-type: text/plain; charset=UTF-8" "Content-Length: ${#message}"
    print "$message"
}

function __http:return_header {
    local i

    print -n "HTTP/1.1 $1\r\n"
    print -n "Connection: close\r\n"
    print -n "Date: $(export TZ=UTC && strftime "%a, %d %b %Y %H:%M:%S" $EPOCHSECONDS) GMT\r\n"
    print -n "Server: zerve\r\n"
    for i in "$@[2,-1]"; do
        print -n "$i\r\n"
    done
    print -n "\r\n"
}

function __http:check_request {
    if [[ $req_headers[version] != "HTTP/1.1" ]]; then
        __http:error_header 505
        return 1
    elif [[ $req_headers[method] != "GET" ]]; then
        __http:error_header 501
        return 1
    fi
}

function __http:send_raw {
    <$1
}

function __http:send_chunk {
    while sysread buff; do
        printf '%x\r\n' "${#buff}"
        printf '%s\r\n' "$buff"
    done

    printf '%x\r\n' "0"
    printf '\r\n'
}    

function __url:decode {
    printf '%b\n' "${1:gs/%/\\x}"
}

function __util:dir_list {
    local i

    cd "$1" || return 1

    [[ "${1%/}" != "${_ZRV_DOCROOT%/}" ]] && __util:html_fragment '/../'

    for i in ./.*/(Nr) ./*/(Nr) ./.*(.Nr) ./*(.Nr); do
        __util:html_fragment "$i"
    done

    cd - >/dev/null
}

function __util:calc_size {
    [[ -d "$1" ]] && { print "\-"; return }

    local KB=1024.0
    local MB=1048576.0
    local GB=1073741824.0
    
    local size=$(zstat -L +size $1)

    (( $size < $KB )) && { printf '%.1f%s\n' "${size}" "B" && return }
    (( $size < $MB )) && { printf '%.1f%s\n' "$((size/$KB))" "K" && return }
    (( $size < $GB )) && { printf '%.1f%s\n' "$((size/$MB))" "M" && return }
    (( $size > $GB )) && { printf '%.1f%s\n' "$((size/$GB))" "G" && return }
}

function __util:html_fragment {
    print "<tr><td><a href=\"${1#*/}\">${1#*/}</a></td><td>$(__util:calc_size $1)</td></tr>"
}

function __util:html_template {
<<EOF
<!DOCTYPE html><html><head><style type="text/css">a {text-decoration: none;} a:hover, a:focus { color: white; background: rgba(0,0,0,0.3); cursor: pointer; } h2 { margin-bottom: 10px } table { border-collapse: collapse; } thead th { padding-top: 4px; padding-bottom: 6px; text-align: left; } thead th:nth-child(2) { text-align: right; padding-right: 12px; } tbody td:nth-child(2) { text-align: right; padding-right: 12px; } tbody td:first-child { padding-right: 30px; } div.list { background-color: #F5F5F5; border-top: 1px solid black; border-bottom: 1px solid black; font: 90% monospace; margin: 4px;}</style><title>zerve</title></head><body><h2>Index of $1</h2><div class=list><table><thead><tr><th>Name</th><th>Size</th></tr></thead><tbody>$@[2,-1]</tbody></table></div></body></html>
EOF
}

function __util:mime_type {
    case $1 in
        (*.html)
            print "text/html";;
        (*.css)
            print "text/css";;
        (*)
            if which file >/dev/null; then
                local mtype
                mtype=$(file -bL --mime-type $1)

                [[ ${mtype:h} == text ]] && { print "text/plain"; continue }
                print "${mtype#application/x-executable}"
            else
                print "application/octet-stream"
            fi;;
    esac
}
