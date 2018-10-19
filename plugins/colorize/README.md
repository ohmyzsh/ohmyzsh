# colorize

With this plugin you can syntax highlight file content of over 300 supported languages and other text formats. It highlights the content based on the filename extension. If no highlighting method supported for given extension then it tries guess it by looking for file content.

To use it, add colorize to the plugins array of your zshrc file:
```
plugins=(... colorize)
```

## Prerequisites

You have to install Pygments first: [pygments.org](pygments.org)

## Plugin commands
* `ccat [FILE]` Shows output of the file on the command line.
