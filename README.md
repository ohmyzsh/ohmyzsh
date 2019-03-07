# Own Quickstart

## Install

```shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/nicosommi/oh-my-zsh/master/tools/install.sh)"
```

---

# Readme

- Unix-like operating system (macOS or Linux)
- [Zsh](https://www.zsh.org) should be installed (v4.3.9 or more recent). If not pre-installed (`zsh --version` to confirm), check the following instruction here: [Installing ZSH](https://github.com/robbyrussell/oh-my-zsh/wiki/Installing-ZSH)
- `curl` or `wget` should be installed
- `git` should be installed

### Basic Installation

Oh My Zsh is installed by running one of the following commands in your terminal. You can install this via the command-line with either `curl` or `wget`.

#### via curl

```shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/nicosommi/oh-my-zsh/master/tools/install.sh)"
```

#### via wget

```shell
sh -c "$(wget https://raw.githubusercontent.com/nicosommi/oh-my-zsh/master/tools/install.sh -O -)"
```

#### Enabling Plugins

Once you spot a plugin (or several) that you'd like to use with Oh My Zsh, you'll need to enable them in the `.zshrc` file. You'll find the zshrc file in your `$HOME` directory. Open it with your favorite text editor and you'll see a spot to list all the plugins you want to load.

```shell
vi ~/.zshrc
```

For example, this might begin to look like this:

```shell
plugins=(
  git
  bundler
  dotenv
  osx
  rake
  rbenv
  ruby
)
```

#### Using Plugins

Most plugins (should! we're working on this) include a **README**, which documents how to use them.

### Themes

We'll admit it. Early in the Oh My Zsh world, we may have gotten a bit too theme happy. We have over one hundred themes now bundled. Most of them have [screenshots](https://github.com/robbyrussell/oh-my-zsh/wiki/Themes) on the wiki. Check them out!

#### Selecting a Theme

Once you find a theme that you'd like to use, you will need to edit the `~/.zshrc` file. You'll see an environment variable (all caps) in there that looks like:

```shell
ZSH_THEME="robbyrussell"
```

To use a different theme, simply change the value to match the name of your desired theme. For example:

```shell
ZSH_THEME="agnoster" # (this is one of the fancy ones)
# see https://github.com/robbyrussell/oh-my-zsh/wiki/Themes#agnoster
```

_Note: many themes require installing the [Powerline Fonts](https://github.com/powerline/fonts) in order to render properly._

If you're feeling feisty, you can let the computer select one randomly for you each time you open a new terminal window.

```shell
ZSH_THEME="random" # (...please let it be pie... please be some pie..)
```

And if you want to pick random theme from a list of your favorite themes:

```shell
ZSH_THEME_RANDOM_CANDIDATES=(
  "robbyrussell"
  "agnoster"
)
```

## Advanced Topics

If you're the type that likes to get their hands dirty, these sections might resonate.

### Advanced Installation

Some users may want to change the default path, or manually install Oh My Zsh.

#### Custom Directory

The default location is `~/.oh-my-zsh` (hidden in your home directory)

If you'd like to change the install directory with the `ZSH` environment variable, either by running `export ZSH=/your/path` before installing, or by setting it before the end of the install pipeline like this:

In my case, just `oh-my-zsh`... no dot (hidden), to avoid default sync configurations (Megasync)

```shell
export ZSH="$HOME/oh-my-zsh"; sh -c "$(curl -fsSL https://raw.githubusercontent.com/nicosommi/oh-my-zsh/master/tools/install.sh)"
```

#### Manual Installation

##### 1. Clone the repository:

```shell
git clone https://github.com/nicosommi/oh-my-zsh.git ~/.oh-my-zsh
```

##### 2. _Optionally_, backup your existing `~/.zshrc` file:

```shell
cp ~/.zshrc ~/.zshrc.orig
```

##### 3. Create a new zsh configuration file

You can create a new zsh config file by copying the template that we have included for you.

```shell
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
```

##### 4. Change your default shell

```shell
chsh -s /bin/zsh
```

##### 5. Initialize your new zsh configuration

Once you open up a new terminal window, it should load zsh with Oh My Zsh's configuration.

### Installation Problems

If you have any hiccups installing, here are a few common fixes.

- You _might_ need to modify your `PATH` in `~/.zshrc` if you're not able to find some commands after switching to `oh-my-zsh`.
- If you installed manually or changed the install location, check the `ZSH` environment variable in `~/.zshrc`.

### Custom Plugins and Themes

If you want to override any of the default behaviors, just add a new file (ending in `.zsh`) in the `custom/` directory.

If you have many functions that go well together, you can put them as a `XYZ.plugin.zsh` file in the `custom/plugins/` directory and then enable this plugin.

If you would like to override the functionality of a plugin distributed with Oh My Zsh, create a plugin of the same name in the `custom/plugins/` directory and it will be loaded instead of the one in `plugins/`.

## Getting Updates

By default, you will be prompted to check for upgrades every few weeks. If you would like `oh-my-zsh` to automatically upgrade itself without prompting you, set the following in your `~/.zshrc`:

```shell
DISABLE_UPDATE_PROMPT=true
```

To disable automatic upgrades, set the following in your `~/.zshrc`:

```shell
DISABLE_AUTO_UPDATE=true
```

### Manual Updates

If you'd like to upgrade at any point in time (maybe someone just released a new plugin and you don't want to wait a week?) you just need to run:

```shell
upgrade_oh_my_zsh
```

Magic! 🎉

# <<<<<<< HEAD

## Uninstalling Oh My Zsh

Oh My Zsh isn't for everyone. We'll miss you, but we want to make this an easy breakup.

If you want to uninstall `oh-my-zsh`, just run `uninstall_oh_my_zsh` from the command-line. It will remove itself and revert your previous `bash` or `zsh` configuration.

## Contributing

I'm far from being a [Zsh](https://www.zsh.org/) expert and suspect there are many ways to improve – if you have ideas on how to make the configuration easier to maintain (and faster), don't hesitate to fork and send pull requests!

We also need people to test out pull-requests. So take a look through [the open issues](https://github.com/robbyrussell/oh-my-zsh/issues) and help where you can.

### Do NOT send us themes

We have (more than) enough themes for the time being. Please add your theme to the [external themes](https://github.com/robbyrussell/oh-my-zsh/wiki/External-themes) wiki page.

## Contributors

Oh My Zsh has a vibrant community of happy users and delightful contributors. Without all the time and help from our contributors, it wouldn't be so awesome.

Thank you so much!

## Follow Us

We're on the social media.

- [@ohmyzsh](https://twitter.com/ohmyzsh) on Twitter. You should follow it.
- [Oh My Zsh](https://www.facebook.com/Oh-My-Zsh-296616263819290/) on Facebook.

## Merchandise

We have [stickers, shirts, and coffee mugs available](https://shop.planetargon.com/collections/oh-my-zsh?utm_source=github) for you to show off your love of Oh My Zsh. Again, you will become the talk of the town!

> > > > > > > 52afbf77f63844abd719e565a15af2c34075de7f

## License

Oh My Zsh is released under the [MIT license](LICENSE.txt).
