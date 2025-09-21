# zsh-interactive-cd

This plugin provides an interactive way to change directories in zsh using fzf.

## Demo

![demo](demo.gif)

## Installation

1. Install [fzf](https://github.com/junegunn/fzf) by following its [installation instruction](https://github.com/junegunn/fzf#installation).

2. Add `zsh-interactive-cd` to your plugin list in `~/.zshrc`:

   ```zsh
   plugins=(... zsh-interactive-cd)
   ```

## Usage

Press tab for completion as usual, it'll launch fzf automatically. Check fzf’s [readme](https://github.com/junegunn/fzf#search-syntax) for more search syntax usage.

### Hidden Directories

By default, `zsh-interactive-cd` hides directories that start with `.` (dotfolders).  

You can enable hidden directories in the suggestion list by setting:

```zsh
# Show hidden directories in interactive cd
export ZIC_SHOW_HIDDEN=true
```