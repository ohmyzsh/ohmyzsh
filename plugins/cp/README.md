# cp plugin

This plugin defines a `cpv` function that uses `rsync` so that you
get the features and security of this command.

To enable, add `cp` to your `plugins` array in your zshrc file:

```zsh
plugins=(... cp)
```

## Description

The enabled options for rsync are:

- `-p`: preserves permissions.

- `-o`: preserves owner.

* `-g`: preserves group.

* `-b`: make a backup of the original file instead of overwriting it, if it exists.

* `-r`: recurse directories.

* `-hhh`: outputs numbers in human-readable format, in units of 1024 (K, M, G, T).

* `--backup-dir=/tmp/rsync`: move backup copies to "/tmp/rsync".

* `-e /dev/null`: only work on local files (disable remote shells).

* `--progress`: display progress.
