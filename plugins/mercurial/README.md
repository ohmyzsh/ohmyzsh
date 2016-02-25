# Mercurial plugin

### Usage
Update .zshrc:

1. Add name to the list of plugins, e.g. `plugins=(... mercurial ...)`

2. Switch to a theme that uses the `hg_prompt_info` function.

   _Or_, customize the `$PROMPT` variable of your current theme to use the `hg_prompt_info` function.
   You can do this 2 ways:
   
   - Copy the theme into `$ZSH_CUSTOM` and modify the `$PROMPT` variable there.

   - Change the `$PROMPT` variable in `.zshrc`, after loading oh-my-zsh.

   **WARNING:** do not change the theme directly in the `themes/` folder. That will cause conflicts when trying to update.

   Example: if you're using the `robbyrussell` theme, you need to modify the `$PROMPT` var by appending `$(hg_prompt_info)` to it, so it looks like this:

   ```zsh
   PROMPT='${ret_status} %{$fg[cyan]%}%c%{$reset_color%} $(git_prompt_info)$(hg_prompt_info)'
   ```

3. Initialize additional vars used in plugin. So in short put next in **.zshrc**:

   ```
   ZSH_THEME_HG_PROMPT_PREFIX="%{$fg_bold[magenta]%}hg:(%{$fg[red]%}"
   ZSH_THEME_HG_PROMPT_SUFFIX="%{$reset_color%}"
   ZSH_THEME_HG_PROMPT_DIRTY="%{$fg[magenta]%}) %{$fg[yellow]%}✗%{$reset_color%}"
   ZSH_THEME_HG_PROMPT_CLEAN="%{$fg[magenta]%})"
   ```

### What's inside?
#### Adds handy aliases:
###### general
* `hgc` - `hg commit`
* `hgb` - `hg branch`
* `hgba` - `hg branches`
* `hgbk` - `hg bookmarks`
* `hgco` - `hg checkout`
* `hgd`  - `hg diff`
* `hged` - `hg diffmerge`

###### pull and update
* `hgi` - `hg incoming`
* `hgl` - `hg pull -u`
* `hglr` - `hg pull --rebase`
* `hgo` - `hg outgoing`
* `hgp` - `hg push`
* `hgs` - `hg status`
* `hgsl` - `hg log --limit 20 --template "{node|short} | {date|isodatesec} | {author|user}: {desc|strip|firstline}\n"`

###### this is the 'git commit --amend' equivalent
* `hgca` - `hg qimport -r tip ; hg qrefresh -e ; hg qfinish tip`

###### list unresolved files (since hg does not list unmerged files in the status command)
* `hgun` - `hg resolve --list`

#### Displays repo branch and directory status in prompt
This is the same as git plugin does.

**Note**: Additional changes to **.zshrc**, or using a theme designed to use `hg_prompt_info`, are required in order for this to work.

### Mantainers
[ptrv](https://github.com/ptrv) - original creator

[oshybystyi](https://github.com/oshybystyi) - created this README and know how most of code works
