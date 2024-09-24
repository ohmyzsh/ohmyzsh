# PDF Plugin for Oh My Zsh

This plugin provides a convenient way to manage and open PDF files from your terminal using fuzzy finding.

## Features

- Automatically detects available PDF readers (okular, evince, xpdf, firefox, and some others)
- Creates and maintains a list of PDF files in your home directory
- Uses `fzf` for fuzzy finding and selecting PDF files
- Fallback to `find` command if `fd` is not available


## Requirements

- Zsh with Oh My Zsh framework
- Any suitable PDF reader (e.g., okular, evince, xpdf, firefox, zathura, mupdf, qpdfview, atril)
- `fzf` for fuzzy finding (recommended)
- `fd` command (optional, improves file search performance)



1. Activate the plugin in `~/.zshrc`:

   ```zsh
   plugins=(... pdf)
   ```

2. Restart your shell or run:

   ```zsh
   source ~/.zshrc
   ```

## Usage
Example usage:

```zsh
# Open fzf to select a PDF
pdf

# Open a specific PDF file
pdf ~/Documents/example.pdf
```
## Configuration

The plugin will automatically create a directory `~/.config/pdfiledoc/` and a file `pdfs.txt` to store the list of PDF files. This list is updated when:

- The `pdfs.txt` file doesn't exist
- No PDF is selected from the existing list
