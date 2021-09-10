# jsontools

Handy command line tools for dealing with json data.

To use it, add `jsontools` to the plugins array in your zshrc file:

```zsh
plugins=(... jsontools)
```

## Usage

Usage is simple... just take your json data and pipe it into the appropriate jsontool:

- `pp_json`: pretty prints json.
- `pp_ndjson`: pretty prints a [ndjson](http://ndjson.org) (json-lines) 
- `is_json`: returns true if valid json; false otherwise.
- `urlencode_json`: returns a url encoded string for the given json.
- `urldecode_json`: returns decoded json for the given url encoded string.

### Examples

- **pp_json**:

```sh
# curl json data and pretty print the results
curl https://coderwall.com/bobwilliams.json | pp_json
```

- **pp_ndjson**:

```sh
# echo two separate json objects and pretty print both
echo '{"a": "b"}\n{"c": [1,2,3]}' | pp_ndjson
```

- **is_json**:

```sh
# Validate if file's content conforms to a valid JSON schema
less data.json | is_json
```

- **urlencode_json**:

```sh
# json data directly from the command line
echo '{"b":2, "a":1}' | urlencode_json
```

- **urldecode_json**:

```sh
# url encoded string to decode
echo '%7B%22b%22:2,%20%22a%22:1%7D%0A' | urldecode_json
```
