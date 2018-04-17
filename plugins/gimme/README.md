### Gimme plugin for oh-my-zsh

[Oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh/) plugin making life a
bit easier, when you use [gimme](https://github.com/travis-ci/gimme/) to manage
[go](https://golang.org) installations.

Provides following functions/aliases:
  - ```go-versions```: Alias for ```gimme -l```
  - ```install-gimme```: Download latest version of gimme to ~/bin
  - ```load-go```: Load the go version specified by the first argument.
    If called without argument, the 'stable' version will be loaded.
  - ```remove-go```: Remove the go version specified by the first argument from
    ~/.gimme/*
  - Completions for ```gimme```, ```load-go``` and ```remove-go```

```gimme``` is assumed to be in ```~/bin```, so make
sure to add this folder to the $PATH variable.
