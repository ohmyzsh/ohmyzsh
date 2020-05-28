# git-prompt plugin

A `zsh` prompt that displays information about the current git repository. In particular:
the branch name, difference with remote branch, number of files staged or changed, etc.

To use it, add `git-prompt` to the plugins array in your zshrc file:

```zsh
plugins=(... git-prompt)
```

See the [original repository](https://github.com/olivierverdier/zsh-git-prompt).

## Examples

The prompt may look like the following:

- `(master↑3|✚1)`: on branch `master`, ahead of remote by 3 commits, 1 file changed but not staged
- `(status|●2)`: on branch `status`, 2 files staged
- `(master|✚7…)`: on branch `master`, 7 files changed, some files untracked
- `(master|✖2✚3)`: on branch `master`, 2 conflicts, 3 files changed
- `(experimental↓2↑3|✔)`: on branch `experimental`; your branch has diverged by 3 commits, remote by 2 commits; the repository is otherwise clean
- `(:70c2952|✔)`: not on any branch; parent commit has hash `70c2952`; the repository is otherwise clean

## Prompt Structure

By default, the general appearance of the prompt is:

```
(<branch><branch tracking>|<local status>)
```

The symbols are as follows:

### Local Status Symbols

| Symbol | Meaning                        |
|--------|--------------------------------|
| ✔      | repository clean               |
| ●n     | there are `n` staged files     |
| ✖n     | there are `n` unmerged files   |
| ✚n     | there are `n` unstaged files   |
| …      | there are some untracked files |

### Branch Tracking Symbols

| Symbol | Meaning                                                       |
|--------|---------------------------------------------------------------|
| ↑n     | ahead of remote by `n` commits                                |
| ↓n     | behind remote by `n` commits                                  |
| ↓m↑n   | branches diverged: other by `m` commits, yours by `n` commits |

## Customisation

- Set the variable `ZSH_THEME_GIT_PROMPT_CACHE` to any value in order to enable caching.
- You may also change a number of variables (whose name start with `ZSH_THEME_GIT_PROMPT_`) 
  to change the appearance of the prompt. Take a look at the bottom of the [plugin file](git-prompt.plugin.zsh)`
  to see what variables are available.


**Enjoy!**
