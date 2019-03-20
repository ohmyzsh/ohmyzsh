# `transfer` plugin

[`transfer.sh`](https://transfer.sh) is an easy to use file sharing service from the command line

## Usage

Add `transfer` to your plugins array in your zshrc file:
```zsh
plugins=(... transfer)
```

Then you can:

- transfer a file:

```zsh
transfer file.txt
```

- transfer a whole directory (it will be automatically compressed):

```zsh
transfer directory/
```
