
function burl() {
  local url="$1"
  if [[ "$url" == '' || "$url" == '-h' ]]; then
    cat <<EOF
Usage:
  burl <URL> [...other args of curl]
EOF
    return 0
  fi

  shift
  curl "$url"\
  -H 'Connection: keep-alive'\
  -H 'sec-ch-ua: " Not A;Brand";v="99", "Chromium";v="98", "Google Chrome";v="98"'\
  -H 'sec-ch-ua-mobile: ?0'\
  -H 'sec-ch-ua-platform: "Linux"'\
  -H 'DNT: 1'\
  -H 'Upgrade-Insecure-Requests: 1'\
  -H 'User-Agent: Mozilla/5.0 (X11; Debian; Linux x86_64; rv:85.0)  AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.87 Safari/537.36'\
  -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9'\
  -H "origin: $(echo "$url" | sed 's!\([^\:/]\)/.*!\1!g')"\
  -H "referer: $url"\
  -H 'Sec-Fetch-Site: same-site'\
  -H 'Sec-Fetch-Mode: navigate'\
  -H 'Sec-Fetch-User: ?1'\
  -H 'Sec-Fetch-Dest: document'\
  -H 'Accept-Encoding: gzip, deflate, br'\
  -H 'Accept-Language: en-US,en;q=0.9'\
  "$@"
}
