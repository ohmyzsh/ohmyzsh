# Oh My Zsh Curl Plugin

This plugin extends the functionality of `curl` with useful aliases and functions, making HTTP requests easier from the terminal.

## Installation

1. Add the plugin to your `.zshrc`:
   ```bash
   plugins=(... curl)
   ```

3. Reload your shell configuration:
   ```bash
   source ~/.zshrc
   ```

---

## Aliases

| Alias           | Command                            | Description |
|--------------- |--------------------------------|-------------|
| `curlget`      | `curl -L`                     | Perform a GET request (follows redirects). |
| `curlhead`     | `curl -I`                     | Fetch only HTTP headers. |
| `curlpost`     | `curl -X POST`                | Send a POST request. |
| `curlput`      | `curl -X PUT`                 | Send a PUT request. |
| `curldelete`   | `curl -X DELETE`              | Send a DELETE request. |
| `curljson`     | `curl -H 'Content-Type: application/json'` | Use curl with a JSON content type. |
| `curldownload` | `curl -LO`                    | Download a file (keeps original filename). |
| `curlverbose`  | `curl -v`                     | Show detailed request/response info. |
| `curlsilent`   | `curl -s`                     | Silent mode (no progress or messages). |
| `curlheadonly` | `curl -I`                     | Fetch only response headers. |
| `curlbasic`    | `curl -u`                     | Perform basic authentication. |
| `curlrange`    | `curl -r`                     | Request a specific range of bytes. |

---

## Functions

### `curl_url <url>`
Fetches the content of the specified URL.
```bash
curl_url https://example.com
```

### `curl_test <url>`
Performs a HEAD request to check server response.
```bash
curl_test https://example.com
```

### `curl_download <url> <output_file>`
Downloads content from the given URL and saves it as the specified file.
```bash
curl_download https://example.com/file.zip myfile.zip
```

### `curl_to_file <url> <output_file>`
Fetches response and outputs it to a file.
```bash
curl_to_file https://example.com api-response.json
```

### `curl_json_pretty <url>`
Fetches and pretty-prints JSON response (requires `jq`).
```bash
curl_json_pretty https://api.example.com/data
```

### `curl_with_headers <url> <header>`
Sends a request with custom headers.
```bash
curl_with_headers https://example.com "Authorization: Bearer TOKEN"
```

### `curl_basic_auth <url> <username> <password>`
Sends a request with basic authentication.
```bash
curl_basic_auth https://example.com admin secretpassword
```

### `curl_follow_redirect <url>`
Follows HTTP redirects.
```bash
curl_follow_redirect https://short.url/link
```

---

Enjoy enhanced `curl` productivity with this Oh My Zsh plugin!