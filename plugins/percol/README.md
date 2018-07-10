## percol

Provides some useful function to make [percol](https://github.com/mooz/percol) work with zsh history and [jump plugin](https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/jump/jump.plugin.zsh)

### Preview
![Preview](http://t1.qpic.cn/mblogpic/eb1c8f9d2b9f62d19fa8/2000.jpg)

### Requirements

```shell
pip install percol
```

And [jump](https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/jump/jump.plugin.zsh) for `oh-my-zsh` is a optional requirement.

### Usage

For default

- `^-r` bind to `percol_select_history`.You can use it to grep your history with percol.

- `^-b` bind to `percol_select_marks`.You can use it to grep your bookmarks with percol.

