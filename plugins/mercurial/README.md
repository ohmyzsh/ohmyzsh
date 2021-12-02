# Mercurial plugin

This plugin adds some handy aliases for using Mercurial as well as a few
utility and prompt functions that can be used in a theme.

To use it, add `mercurial` to the plugins array in your zshrc file:

```zsh
plugins=(... mercurial)
```

## Aliases

| Alias  | Command                                                                                                     |
|--------|-------------------------------------------------------------------------------------------------------------|
| `hga`  | `hg add`                                                                                                    |
| `hgc`  | `hg commit`                                                                                                 |
| `hgca` | `hg commit --amend`                                                                                         |
| `hgb`  | `hg branch`                                                                                                 |
| `hgba` | `hg branches`                                                                                               |
| `hgbk` | `hg bookmarks`                                                                                              |
| `hgco` | `hg checkout`                                                                                               |
| `hgd`  | `hg diff`                                                                                                   |
| `hged` | `hg diffmerge`                                                                                              |
| `hgp`  | `hg push`                                                                                                   |
| `hgs`  | `hg status`                                                                                                 |
| `hgsl` | `hg log --limit 20 --template "{node|short} | {date|isodatesec} | {author|user}: {desc|strip|firstline}\n"` |
| `hgun` | `hg resolve --list`                                                                                         |
| `hgi`  | `hg incoming`                                                                                               |
| `hgl`  | `hg pull -u`                                                                                                |
| `hglr` | `hg pull --rebase`                                                                                          |
| `hgo`  | `hg outgoing`                                                                                               |
| `hglg` | `hg log --stat -v`                                                                                          |
| `hglgp`| `hg log --stat -p -v`                                                                                       |
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

You can also redefine additional vars used in the plugin (after Oh My Zsh is sourced):

```zsh
ZSH_THEME_HG_PROMPT_PREFIX="%{$fg_bold[magenta]%}hg:(%{$fg[red]%}"
ZSH_THEME_HG_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_HG_PROMPT_DIRTY="%{$fg[magenta]%}) %{$fg[yellow]%}✗%{$reset_color%}"
ZSH_THEME_HG_PROMPT_CLEAN="%{$fg[magenta]%})"
```

### Display repo branch and directory status in prompt

This is the same as git plugin does. **Note**: additional changes to `.zshrc`, or using a theme designed
to use `hg_prompt_info`, are required in order for this to work.

## Maintainers

- [ptrv](https://github.com/ptrv): original creator
- [oshybystyi](https://github.com/oshybystyi)
