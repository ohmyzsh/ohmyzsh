# `svn` plugin

This plugin adds some utility functions to display additional information regarding your current
svn repsitiory. See http://subversion.apache.org/ for the full svn documentation.

## Functions

| Command                | Description                             |
|:-----------------------|:----------------------------------------|
|svn_prompt_info         | prompt for some themes                  |
|in_svn                  | within svn directory                    |
|svn_get_repo_name       |                                         |
|svn_get_branch_name     | branch name (see caveats)              |
|svn_get_rev_nr          | revision number                         |
|svn_dirty               | changes in this subversion repo         |

## Caveats

The plugin expects the first directory to be the current branch / tag / trunk. So, it returns
the first path element if you don't use branches.

## Usage

To use it, add `svn` to your plugins array:
```sh
plugins=(... svn)
```

### Agnoster theme git-like prompt

Enable the svn plugin and add the followind lines to your ```~/.zshrc```

```shell
prompt_svn() {
    local rev branch
    if in_svn; then
        rev=$(svn_get_rev_nr)
        branch=$(svn_get_branch_name)
        if [ `svn_dirty_choose_pwd 1 0` -eq 1 ]; then
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

override the agnoster build_prompt() function:

```shell
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

