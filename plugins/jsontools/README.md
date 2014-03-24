# jsontools

Handy command line tools for dealing with json data.

## Tools

- **pp_json** - pretty prints json

## Usage

##### pp_json - examples

```sh
# curl json data and pretty print the results
curl https://coderwall.com/bobwilliams.json | pp_json

# pretty print the contents of an existing json file
less data.json | pp_json

# json data directly from the command line
echo '{"b":2, "a":1}' | pp_json
```