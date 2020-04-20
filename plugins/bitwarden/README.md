# Bitwarden plugin

This plugin provides basic bitwarden aliases to manage your bitwarden session

-------


This adds two aliases:

### `bwpass`

`bwpass` uses an open session to fetch a password, can be combined with `pbcopy` on mac or `xclip` on linux to copy a password:

```
$ bwpass google.com | pbcopy
```

It will request the master password if an open session couldn't be used.

### `bwunlock`

Unlock and saves the session in the current shell


```
$ bwunlock
? Master password: [input is hidden]
```


Crafted by Carlos Palhares ([@xjunior](https://github.com/xjunior))

