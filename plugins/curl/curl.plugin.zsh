# curl.plugin.zsh

# Function to quickly curl a URL
curl_url() {
    if [[ -z "$1" ]]; then
        echo "Usage: curl_url <url>"
        return 1
    fi
    curl -L "$1"
}

# Function for testing curl response
curl_test() {
    if [[ -z "$1" ]]; then
        echo "Usage: curl_test <url>"
        return 1
    fi
    curl -I "$1"
}

# Function to download a file using curl
curl_download() {
    if [[ -z "$1" || -z "$2" ]]; then
        echo "Usage: curl_download <url> <output_file>"
        return 1
    fi
    curl -o "$2" "$1"
}

# Aliases for common curl operations
alias curlget='curl -L'             # Short alias for performing curl GET request
alias curlhead='curl -I'            # Short alias for getting the HTTP header info (HEAD request)
alias curlpost='curl -X POST'       # Alias for sending a POST request
alias curlput='curl -X PUT'         # Alias for sending a PUT request
alias curldelete='curl -X DELETE'   # Alias for sending a DELETE request
alias curljson="curl -H 'Content-Type: application/json'"  # curl with default JSON header
alias curldownload='curl -LO'       # Alias for downloading files with `-O` (remote file name)

# Additional Aliases for convenience
alias curlverbose='curl -v'         # Alias for verbose output, shows request/response
alias curlsilent='curl -s'          # Silent curl, hides progress bar and output
alias curlheadonly='curl -I'        # Shortcut for HTTP headers only
alias curlbasic='curl -u'           # Basic auth for curl
alias curlrange='curl -r'           # For range requests (e.g., resume downloads)

# Custom functions
# Fetch response and output to a file
curl_to_file() {
    if [[ -z "$1" || -z "$2" ]]; then
        echo "Usage: curl_to_file <url> <output_file>"
        return 1
    fi
    curl -o "$2" "$1"
    echo "File saved as $2"
}

# Function to fetch and display JSON content prettily
curl_json_pretty() {
    if [[ -z "$1" ]]; then
        echo "Usage: curl_json_pretty <url>"
        return 1
    fi
    curl -s "$1" | jq .   # jq for pretty JSON output
}

# Send curl request with custom headers
curl_with_headers() {
    if [[ -z "$1" || -z "$2" ]]; then
        echo "Usage: curl_with_headers <url> <header>"
        return 1
    fi
    curl -H "$2" "$1"
}

# Function to perform simple curl with authentication
curl_basic_auth() {
    if [[ -z "$1" || -z "$2" || -z "$3" ]]; then
        echo "Usage: curl_basic_auth <url> <username> <password>"
        return 1
    fi
    curl -u "$2:$3" "$1"
}

# Function for a safe URL redirect to follow (useful for API endpoints that send a 301/302 redirect)
curl_follow_redirect() {
    if [[ -z "$1" ]]; then
        echo "Usage: curl_follow_redirect <url>"
        return 1
    fi
    curl -L "$1"   # Follow redirects with -L flag
}
