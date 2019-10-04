# Tugboat Plugin

This plugin adds autocompletion for Tugboat commands.

Tugboat is a command line tool for interacting with your
[DigitalOcean droplets.](https://www.digitalocean.com/products/droplets/)

Further documentation of which commands are available and their functions can be found in the
[Tugboat repository](https://github.com/petems/tugboat).


## Usage

To use it, add it to the plugins array in your `~/.zshrc` file:

```
plugins=(... tugboat)
```

Then, reload your `zsh` configuration:

```
source ~/.zshrc
```

And just start smashing that `TAB` key!

```
tugboat <TAB>
```

## Contributors

* [Dimitri Steyaert](https://github.com/DimitriSteyaert) (author)
* [Griffin J Rademacher](https://github.com/favorable-mutation) (README)
