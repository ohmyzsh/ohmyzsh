# pj

The `pj` plugin (short for `Project Jump`) allows you to define several
folders where you store your projects, so that you can jump there directly
by just using the name of the project directory.

Original idea and code by Jan De Poorter ([@DefV](https://github.com/DefV))
Source: https://gist.github.com/pjaspers/368394#gistcomment-1016

## Usage

1. Enable the `pj` plugin:

   ```zsh
   plugins=(... pj)
   ```

2. Set `$PROJECT_PATHS` in your ~/.zshrc:

   ```zsh
   PROJECT_PATHS=(~/src ~/work ~/"dir with spaces")
   ```

You can now use one of the following commands:

##### `pj my-project`:

`cd` to the directory named "my-project" found in one of the `$PROJECT_PATHS`
directories. If there are several directories named the same, the first one
to appear in `$PROJECT_PATHS` has preference.

For example:
```zsh
PROJECT_PATHS=(~/code ~/work)
$ ls ~/code    # ~/code/blog ~/code/react
$ ls ~/work    # ~/work/blog ~/work/project
$ pj blog      # <-- will cd to ~/code/blog
```

##### `pjo my-project`

Open the project directory with your defined `$EDITOR`. This follows the same
directory rules as the `pj` command above.

Note: `pjo` is an alias of `pj open`.
