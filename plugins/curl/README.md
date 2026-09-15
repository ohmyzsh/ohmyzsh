# curl plugin

This plugin provides a comprehensive set of aliases and functions to simplify working with `curl` command-line tool, making API testing and HTTP requests more convenient.

## Installation

To use it, add `curl` to the plugins array in your zshrc file:

```zsh
plugins=(... curl)
```

## Requirements

- **curl**: The plugin is built around the curl utility
- **jq**: Recommended for JSON formatting functionality (some functions will fall back to plain output if jq is not installed)
- **xmllint**: Optional for XML formatting
- **js-beautify**: Optional for HTML formatting

## Command Reference

### Basic Aliases

| Command | Description | Example Usage |
|---------|-------------|---------------|
| `cl` | curl with redirect following | `cl https://example.com` |
| `clh` | curl headers only with redirect following | `clh https://example.com` |
| `ch` | curl headers only | `ch https://example.com` |
| `cj` | curl with JSON content-type header | `cj https://api.example.com` |
| `cjson` | curl with JSON content-type and accept headers | `cjson https://api.example.com` |
| `cv` | curl with verbose output | `cv https://example.com` |
| `cs` | curl in silent mode | `cs https://example.com` |
| `csv` | curl in silent mode with verbose output | `csv https://example.com` |
| `ca` | curl with custom User-Agent | `ca "Mozilla/5.0" https://example.com` |
| `ct` | curl showing request time | `ct https://example.com` |

### HTTP Method Aliases

| Command | Description | Example Usage |
|---------|-------------|---------------|
| `cget` | curl with GET method | `cget https://api.example.com/users` |
| `cpost` | curl with POST method | `cpost https://api.example.com/users` |
| `cput` | curl with PUT method | `cput https://api.example.com/users/1` |
| `cpatch` | curl with PATCH method | `cpatch https://api.example.com/users/1` |
| `cdel` | curl with DELETE method | `cdel https://api.example.com/users/1` |
| `chead` | curl with HEAD method | `chead https://example.com` |
| `coptions` | curl with OPTIONS method | `coptions https://api.example.com` |

### Output Formatting

| Command | Description | Example Usage |
|---------|-------------|---------------|
| `cjp` | curl with JSON pretty-printing via jq | `cjp https://api.example.com/users` |
| `cjps` | curl in silent mode with JSON pretty-printing | `cjps https://api.example.com/users` |

### File Operations

| Command | Description | Example Usage |
|---------|-------------|---------------|
| `cof` | curl and save to specified file | `cof output.txt https://example.com` |
| `cOrf` | curl and save with original filename | `cOrf https://example.com/file.zip` |

### Advanced Functions

| Function | Description | Example Usage |
|----------|-------------|---------------|
| `curlpost` | Send JSON data via POST | `curlpost https://api.example.com/users '{"name":"John"}'` |
| `curlauth` | Make request with basic authentication | `curlauth https://api.example.com/users username password` |
| `curltoken` | Make request with bearer token | `curltoken https://api.example.com/users "your-token"` |
| `curlinfo` | Display comprehensive timing and header information | `curlinfo https://example.com` |
| `curlcompare` | Compare response times of multiple URLs | `curlcompare https://site1.com https://site2.com` |
| `curlmonitor` | Monitor website availability periodically | `curlmonitor https://example.com 30` |
| `curlallmethods` | Test all HTTP methods on a URL | `curlallmethods https://api.example.com/endpoint` |
| `curlformat` | Auto-detect content type and format accordingly | `curlformat https://api.example.com/users` |

## Function Details

### curlpost
Makes a POST request with JSON data and formats the response using jq.

```zsh
curlpost https://api.example.com/users '{"name":"John","email":"john@example.com"}'
```

### curlauth
Tests an API endpoint with basic authentication.

```zsh
curlauth https://api.example.com/protected username password
```

### curltoken
Makes a request with a bearer token for authorization.

```zsh
curltoken https://api.example.com/me "eyJhbGciOiJIUzI1NiIsI..."
```

### curlinfo
Displays detailed timing metrics and response headers for a URL.

```zsh
curlinfo https://example.com
```

This will show:
- DNS lookup time
- Connection time
- TLS setup time
- Total time
- Response size
- All response headers

### curlcompare
Compares response times of multiple URLs to benchmark performance.

```zsh
curlcompare https://site1.com https://site2.com https://site3.com
```

### curlmonitor
Continuously monitors a website's availability at specified intervals (default: 60 seconds).

```zsh
curlmonitor https://example.com 30  # Check every 30 seconds
```

### curlallmethods
Tests all standard HTTP methods (GET, POST, PUT, DELETE, HEAD, OPTIONS, PATCH) on a URL.

```zsh
curlallmethods https://api.example.com/test
```

### curlformat
Auto-detects the content type of the response and formats it accordingly (JSON, XML, HTML).

```zsh
curlformat https://api.example.com/users
```
