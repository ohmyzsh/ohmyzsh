# `svn` plugin

This plugin adds some utility functions to display additional information regarding your current
svn repository. See http://subversion.apache.org/ for the full svn documentation.

To use it, add `svn` to your plugins array:

```zsh
plugins=(... svn)
```

## Functions

| Command               | Description                                 |
|:----------------------|:--------------------------------------------|
| `svn_prompt_info`     | Shows svn prompt in themes                  |
| `in_svn`              | Checks if we're in an svn repository        |
| `svn_get_repo_name`   | Get repository name                         |
| `svn_get_branch_name` | Get branch name (see [caveats](#caveats))   |
| `svn_get_rev_nr`      | Get revision number                         |
| `svn_dirty`           | Checks if there are changes in the svn repo |

## Caveats

The plugin expects the first directory to be the current branch / tag / trunk. So it returns
the first path element if you don't use branches.

## Usage on themes

To use this in the `agnoster` theme follow these instructions:

1. Enable the svn plugin

2. Add the following lines to your `zshrc` file:

    ```shell
    prompt_svn() {
        local rev branch
        if in_svn; then
            rev=$(svn_get_rev_nr)
            branch=$(svn_get_branch_name)
            if [[ $(svn_dirty_choose_pwd 1 0) -eq 1 ]]; then
                prompt_segment yellow black
                echo -n "$rev@$branch"
                echo -n "±"
            else
                prompt_segment green black
                echo -n "$rev@$branch"
            fi
        fi
    }
    ```

3. Override the agnoster `build_prompt()` function:

    ```zsh
    build_prompt() {
        RETVAL=$?
        prompt_status
        prompt_context
        prompt_dir
        prompt_git
        prompt_svn
        prompt_end
    }
    ```

