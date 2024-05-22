# zsh-autosuggestions

_[Fish](http://fishshell.com/)-like fast/unobtrusive autosuggestions for zsh._

It suggests commands as you type based on history and completions.

Requirements: Zsh v4.3.11 or later

[![CircleCI](https://img.shields.io/circleci/build/github/zsh-users/zsh-autosuggestions.svg)](https://circleci.com/gh/zsh-users/zsh-autosuggestions)
[![Chat on Gitter](https://img.shields.io/gitter/room/zsh-users/zsh-autosuggestions.svg)](https://gitter.im/zsh-users/zsh-autosuggestions)

<a href="https://asciinema.org/a/37390" target="_blank"><img src="https://asciinema.org/a/37390.png" width="400" /></a>


## Installation

See [INSTALL.md](INSTALL.md).


## Usage

As you type commands, you will see a completion offered after the cursor in a muted gray color. This color can be changed by setting the `ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE` variable. See [configuration](#configuration).

If you press the <kbd>→</kbd> key (`forward-char` widget) or <kbd>End</kbd> (`end-of-line` widget) with the cursor at the end of the buffer, it will accept the suggestion, replacing the contents of the command line buffer with the suggestion.

If you invoke the `forward-word` widget, it will partially accept the suggestion up to the point that the cursor moves to.


## Configuration

You may want to override the default global config variables. Default values of these variables can be found [here](src/config.zsh).

**Note:** If you are using Oh My Zsh, you can put this configuration in a file in the `$ZSH_CUSTOM` directory. See their comments on [overriding internals](https://github.com/robbyrussell/oh-my-zsh/wiki/Customization#overriding-internals).


### Suggestion Highlight Style

Set `ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE` to configure the style that the suggestion is shown with. The default is `fg=8`, which will set the foreground color to color 8 from the [256-color palette](https://upload.wikimedia.org/wikipedia/commons/1/15/Xterm_256color_chart.svg). If your terminal only supports 8 colors, you will need to use a number between 0 and 7.

Background color can also be set, and the suggestion can be styled bold, underlined, or standout. For example, this would show suggestions with bold, underlined, pink text on a cyan background:

```sh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ff00ff,bg=cyan,bold,underline"
```

For more info, read the Character Highlighting section of the zsh manual: `man zshzle` or [online](http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Character-Highlighting).

**Note:** Some iTerm2 users have reported [not being able to see the suggestions](https://github.com/zsh-users/zsh-autosuggestions/issues/416#issuecomment-486516333). If this affects you, the problem is likely caused by incorrect color settings. In order to correct this, go into iTerm2's setting, navigate to profile > colors and make sure that the colors for Basic Colors > Background and ANSI Colors > Bright Black are **different**.


### Suggestion Strategy

`ZSH_AUTOSUGGEST_STRATEGY` is an array that specifies how suggestions should be generated. The strategies in the array are tried successively until a suggestion is found. There are currently three built-in strategies to choose from:

- `history`: Chooses the most recent match from history.
- `completion`: Chooses a suggestion based on what tab-completion would suggest. (requires `zpty` module, which is included with zsh since 4.0.1)
- `match_prev_cmd`: Like `history`, but chooses the most recent match whose preceding history item matches the most recently executed command ([more info](src/strategies/match_prev_cmd.zsh)). Note that this strategy won't work as expected with ZSH options that don't preserve the history order such as `HIST_IGNORE_ALL_DUPS` or `HIST_EXPIRE_DUPS_FIRST`.

For example, setting `ZSH_AUTOSUGGEST_STRATEGY=(history completion)` will first try to find a suggestion from your history, but, if it can't find a match, will find a suggestion from the completion engine.


### Widget Mapping

This plugin works by triggering custom behavior when certain [zle widgets](http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Zle-Widgets) are invoked. You can add and remove widgets from these arrays to change the behavior of this plugin:

- `ZSH_AUTOSUGGEST_CLEAR_WIDGETS`: Widgets in this array will clear the suggestion when invoked.
- `ZSH_AUTOSUGGEST_ACCEPT_WIDGETS`: Widgets in this array will accept the suggestion when invoked.
- `ZSH_AUTOSUGGEST_EXECUTE_WIDGETS`: Widgets in this array will execute the suggestion when invoked.
- `ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS`: Widgets in this array will partially accept the suggestion when invoked.
- `ZSH_AUTOSUGGEST_IGNORE_WIDGETS`: Widgets in this array will not trigger any custom behavior.

Widgets that modify the buffer and are not found in any of these arrays will fetch a new suggestion after they are invoked.

**Note:** A widget shouldn't belong to more than one of the above arrays.


### Disabling suggestion for large buffers

Set `ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE` to an integer value to disable autosuggestion for large buffers. The default is unset, which means that autosuggestion will be tried for any buffer size. Recommended value is 20.
This can be useful when pasting large amount of text in the terminal, to avoid triggering autosuggestion for strings that are too long.

### Asynchronous Mode

Suggestions are fetched asynchronously by default in zsh versions 5.0.8 and greater. To disable asynchronous suggestions and fetch them synchronously instead, `unset ZSH_AUTOSUGGEST_USE_ASYNC` after sourcing the plugin.

Alternatively, if you are using a version of zsh older than 5.0.8 and want to enable asynchronous mode, set the `ZSH_AUTOSUGGEST_USE_ASYNC` variable after sourcing the plugin (it can be set to anything). Note that there is [a bug](https://github.com/zsh-users/zsh-autosuggestions/issues/364#issuecomment-481423232) in versions of zsh older than 5.0.8 where <kbd>ctrl</kbd> + <kbd>c</kbd> will fail to reset the prompt immediately after fetching a suggestion asynchronously.

### Disabling automatic widget re-binding

Set `ZSH_AUTOSUGGEST_MANUAL_REBIND` (it can be set to anything) to disable automatic widget re-binding on each precmd. This can be a big boost to performance, but you'll need to handle re-binding yourself if any of the widget lists change or if you or another plugin wrap any of the autosuggest widgets. To re-bind widgets, run `_zsh_autosuggest_bind_widgets`.

### Ignoring history suggestions that match a pattern

Set `ZSH_AUTOSUGGEST_HISTORY_IGNORE` to a [glob pattern](http://zsh.sourceforge.net/Doc/Release/Expansion.html#Glob-Operators) to prevent offering suggestions for history entries that match the pattern. For example, set it to `"cd *"` to never suggest any `cd` commands from history. Or set to `"?(#c50,)"` to never suggest anything 50 characters or longer.

**Note:** This only affects the `history` and `match_prev_cmd` suggestion strategies.

### Skipping completion suggestions for certain cases

Set `ZSH_AUTOSUGGEST_COMPLETION_IGNORE` to a [glob pattern](http://zsh.sourceforge.net/Doc/Release/Expansion.html#Glob-Operators) to prevent offering completion suggestions when the buffer matches that pattern. For example, set it to `"git *"` to disable completion suggestions for git subcommands.

**Note:** This only affects the `completion` suggestion strategy.


### Key Bindings

This plugin provides a few widgets that you can use with `bindkey`:

1. `autosuggest-accept`: Accepts the current suggestion.
2. `autosuggest-execute`: Accepts and executes the current suggestion.
3. `autosuggest-clear`: Clears the current suggestion.
4. `autosuggest-fetch`: Fetches a suggestion (works even when suggestions are disabled).
5. `autosuggest-disable`: Disables suggestions.
6. `autosuggest-enable`: Re-enables suggestions.
7. `autosuggest-toggle`: Toggles between enabled/disabled suggestions.

For example, this would bind <kbd>ctrl</kbd> + <kbd>space</kbd> to accept the current suggestion.

```sh
bindkey '^ ' autosuggest-accept
```


## Troubleshooting

If you have a problem, please search through [the list of issues on GitHub](https://github.com/zsh-users/zsh-autosuggestions/issues?q=) to see if someone else has already reported it.

### Reporting an Issue

Before reporting an issue, please try temporarily disabling sections of your configuration and other plugins that may be conflicting with this plugin to isolate the problem.

When reporting an issue, please include:

- The smallest, simplest `.zshrc` configuration that will reproduce the problem. See [this comment](https://github.com/zsh-users/zsh-autosuggestions/issues/102#issuecomment-180944764) for a good example of what this means.
- The version of zsh you're using (`zsh --version`)
- Which operating system you're running


## Uninstallation

1. Remove the code referencing this plugin from `~/.zshrc`.

2. Remove the git repository from your hard drive

    ```sh
    rm -rf ~/.zsh/zsh-autosuggestions # Or wherever you installed
    ```


## Development

### Build Process

Edit the source files in `src/`. Run `make` to build `zsh-autosuggestions.zsh` from those source files.


### Pull Requests

Pull requests are welcome! If you send a pull request, please:

- Request to merge into the `develop` branch (*NOT* `master`)
- Match the existing coding conventions.
- Include helpful comments to keep the barrier-to-entry low for people new to the project.
- Write tests that cover your code as much as possible.


### Testing

Tests are written in ruby using the [`rspec`](http://rspec.info/) framework. They use [`tmux`](https://tmux.github.io/) to drive a pseudoterminal, sending simulated keystrokes and making assertions on the terminal content.

Test files live in `spec/`. To run the tests, run `make test`. To run a specific test, run `TESTS=spec/some_spec.rb make test`. You can also specify a `zsh` binary to use by setting the `TEST_ZSH_BIN` environment variable (ex: `TEST_ZSH_BIN=/bin/zsh make test`).

A docker image for testing is available [on docker hub](https://hub.docker.com/r/ericfreese/zsh-autosuggestions-test). It comes with ruby, the bundler dependencies, and all supported versions of zsh installed.

Pull the docker image with:

```sh
docker pull ericfreese/zsh-autosuggestions-test
```

To run the tests for a specific version of zsh (where `<version>` below is substituted with the contents of a line from the [`ZSH_VERSIONS`](ZSH_VERSIONS) file):

```sh
docker run -it -e TEST_ZSH_BIN=zsh-<version> -v $PWD:/zsh-autosuggestions zsh-autosuggestions-test make test
```


## License

This project is licensed under [MIT license](http://opensource.org/licenses/MIT).
For the full text of the license, see the [LICENSE](LICENSE) file.
