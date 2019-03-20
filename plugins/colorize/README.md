# colorize

With this plugin you can syntax-highlight file contents of over 300 supported languages and other text formats.

To use it, add colorize to the plugins array of your zshrc file:
```
plugins=(... colorize)
```

## Usage

* `ccat <file> [files]`: colorize the contents of the file (or files, if more than one are provided). If no arguments are passed it will colorize the standard input or stdin.

Colorize will highlight the content based on the filename extension. If it can't find a syntax-highlighting method for a given extension, it will try to find one by looking at the file contents. If no highlight method is found it will just cat the file normally, without syntax highlighting.

## Requirements

You have to install Pygments first: [pygments.org](http://pygments.org/download/)
