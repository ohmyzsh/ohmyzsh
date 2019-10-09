# Sprunge plugin

This plugin uploads data and fetch URL from the pastebin http://sprunge.us

To enable it, add 'sprunge' to your plugins:

```
plugins=(... sprunge)
```


## Usage
Command | Description
--------| ----------------------
sprunge filename.txt | uploads filename.txt
sprunge "this is a string" | uploads plain text
sprunge < filename.txt | redirects filename.txt content to sprunge
piped data \| sprunge | any piped data will be uploaded

## Output

Once Sprunge has finished handling the input it will give you a unique HTTP address like the following:

```
http://sprunge.us/aXZI
```

## Notes
- Sprunge accepts piped data, STDIN redirection, text strings as input. Sprunge can only accept one input at a time.
- Argument precedence goes as follows: STDIN > piped input > text strings.
- If a filename is mispelled or doesn't have the necessary path description, it will NOT generate an error, but instead treat it as a text string.