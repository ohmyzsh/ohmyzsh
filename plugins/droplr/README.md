# droplr

Use [Droplr](https://droplr.com/) from the comand line to upload files and shorten
links. It needs to have [Droplr.app](https://droplr.com/apps) installed and logged
in. MacOS only.

To use it, add `droplr` to the `$plugins` variable in your zshrc file:

```zsh
plugins=(... droplr)
```

Author: [Fabio Fernandes](https://github.com/fabiofl)

## Examples

- Upload a file: `droplr ./path/to/file/`

- Shorten a link: `droplr http://example.com`
