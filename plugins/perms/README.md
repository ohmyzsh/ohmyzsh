## Perms

Plugin to handle some unix filesystem permissions quickly

### Usage

* `set755` recursively sets all directories located within the current working directory and sub directories to octal 755.
* `set644` recursively sets all files located within the current working directory and sub directories to octal 644.
* `fixperms` is a wrapper around `set755` and `set644` applied to a specified directory or the current directory otherwise. It also prompts prior to execution unlike the other two  aliases.