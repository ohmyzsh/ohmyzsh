# svn-fast-info plugin

Faster alternative to the main SVN plugin implementation. Works with svn 1.6 and newer.
Use as a drop-in replacement to the svn plugin, not as complementary.

To use it, add `svn-fast-info` to the plugins array in your zshrc file:

```zsh
plugins=(... svn-fast-info)
```

It's faster because it has an efficient use of svn (single svn call) which saves a lot on a huge codebase.
It displays the current status of the local files (added, deleted, modified, replaced, or else...)

Use `svn_prompt_info` method to display the svn repository status in your theme.

## Functions

- `svn_prompt_info`: displays all the available information regarding the status of the svn repository.

- `svn_repo_need_upgrade`: shows whether the repository needs upgrading. `svn_prompt_info` queries the
  rest of functions or not based on the result of this function.

- `svn_current_branch_name`: shows the current branch.

- `svn_repo_root_name`: displays the repository root.

- `svn_current_revision`: shows the currently checked-out revision.

- `svn_status_info`: shows a bunch of symbols depending on the status of the files in the repository.

## Options

- `ZSH_THEME_SVN_PROMPT_PREFIX`: sequence displayed at the beginning of the prompt info output.

- `ZSH_THEME_SVN_PROMPT_SUFFIX`: sequence displayed at the end of the prompt info output.

- `ZSH_THEME_SVN_PROMPT_CLEAN`: sequence displayed when the status of the repository is clean.

- `ZSH_THEME_SVN_PROMPT_ADDITIONS`: sequence displayed if there are added files in the repository.
  **Default:** `+`.

- `ZSH_THEME_SVN_PROMPT_DELETIONS`: sequence displayed if there are deleted files in the repository.
  **Default:** `✖`.

- `ZSH_THEME_SVN_PROMPT_MODIFICATIONS`: sequence displayed if there are modified files in the repository.
  **Default:** `✎`.

- `ZSH_THEME_SVN_PROMPT_REPLACEMENTS`: sequence displayed if there are replaced files in the repository.
  **Default:** `∿`.

- `ZSH_THEME_SVN_PROMPT_UNTRACKED`: sequence displayed if there are untracked files in the repository.
  **Default:** `?`.

- `ZSH_THEME_SVN_PROMPT_DIRTY`: sequence displayed if the repository is dirty.
  **Default:** `!`.
