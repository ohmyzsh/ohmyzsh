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
| gi    | `gem info`                             | Show information for the given gem                   |
| giall | `gem info --all`                       | Display all gem versions                             |
| gca   | `gem cert --add`                       | Add a trusted certificate                            |
| gcr   | `gem cert --remove`                    | Remove a trusted certificate                         |
| gcb   | `gem cert --build`                     | Build private key and self-signed certificate        |
| gclup | `gem cleanup -n`                       | Do not uninstall gem                                 |
| ggi   | `gem generate_index`                   | Generate index file for gem server                   |
| ghlp  | `gem help`                             | Provide additional help                              |
| gl    | `gem lock`                             | Generate a lockdown list of gems                     |
| go    | `gem open`                             | Open gem source in default editor                    |
| goe   | `gem open -e`                          | Open gem sources in preferred editor                 |

