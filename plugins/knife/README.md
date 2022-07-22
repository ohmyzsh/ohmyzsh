# knife plugin

This plugin adds completion for [knife](https://docs.chef.io/knife.html), a command-line tool
to interact with [Chef](https://chef.io), a platform to automate and manage infrastructure via
code.

To use it, add `knife` to the plugins array in your zshrc file:
```zsh
plugins=(... knife)
```

## Options

- `KNIFE_RELATIVE_PATH`: if set to `true`, the completion script will look for local cookbooks
  under the `cookbooks` folder in the chef root directory. It has preference over the other two
  options below. **Default:** empty.

- `KNIFE_COOKBOOK_PATH`: if set, it points to the folder that contains local cookbooks, for
   example: `/path/to/my/chef/cookbooks`. **Default:** `cookbook_path` field in `knife.rb`
   (see below).

- `KNIFE_CONF_PATH`: variable pointing to the `knife.rb` configuration file, for example
  `/path/to/my/.chef/knife.rb`. Only used if `$KNIFE_COOKBOOK_PATH` isn't set. If it exists,
  `$PWD/.chef/knife.rb` is used instead. Otherwise, if it's set, its value is used.
  **Default**: `$HOME/.chef/knife.rb`.
