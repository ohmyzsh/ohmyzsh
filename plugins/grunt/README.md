# grunt-zsh-completion

`grunt-zsh-completion` is the zsh completion script for
[grunt](https://github.com/gruntjs/grunt)/
[grunt-cli](https://github.com/gruntjs/grunt-cli)

It quickly response because it uses the cache.

![Screenshot1](https://raw.github.com/yonchu/grunt-zsh-completion/master/img/screenshot01.png)

![Screenshot2](https://raw.github.com/yonchu/grunt-zsh-completion/master/img/screenshot02.png)


## Installation

Put the `_grunt` file to the `fpath` directory.

```sh
$ cp _grunt /usr/local/share/zsh/site-functions/
$ exec zsh
```

Where the `fpath` directory is ?

```sh
$ echo "$fpath" | tr " " "\n"
```

## Installation for oh-my-zsh

1. In the command line, change to `oh-my-zsh` plugins directory:

    ```console
    $ cd ~/.oh-my-zsh/custom/plugins
    ```

2. Clone the repository into a new directory called `grunt`:

    ```console
    git clone https://github.com/yonchu/grunt-zsh-completion.git grunt
    ```

3. Include `grunt` plugin to your .zshrc file along with other plugins:

    ```zsh
    ...
    plugins=(git grunt)
    ...
    ```

4. Restart your terminal application.

## Usage

### Enable caching

If you want to use the cache, set the followings in your .zshrc:

```zsh
zstyle ':completion:*' use-cache yes
```

### Settings

Show grunt file path:

```zsh
zstyle ':completion::complete:grunt::options:' show_grunt_path yes
```

Cache expiration days (default: 7):

```zsh
zstyle ':completion::complete:grunt::options:' expire 1
```

Note that if you change the zstyle settings,
you should delete the cache file and restart zsh.

```console
$ rm ~/.zcompcache/grunt
$ exec zsh
```