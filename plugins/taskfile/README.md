# `Taskfile` plugin

This plugin provides completion for [Task](https://taskfile.dev/), as well as the shortcut alias `t`

To use it add `taskfile` to the plugins array in your zshrc file.

```bash
plugins=(... taskfile)
```

## Usage

Of course, you need [Task](https://taskfile.dev/installation/) to be installed.

Typing `t [TAB]` will give you a list of commands provided by your `Taskfile.yml` 

<br/>
---

Thanks to [Berger91](https://github.com/Berger91/taskfile-zsh-autocompletion) for the original completion method.
