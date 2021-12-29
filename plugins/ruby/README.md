# Ruby plugin

This plugin adds aliases for common commands used in dealing with [Ruby](https://www.ruby-lang.org/en/) and [gem packages](https://rubygems.org/).

To use it, add `ruby` to the plugins array in your zshrc file:

```zsh
plugins=(... ruby)
```

## Aliases

| Alias   | Command                                | Description                                          |
| ------- | -------------------------------------- | ---------------------------------------------------- |
| rb      | `ruby`                                 | The Ruby command                                     |
| sgem    | `sudo gem`                             | Run sudo gem on the system ruby, not the active ruby |
| rfind   | `find . -name "*.rb" \| xargs grep -n` | Find ruby file                                       |
| rrun    | `ruby -e`                              | Execute some code: E.g: `rrun "puts 'Hello world!'"` |
| rserver | `ruby -e httpd . -p 8080`              | Start HTTP Webrick serving local directory/files     |
| gein    | `gem install`                          | Install a gem into the local repository              |
| geun    | `gem uninstall`                        | Uninstall gems from the local repository             |
| geli    | `gem list`                             | Display gems installed locally                       |
| gei     | `gem info`                             | Show information for the given gem                   |
| geiall  | `gem info --all`                       | Display all gem versions                             |
| geca    | `gem cert --add`                       | Add a trusted certificate                            |
| gecr    | `gem cert --remove`                    | Remove a trusted certificate                         |
| gecb    | `gem cert --build`                     | Build private key and self-signed certificate        |
| geclup  | `gem cleanup -n`                       | Do not uninstall gem                                 |
| gegi    | `gem generate_index`                   | Generate index file for gem server                   |
| geh     | `gem help`                             | Provide additional help                              |
| gel     | `gem lock`                             | Generate a lockdown list of gems                     |
| geo     | `gem open`                             | Open gem source in default editor                    |
| geoe    | `gem open -e`                          | Open gem sources in preferred editor                 |
