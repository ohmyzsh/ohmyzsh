<h1 align="center">fzf-git</h1>
<p align="center">
  Git shortcuts, powered by
  <a href="https://github.com/junegunn/fzf">fzf</a>
</p>

This plugin adds useful shortcuts to zsh for interacting with git.

To use it, add `fzf-git` to the plugins array in your zshrc file:

```zsh
plugins=(... fzf-git)
```

## Shortcuts

| Shortcut                               | Command    | Effect                    |
| -------------------------------------- | ---------- | ------------------------- |
| <kbd>Ctrl + g</kbd><kbd>Ctrl + s</kbd> | git status | Insert selected file      |
| <kbd>Ctrl + g</kbd><kbd>Ctrl + b</kbd> | git branch | Insert selected branch    |
| <kbd>Ctrl + g</kbd><kbd>Ctrl + t</kbd> | git tag    | Insert selected tag       |
| <kbd>Ctrl + g</kbd><kbd>Ctrl + l</kbd> | git log    | Insert hash of select log |
| <kbd>Ctrl + g</kbd><kbd>Ctrl + r</kbd> | git remote | Insert selected remote    |
