# rbenv plugin

The primary job of this plugin is to provide `rbenv_prompt_info` which can be added to your theme to include Ruby
version and gemset information into your prompt.

Some functionality of this plugin will not work unless you also have the rbenv plugin *gemset* installed.
https://github.com/jf/rbenv-gemset

To use it, add `rbenv` to the plugins array in your zshrc file:
```zsh
plugins=(... rbenv)
```

## Alias

| Alias          | Command             | Description                      |
|----------------|---------------------|----------------------------------|
| rubies         | `rbenv versions`    | List the installed Ruby versions |
| gemsets        | `rbenv gemset list` | List the existing gemsets        |

## Functions

* `current_ruby`: The version of Ruby currently being used.
* `current_gemset`: The name of the current gemset.
* `gems`: Lists installed gems with enhanced formatting and color.
* `rbenv_prompt_info`: For adding information to your prompt. Format: `<ruby version>@<current gemset>`.
