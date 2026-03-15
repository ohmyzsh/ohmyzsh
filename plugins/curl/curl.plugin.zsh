#!/usr/bin/env zsh

# curl - an Oh My Zsh plugin to simplify working with curl

# Basic curl aliases
alias cl='curl -L' # follow redirects
alias clh='curl -LI' # headers only + follow redirects
alias ch='curl -I' # headers only
alias cj='curl -H "Content-Type: application/json"' # JSON header
alias cjson='curl -H "Content-Type: application/json" -H "Accept: application/json"'
alias cv='curl -vv' # verbose output
alias cs='curl -s' # silent mode
alias csv='curl -s -v' # silent mode + verbose output
alias ca='curl -A' # specify User-Agent
alias ct='curl -w "%{time_total}\n"' # show request time

# HTTP methods
alias cget='curl -X GET'
alias cpost='curl -X POST'
alias cput='curl -X PUT'
alias cpatch='curl -X PATCH'
alias cdel='curl -X DELETE'
alias chead='curl -X HEAD'
alias coptions='curl -X OPTIONS'

# JSON response formatting
alias cjp='curl | jq .' # curl with JSON formatting using jq
alias cjps='curl -s | jq .' # silent mode with jq

# Saving to file
alias cof='curl -o' # save to specified file
alias cOrf='curl -O -J' # save with original filename

# curl functions

# Function to send JSON data via POST
curlpost() {
  if [[ $# -lt 2 ]]; then
    echo "Usage: curlpost <URL> <JSON data>"
    return 1
  fi
  
  curl -s -X POST \
       -H "Content-Type: application/json" \
       -d "$2" \
       "$1" | jq 2>/dev/null || cat
}

# Check API with basic authentication
curlauth() {
  if [[ $# -lt 3 ]]; then
    echo "Usage: curlauth <URL> <username> <password>"
    return 1
  fi
  
  curl -s -u "$2:$3" "$1" | jq 2>/dev/null || cat
}

# Function for testing APIs with bearer token
curltoken() {
  if [[ $# -lt 2 ]]; then
    echo "Usage: curltoken <URL> <token>"
    return 1
  fi
  
  curl -s -H "Authorization: Bearer $2" "$1" | jq 2>/dev/null || cat
}

# Function for quick request with headers and timing information
curlinfo() {
  if [[ $# -lt 1 ]]; then
    echo "Usage: curlinfo <URL>"
    return 1
  fi
  
  echo "🕒 Timing information for $1:"
  curl -w "\n\nStatus: %{http_code}\nDNS lookup: %{time_namelookup}s\nConnect: %{time_connect}s\nTLS setup: %{time_appconnect}s\nPreTransfer: %{time_pretransfer}s\nStartTransfer: %{time_starttransfer}s\nTotal: %{time_total}s\nSize: %{size_download} bytes\n" -o /dev/null -s "$1"
  
  echo "\n🌐 Headers information:"
  curl -s -I "$1"
}

# Function to compare response time of different URLs
curlcompare() {
  if [[ $# -lt 2 ]]; then
    echo "Usage: curlcompare <URL1> <URL2> [URL3...]"
    return 1
  fi
  
  for url in "$@"; do
    echo "Testing $url"
    time curl -s -o /dev/null "$url"
    echo "----------------------------------------"
  done
}

# Function to monitor website availability
curlmonitor() {
  if [[ $# -lt 1 ]]; then
    echo "Usage: curlmonitor <URL> [interval in seconds (default: 60)]"
    return 1
  fi
  
  local url="$1"
  local interval=${2:-60}
  
  echo "Monitoring $url every $interval seconds. Press Ctrl+C to stop."
  
  while true; do
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local http_status=$(curl -s -o /dev/null -w "%{http_code}" "$url")
    local response_time=$(curl -s -o /dev/null -w "%{time_total}" "$url")
    
    if [[ "$status" == "200" ]]; then
      echo "$timestamp - ✅ Status: $http_status - Response: ${response_time}s"
    else
      echo "$timestamp - ❌ Status: $http_status - Response: ${response_time}s"
    fi
    
    sleep $interval
  done
}

# Function to test all HTTP methods on a URL
curlallmethods() {
  if [[ $# -lt 1 ]]; then
    echo "Usage: curlallmethods <URL>"
    return 1
  fi
  
  local url="$1"
  local methods=("GET" "POST" "PUT" "DELETE" "HEAD" "OPTIONS" "PATCH")
  
  for method in "${methods[@]}"; do
    echo "Testing $method on $url"
    curl -s -X $method -w "\nStatus: %{http_code}\nTime: %{time_total}s\n" -o /dev/null "$url"
    echo "----------------------------------------"
  done
}

# Auto-detect content type for formatted output
curlformat() {
  if [[ $# -lt 1 ]]; then
    echo "Usage: curlformat <URL>"
    return 1
  fi
  
  local url="$1"
  local content_type=$(curl -s -I "$url" | grep -i "content-type" | head -n 1)
  
  if [[ "$content_type" =~ "json" ]]; then
    echo "Detected JSON content, formatting with jq"
    curl -s "$url" | jq 2>/dev/null || cat
  elif [[ "$content_type" =~ "xml" ]]; then
    echo "Detected XML content, formatting with xmllint"
    curl -s "$url" | xmllint --format - 2>/dev/null || cat
  elif [[ "$content_type" =~ "html" ]]; then
    echo "Detected HTML content, formatting with html-beautify"
    if command -v html-beautify &> /dev/null; then
      curl -s "$url" | html-beautify 2>/dev/null || cat
    else
      curl -s "$url" | cat
      echo "\nInstall js-beautify for better HTML formatting"
    fi
  else
    curl -s "$url"
  fi
}

# Check if required dependencies are installed
if ! command -v jq &> /dev/null; then
  echo "⚠️ jq is not installed. Some functions may not work correctly."
  echo "Install jq for a better JSON experience."
fi

# Auto-completion for plugin functions
compdef _urls curlpost curlauth curltoken curlinfo curlcompare curlmonitor curlallmethods curlformat
