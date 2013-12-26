oh-my-zsh::plugin::nodeenv-prompt
====================================

This is a plugin derived from
[virtualenv prompt](https://github.com/tonyseek/oh-my-zsh-virtualenv-prompt).
It support to customize the
[nodeenv](https://github.com/ekalinin/nodeenv)
prompt in oh-my-zsh themes.

Installation
------------

You can install this plugin from shell:

    repo="git://github.com/chenhouwu/oh-my-zsh-nodeenv-prompt.git"
    target="$HOME/.oh-my-zsh/custom/plugins/nodeenv-prompt"

    git clone $repo $target


Customize Theme
---------------

There are two constant strings which could be overrided in your custom theme.

- `ZSH_THEME_NODEENV_PROMPT_PREFIX`
- `ZSH_THEME_NODEENV_PROMPT_SUFFIX`

And the function `nodeenv_prompt_info` could be used in the prompt of your
theme.

Example
-------

See the [oh-my-zsh::theme::seeker](https://github.com/tonyseek/oh-my-zsh-seeker-theme).
