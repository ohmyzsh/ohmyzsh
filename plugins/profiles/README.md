# profiles plugin

This plugin allows you to create separate configuration files for zsh based
on a domain of your host.

It takes your `HOST` and looks for files named according to the domain parts 
in `$ZSH_CUSTOM/profiles/` directory.

For example, for `HOST=my.domain.com`, it will try to load the following files:

```text
$ZSH_CUSTOM/profiles/my.domain.com
$ZSH_CUSTOM/profiles/domain.com
$ZSH_CUSTOM/profiles/com
```

To use it, add profiles to the plugins array of your zshrc file:

```sh
plugins=(... profiles)
```
