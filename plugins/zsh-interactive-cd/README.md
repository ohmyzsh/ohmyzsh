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
