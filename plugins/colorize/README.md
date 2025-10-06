# colorize

With this plugin you can syntax-highlight file contents of over 300 supported languages and other text formats.

Colorize will highlight the content based on the filename extension. If it can't find a syntax-highlighting
method for a given extension, it will try to find one by looking at the file contents. If no highlight method
is found it will just cat the file normally, without syntax highlighting.

## Setup

To use it, add colorize to the plugins array of your `~/.zshrc` file:
```
plugins=(... colorize)
```

## Configuration

### Requirements

This plugin requires that at least one of the following tools is installed:

* [Chroma](https://github.com/alecthomas/chroma)
* [Pygments](https://pygments.org/download/)

### Colorize tool

Colorize supports `pygmentize` and `chroma` as syntax highlighter. By default colorize uses `pygmentize` unless it's not installed and `chroma` is. This can be overridden by the `ZSH_COLORIZE_TOOL` environment variable:

```
ZSH_COLORIZE_TOOL=chroma
```

### Styles

Pygments offers multiple styles. By default, the `default` style is used, but you can choose another theme by setting the `ZSH_COLORIZE_STYLE` environment variable:

```
ZSH_COLORIZE_STYLE="colorful"
```

### Chroma Formatter Settings

Chroma supports terminal output in 8 color, 256 color, and true-color. If you need to change the default terminal output style from the standard 8 color output, set the `ZSH_COLORIZE_CHROMA_FORMATTER` environment variable:

```
ZSH_COLORIZE_CHROMA_FORMATTER=terminal256
```

## Usage

* `ccat <file> [files]`: colorize the contents of the file (or files, if more than one are provided).
  If no files are passed it will colorize the standard input.

* `cless [less-options] <file> [files]`: colorize the contents of the file (or files, if more than one are provided) and open less.
  If no files are passed it will colorize the standard input.
  The LESSOPEN and LESSCLOSE will be overwritten for this to work, but only in a local scope.
