# git-remote-branch plugin

This plugin adds completion for [grb](https://github.com/robbyrussell/oh-my-zsh/wiki/Plugins#git-remote-branch) completion.


To use it, add `git-remote-branch` to the plugins array of your `.zshrc` file:
```
plugins=(... git-remote-branch)
```

| Commands                                      |
|:----------------------------------------------|
| `grb create branch_name [origin_server]`      |
| `grb publish branch_name [origin_server]`     |
| `grb delete branch_name [origin_server]`      |
| `grb track branch_name [origin_server]`       |
| `grb rename new_branch_name [origin_server]`  |
| `grb explain create`                          |
