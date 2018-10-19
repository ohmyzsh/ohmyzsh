# colorize

With this plugin you can syntax-highlight file contents of over 300 supported languages and other text formats.

To use it, add colorize to the plugins array of your zshrc file:
```
plugins=(... colorize)
```

## Usage

* `ccat <file> [...files]`: prints the contents of the file (or files, if more than one are provided). 
It highlights the content based on the filename extension. If it can't find a syntax-highlighting method for a given extension, it will try to find one by looking at the file contents. If all else fails, it will just cat the file without syntax highlighting.

## Requirements

You have to install Pygments first: [pygments.org](http://pygments.org/download/)
