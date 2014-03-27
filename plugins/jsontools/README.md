# jsontools

Handy command line tools for dealing with json data.

## Tools

- **pp_json** - pretty prints json
- **is_json** - returns true if valid json; false otherwise
- **urlencode_json** - returns a url encoded string for the given json 
- **urldecode_json** - returns decoded json for the given url encoded string

## Usage
Usage is simple...just take your json data and pipe it into the appropriate jsontool.
```sh
<json data> | <jsontools tool>
```
## Examples

##### pp_json

```sh
# curl json data and pretty print the results
curl https://coderwall.com/bobwilliams.json | pp_json
```

##### is_json
```sh
# pretty print the contents of an existing json file
less data.json | is_json
```

##### urlencode_json
```sh
# json data directly from the command line
echo '{"b":2, "a":1}' | urlencode_json
```

##### urldecode_json
```sh
# url encoded string to decode
echo '%7B%22b%22:2,%20%22a%22:1%7D%0A' | urldecode_json
```