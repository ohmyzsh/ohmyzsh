# envy - oh-my-zsh plugin

Easily switch between shell profiles using one command.

Profiles are simple files just like .bashrc or .zshrc, located in separate directory. You can load them on demand, any time you want.

[![asciicast](https://asciinema.org/a/brayiwehsfqt5gg5dzse28p38.png)](https://asciinema.org/a/brayiwehsfqt5gg5dzse28p38)

## Usage

Create first profile by executing `envy create work`. This will put empty file under `$HOME/.envy/work`. You can put there aliases, environment variables, functions or any shell logic.

To load profile -- `envy work`.

By default, when loading zsh envy loads `default` profile if it finds it.

## Options

You can customize envy by putting these env vars in .zshrc (or .bashrc):

* `ENVY_CONFIG_DIR` - directory which contains profile files (default: $HOME/.envy)
* `ENVY_DEFAULT_ENV` - profile to be loaded when zsh starts (default: default)
