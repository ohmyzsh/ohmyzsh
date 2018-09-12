# jenv plugin

[jenv](https://www.jenv.be/) is a Java version manager similiar to [rbenv](https://github.com/rbenv/rbenv)
and [pyenv]|(https://github.com/yyuu/pyenv).

This plugin initializes jenv and adds provides the jenv_prompt_info function to add Java
version information to prompts.

To use, add `jenv` to your plugins array in your zshrc file:

```zsh
plugins=(... jenv)
```
