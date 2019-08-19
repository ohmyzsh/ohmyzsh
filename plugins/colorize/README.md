# colorize

With this plugin you can syntax-highlight file contents of over 300 supported languages and other text formats.

Colorize will highlight the content based on the filename extension. If it can't find a syntax-highlighting
method for a given extension, it will try to find one by looking at the file contents. If no highlight method
is found it will just cat the file normally, without syntax highlighting.

To use it, add colorize to the plugins array of your zshrc file:
```
plugins=(... colorize)
```

## Styles

Pygments offers multiple styles. By default, the `default` style is used, but you can choose another theme by setting the `ZSH_COLORIZE_STYLE` environment variable:

`ZSH_COLORIZE_STYLE="colorful"`

## Usage

* `ccat  <file> [files]`: colorize the contents of the file (or files, if more than one are provided). 
  If no arguments are passed it will colorize the standard input or stdin.

* `cless <file> [files]`: colorize the contents of the file (or files, if more than one are provided) and
  open less. If no arguments are passed it will colorize the standard input or stdin.

Note that `cless` will behave as less when provided more than one file: you have to navigate files with
the commands `:n` for next and `:p` for previous. The downside is that less options are not supported.
But you can circumvent this by either using the LESS environment variable, or by running `ccat file1 file2|less --opts`.
In the latter form, the file contents will be concatenated and presented by less as a single file.

## Requirements

You have to install Pygments first: [pygments.org](http://pygments.org/download/)
