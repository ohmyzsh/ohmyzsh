# Ruby plugin

This plugin adds aliases for common commands used in dealing with [Ruby](https://www.ruby-lang.org/en/) and [gem packages](https://rubygems.org/).

To use it, add `ruby` to the plugins array in your zshrc file:

```zsh
plugins=(... ruby)
```

## Aliases

| Alias | Command                                | Description                                          |
|-------|----------------------------------------|------------------------------------------------------|
| rb    | `ruby`                                 | The Ruby command                                     |
| sgem  | `sudo gem`                             | Run sudo gem on the system ruby, not the active ruby |
| rfind | `find . -name "*.rb" \| xargs grep -n` | Find ruby file                                       |
| gin   | `gem install`                          | Install a gem into the local repository              |
| gun   | `gem uninstall`                        | Uninstall gems from the local repository             |
| gli   | `gem list`                             | Display gems installed locally                       |
