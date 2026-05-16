# Branch plugin

This plugin displays the current Git or Mercurial branch, fast. If in a Mercurial repository,
also display the current bookmark, if present.

To use it, add `branch` to the plugins array in your zshrc file:

```zsh
plugins=(... branch)
```

## Speed test

- `hg branch`:

  ```console
  $ time hg branch
  0.11s user 0.14s system 70% cpu 0.355 total
  ```

- branch plugin:

  ```console
  $ time zsh /tmp/branch_prompt_info_test.zsh
  0.00s user 0.01s system 78% cpu 0.014 total
  ```

## Usage

Copy your theme to `$ZSH_CUSTOM/themes/` and modify it to add `$(branch_prompt_info)` in your prompt.
This example is for the `robbyrussell` theme:

```diff
diff --git a/themes/robbyrussell.zsh-theme b/themes/robbyrussell.zsh-theme
index 2fd5f2cd..9d89a464 100644
--- a/themes/robbyrussell.zsh-theme
+++ b/themes/robbyrussell.zsh-theme
@@ -1,5 +1,5 @@
 PROMPT="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )"
-PROMPT+=' %{$fg[cyan]%}%c%{$reset_color%} $(git_prompt_info)'
+PROMPT+=' %{$fg[cyan]%}%c%{$reset_color%} $(branch_prompt_info)'

 ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
 ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
```

## Maintainer

Victor Torres (<vpaivatorres@gmail.com>)
