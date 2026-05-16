# Sprunge plugin

This plugin uploads data and fetch URL from the pastebin http://sprunge.us

To enable it, add 'sprunge' to your plugins:

```zsh
plugins=(... sprunge)
```

## Usage

| Command                      | Description                               |
|------------------------------|-------------------------------------------|
| `sprunge filename.txt`       | Uploads filename.txt                      |
| `sprunge "this is a string"` | Uploads plain text                        |
| `sprunge < filename.txt`     | Redirects filename.txt content to sprunge |
| `echo data \| sprunge`       | Any piped data will be uploaded           |

Once sprunge has processed the input it will give you a unique HTTP address:

```console
$ sprunge "hello"
http://sprunge.us/XxjnKz
```

## Notes

- Sprunge accepts piped data, stdin redirection, text strings as input or filenames.
  Only one of these can be used at a time.
- Argument precedence goes as follows: stdin > piped input > text strings.
- If a filename is misspelled or doesn't have the necessary path description, it will NOT
  generate an error, but instead treat it as a text string.

## Credits

- Original code: [shellperson.net](https://web.archive.org/web/20190910065842/https://www.shellperson.net/sprunge-pastebin-script/).
- Adapted by: Matt Parnell (@ilikenwf).
