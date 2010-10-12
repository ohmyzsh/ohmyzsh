#
# resty - A tiny command line REST interface for bash and zsh.
#
# Fork me on github:
#   http://github.com/micha/resty
#
# Author:
#   Micha Niskin <micha@thinkminimo.com>
#   Copyright 2009, no rights reserved.
#

export _resty_host=""
export _resty_path=""

function resty() {
  local confdir host cookies method h2t editor domain _path opt dat res ret out err verbose raw i d tmpf args2

  confdir="${HOME}/.resty"
  host="${confdir}/host"
  cookies="$confdir/c"
  method="$1";          [[ $# > 0 ]] && shift
  h2t=$((which lynx >/dev/null && echo lynx -stdin -dump) \
                || which html2text || which cat)
  editor=$(which "$EDITOR" || which vim || echo "vi")

  [ -d "$cookies" ] || (mkdir -p "$cookies"; echo "http://localhost*" > "$host")
  [ -n "$1" ] && [ "${1#/}" != "$1" ] \
    && _path=$(echo "$1"|sed 's/%/%25/g;s/\[/%5B/g;s/\]/%5D/g;s/|/%7C/g;s/\$/%24/g;s/&/%26/g;s/+/%2B/g;s/,/%2C/g;s/:/%3A/g;s/;/%3B/g;s/=/%3D/g;s/?/%3F/g;s/@/%40/g;s/ /%20/g;s/#/%23/g;s/{/%7B/g;s/}/%7D/g;s/\\/%5C/g;s/\^/%5E/g;s/~/%7E/g;s/`/%60/g') && shift

  for i in "$@"; do
    ([ "$i" = "--verbose" ] || echo "$i" | grep -q '^-[a-zA-Z]*v[a-zA-Z]*$') \
      && verbose="yes"
  done

  [ -z "$_resty_host" ] && _resty_host=$(cat "$host" 2>/dev/null)
  [ -z "$method" ] && echo "$_resty_host" && return
  [ -n "$_path" ] && _resty_path=$_path
  domain=$(echo -n "$_resty_host" \
    |perl -ane '/^https?:\/\/([^\/\*]+)/; print $1')
  _path="${_resty_host//\*/$_resty_path}"

  case "$method" in
    GET|DELETE|POST|PUT)
      dat=$( ( [ "${method#P}" != "$method" ] \
        && ( ( [ -n "$1" ] && [ "${1#-}" = "$1" ] && echo "$1") \
        || echo "@-") ) || echo)
      if [ "${method#P}" != "$method" ] && [ "$1" = "-V" ]; then
        tmpf=$(mktemp /tmp/resty.XXXXXX)
        cat > $tmpf
        (exec < /dev/tty; "$editor" $tmpf)
        dat=$(cat $tmpf)
        rm -f $tmpf
      fi
      [ -n "$dat" ] && [ "$dat" != "@-" ] && shift
      [ "$1" = "-Z" ] && raw="yes" && shift
      [ -n "$dat" ] && opt="--data-binary"
      eval "args2=( $(cat "$confdir/$domain" 2>/dev/null |sed 's/^ *//' |grep ^$method |cut -b $((${#method}+2))-) )"
      res=$((((curl -sLv $opt "$dat" -X $method \
              -b "$cookies/$domain" -c "$cookies/$domain" \
              "${args2[@]}" "$@" "$_path" \
        |sed 's/^/OUT /' && echo) 3>&2 2>&1 1>&3) \
        |sed 's/^/ERR /' && echo) 2>&1)
      out=$(echo "$res" |sed '/^OUT /s/^....//p; d')
      err=$(echo "$res" |sed '/^ERR /s/^....//p; d')
      ret=$(echo "$err" |sed \
        '/^.*HTTP\/1\.[01] [0-9][0-9][0-9]/s/.*\([0-9]\)[0-9][0-9].*/\1/p; d' \
        | tail -n1)
      [ -n "$err" -a -n "$verbose" ] && echo "$err" 1>&2
      echo "$err" | grep -qi '^< \s*Content-Type:  *text/html' \
        && [ -z "$raw" ] && d=$h2t || d=cat
      [ -n "$out" ] && out=$(echo "$out" |eval "$d")
      [ "$d" != "${d##lynx}" ] && out=$(echo "$out" |perl -e "\$host='$(echo "$_resty_host" |sed 's/^\(https*:\/\/[^\/*]*\).*$/\1/')';" -e '@a=<>; $s=0; foreach (reverse(@a)) { if ($_ =~ /^References$/) { $s++; } unless ($s>0) { s/^\s+[0-9]+\. //; s/^file:\/\/localhost/$host/; } push(@ret,$_); } print(join("",reverse(@ret)))')
      if [ "$ret" != "2" ]; then
        [ -n "$out" ] && echo "$out" 1>&2
        return $ret
      else
        [ -n "$out" ] && echo "$out"
      fi
      ;;
    http://*|https://*)
      echo "$method" |grep -q '\*' || method="${method}*"
      (echo "$method" |tee "$host") |cat 1>&2 && _resty_host="$method"
      ;;
    *)
      resty "http://$method"
      ;;
  esac
}

function GET() {
  resty GET "$@"
}

function POST() {
  resty POST "$@"
}

function PUT() {
  resty PUT "$@"
}

function DELETE() {
  resty DELETE "$@"
}