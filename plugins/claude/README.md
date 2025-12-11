## Zsh completion function `_claude`

This version aims to be:

- Pure zsh (no jq, sed, awk, etc.).
- Generous with known subcommands and options from public Claude Code CLI docs/cheatsheets.[2][3]
- Extensible via simple arrays.


## How to enable in Oh My Zsh

1. In `~/.zshrc`, add `claude` to plugins:

   ```zsh
   plugins=(
     git
     claude
   )
   ```

2. Reload your shell:

   ```zsh
   exec zsh
   ```

Now `claude <TAB>` will complete subcommands and flags on macOS, Linux, *BSD, and WSL2, because it relies only on zsh’s built-in completion engine and standard shell constructs.
***
