# Dnote Plugin

This plugin adds auto-completion for [Dnote](https://www.getdnote.com/), a simple command line notebook.

To use it, add `dnote` to the plugins array in your zshrc file:

```zsh
plugins=(dnote)
```

## Usage

At the basic level, this plugin completes all Dnote commands.

```zsh
$ dnote a(press <TAB> here)
```

would result in:

```zsh
$ dnote add
```

For some commands, this plugin dynamically suggests matching book names.

For instance, if you have three books that begin with 'j': 'javascript', 'job', 'js',

```zsh
$ dnote view j(press <TAB> here)
```

would result in:

```zsh
$ dnote v j
javascript  job         js
```

As another example,

```zsh
$ dnote edit ja(press <TAB> here)
```

would result in:


```zsh
$ dnote v javascript
``````
