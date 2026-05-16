# git lfs plugin

The git lfs plugin provides [aliases](#aliases) and [functions](#functions) for [git-lfs](https://github.com/git-lfs/git-lfs).

To use it, add `git-lfs` to the plugins array in your zshrc file:

```zsh
plugins=(... git-lfs)
```

## Aliases

| Alias    | Command                             |
| :------- | :---------------------------------- |
| `glfsi`  | `git lfs install`                   |
| `glfst`  | `git lfs track`                     |
| `glfsls` | `git lfs ls-files`                  |
| `glfsmi` | `git lfs migrate import --include=` |

## Functions

| Function | Command                                         |
| :------- | :---------------------------------------------- |
| `gplfs`  | `git lfs push origin "$(current_branch)" --all` |
