#!/bin/zsh

# Check if coffee is installed
if ! command -v coffee >/dev/null 2>&1; then
    echo "Error: CoffeeScript compiler not found. Please install it with 'npm install -g coffee-script'" >&2
    return 1
fi

# Compile a string of CoffeeScript and print to output
cf() {
    if [[ -z "$1" ]]; then
        echo "Error: No input provided" >&2
        echo "Usage: cf 'CoffeeScript code'" >&2
        return 1
    fi
    coffee -peb -- "$1" 2>/dev/null || {
        echo "Error: Failed to compile CoffeeScript" >&2
        return 1
    }
}

# Compile & copy to clipboard
cfc() {
    if [[ -z "$1" ]]; then
        echo "Error: No input provided" >&2
        echo "Usage: cfc 'CoffeeScript code'" >&2
        return 1
    fi
    local result
    result=$(cf "$1") || return 1
    echo "$result" | clipcopy && echo "Compiled code copied to clipboard"
}

# Compile from clipboard & print
cfp() {
    local input
    input=$(clippaste)
    if [[ -z "$input" ]]; then
        echo "Error: Clipboard is empty" >&2
        return 1
    fi
    cf "$input"
}

# Compile from clipboard and copy back to clipboard
cfpc() {
    local input result
    input=$(clippaste)
    if [[ -z "$input" ]]; then
        echo "Error: Clipboard is empty" >&2
        return 1
    fi
    result=$(cf "$input") || return 1
    echo "$result" | clipcopy && echo "Compiled code copied to clipboard"
}

# Export the functions
export -f cf cfc cfp cfpc
