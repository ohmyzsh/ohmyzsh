# Mercurial plugin

This plugin adds some handy aliases for using Mercurial as well as a few
utility and prompt functions that can be used in a theme.

To use it, add `mercurial` to the plugins array in your zshrc file:

```zsh
plugins=(... mercurial)
```

## Aliases

| Alias   | Command                                     |
| ------- | ------------------------------------------- |
| `hga`   | `hg add`                                    |
| `hgc`   | `hg commit`                                 |
| `hgca`  | `hg commit --amend`                         |
| `hgci`  | `hg commit --interactive`                   |
| `hgb`   | `hg branch`                                 |
| `hgba`  | `hg branches`                               |
| `hgbk`  | `hg bookmarks`                              |
| `hgco`  | `hg checkout`                               |
| `hgd`   | `hg diff`                                   |
| `hged`  | `hg diffmerge`                              |
| `hgp`   | `hg push`                                   |
| `hgs`   | `hg status`                                 |
| `hgsl`  | `hg log --limit 20 --template "<template>"` |
| `hgun`  | `hg resolve --list`                         |
| `hgi`   | `hg incoming`                               |
| `hgl`   | `hg pull -u`                                |
| `hglr`  | `hg pull --rebase`                          |
| `hgo`   | `hg outgoing`                               |
| `hglg`  | `hg log --stat -v`                          |
| `hglgp` | `hg log --stat -p -v`                       |

## Prompt usage

- Switch to a theme which uses `hg_prompt_info`

- Or customize the `$PROMPT` variable of your current theme to contain current folder mercurial repo info.
  This can be done by putting a custom version of the theme in `$ZSH_CUSTOM` or by changing `$PROMPT` in
  `.zshrc` after loading the theme.

  For example, for the `robbyrussell` theme you need to modify `$PROMPT` var by adding `$(hg_prompt_info)`
  after `$(git_prompt_info)`, so it looks like this:

  ```zsh
  PROMPT='${ret_status}%{$fg_bold[green]%}%p %{$fg[cyan]%}%c %{$fg_bold[blue]%}$(git_prompt_info)$(hg_prompt_info)%{$fg_bold[blue]%} % %{$reset_color%}'
  ```

You can define the below variables to customize the prompt, after Oh-My-Zsh is source.  The prompt will be generated in this order:

1. PREFIX variable.
2. IDENTIFY variable, which is used with "hg identify --template":
    * Branch name, if not "default".
    * Bookmarks, if any.  The active bookmark will have '*' appended.
    * Tags, if any.
3. Either the DIRTY or CLEAN variables.
4. SUFFIX variable.

Spaces are only needed to separate non-empty parts, but no space will be inserted before DIRTY or CLEAN.

```zsh
ZSH_THEME_HG_PROMPT_PREFIX="%{$fg[magenta]%}hg:(%{$fg[red]%}"
ZSH_THEME_HG_PROMPT_IDENTIFY='{separate(" ",ifeq(branch,"default","",branch),"{activebookmark}*",tags)}'
    # See "hg help templates"; the default is $ZSH_THEME_HG_PROMPT_IDENTIFY_DEFAULT.
ZSH_THEME_HG_PROMPT_DIRTY="%{$fg[magenta]%}) %{$fg_bold[yellow]%}✗"
ZSH_THEME_HG_PROMPT_CLEAN="%{$fg[magenta]%})"
ZSH_THEME_HG_PROMPT_SUFFIX="%{$reset_color%}"
```

### Display repo branch and directory status in prompt

This is the same as git plugin does. **Note**: additional changes to `.zshrc`, or using a theme designed
to use `hg_prompt_info`, are required in order for this to work.

## Maintainers

- [ptrv](https://github.com/ptrv): original creator
- [oshybystyi](https://github.com/oshybystyi)
