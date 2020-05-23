## percol

Provides some useful function to make [percol](https://github.com/mooz/percol) work with zsh history and [jump plugin](https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/jump/jump.plugin.zsh)

### Requirements

```shell
pip install percol
```

And [jump](https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/jump/jump.plugin.zsh) for `oh-my-zsh` is a optional requirement.

### Usage

For default

- `^-r` bind to `percol_select_history`.You can use it to grep your history with percol.

- `^-b` bind to `percol_select_marks`.You can use it to grep your bookmarks with percol.

