# catimg

Plugin for displaying images on the terminal using the the `catimg.sh` script provided by [posva](https://github.com/posva/catimg)

## Requirements

- `convert` (ImageMagick)

## Enabling the plugin

1. Open your `.zshrc` file and add `catimg` in the plugins section:

   ```zsh
   plugins=(
       # all your enabled plugins
       catimg
   )
   ```

2. Restart the shell or restart your Terminal session:

   ```console
   $ exec zsh
   $
   ```

## Functions

| Function | Description                              |
| -------- | ---------------------------------------- |
| `catimg` | Displays the given image on the terminal |

## Usage examples

[![asciicast](https://asciinema.org/a/204702.png)](https://asciinema.org/a/204702)
