![Oh My Zsh](https://s3.amazonaws.com/ohmyzsh/oh-my-zsh-logo.png)


Oh My Zsh is an open source, community-driven framework for managing your [zsh](http://www.zsh.org/) configuration. That sounds boring. Let's try this again.

__Oh My Zsh is a way of life!__ Once installed, your terminal prompt will become the talk of the town _or your money back!_ Each time you interace with your command prompt, you'll be able take advantage of the hundreds of bundled plugins and pretty themes. Strangers will come up to you in cafés and ask you, _"that is amazing. are you some sort of genius?"_ Finally, you'll begin to get the sort of attention that you always felt that you deserved. ...or maybe you'll just use the time that you saved to start flossing more often.

To learn more, visit http://ohmyz.sh and/or follow [ohmyzsh](https://twitter.com/ohmyzsh) on twitter.

## Getting Started


### Prerequisites

__Disclaimer:__ _Oh My Zsh works best on Mac OS X and Linux._

* Unix-based operating system (Mac OS X or Linux)
* [Zsh](http://www.zsh.org) should be installed (v4.3.9 or more recent)
  * This is commonly pre-installed. (`zsh --version` to confirm)
* `curl` or `wget` should be installed

### Basic Installation

Oh My Zsh is installed by running one of the following commands in your terminal. You can install this via the command-line with either `curl` or `wget`.

#### via curl

`curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh`

#### via wget

`wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O - | sh`

## Using Oh My Zsh

### Plugins

Oh My Zsh comes with a shit load of plugins to take advantage of. You can take a look in the [plugins](https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins) directory and/or the [wiki](https://github.com/robbyrussell/oh-my-zsh/wiki/Plugins) to see what's currently available.

#### Enabling Plugins

If you spot a plugin (or several) that you would like to use with Oh My Zsh, you will need to edit the `~/.zshrc` file. Once you open it with your favorite editor, you'll see a spot to list all the plugins that you'd like Oh My Zsh to load in initialization.

For example, this line might begin to look like...

`plugins=(git bundler osx rake ruby)`

#### Using Plugins

Most plugins (should! we're working on this) include a __README__, which documents how to use them.

### Themes

We'll admit it. Early in the Oh My Zsh world... we may have gotten a far too theme happy. We have over one hundred themes now bundled. Most of them have [screenshots](https://wiki.github.com/robbyrussell/oh-my-zsh/themes) on the wiki. Check them out!

#### Selecting a Theme

_Robby's theme is the default one. It's not the fanciest one. It's not the simplest one. It's just right (for him)._

Once you find a theme that you want to use, you will need to edit the `~/.zshrc` file. You'll see an environment variable (all caps) in there that looks like:

`ZSH_THEME="robbyrussell"`

To use a different theme, simple change the value to match the name of your desired theme. For example:

`ZSH_THEME="agnoster"` (this is one of the fancy ones)

Open up a new terminal window and your prompt should look something like...

## Advanced Topics

If you're the type that likes to get their hands dirty... these sections might resonate.

### Advanced Installation

For those who want to install this manually and/or set custom paths.

#### Custom Directory

The default location is `~/.oh-my-zsh` (hidden in your home directory)

If you'd like to change the install directory with the `ZSH` environment variable, either by running `export ZSH=/your/path` before installing, or by setting it before the end of the install pipeline like this:

`curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | ZSH=~/.dotfiles/zsh sh`

#### Manual Installation

##### 1. Clone the repository:

`git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh`

##### 2. *Optionally*, backup your existing @~/.zshrc@ file:

`cp ~/.zshrc ~/.zshrc.orig`

##### 3. Create a new zsh configuration file

You can create a new zsh config file by copying the template that we included for you.

`cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc`

##### 4. Change your default shell

`chsh -s /bin/zsh`

##### 5. Initialize your new zsh configuration

Once you open up a new terminal window, it should load zsh with Oh My Zsh's configuration.

### Installation Problems

If you have any hiccups installing, here are a few common fixes.

* You _might_ need to modify your `PATH` in `~/.zshrc` if you're not able to find some commands after switching to `oh-my-zsh`.
* If you installed manually or changed the install location, check the `ZSH` environment variable in `~/.zshrc`.

### Custom Plugins and Themes

If you want to override any of the default behaviors, just add a new file (ending in `.zsh`) in the `custom/` directory.

If you have many functions that go well together, you can put them as a `abcyzeae.plugin.zsh` file in the `custom/plugins/` directory and then enable this plugin.

If you would like to override the functionality of a plugin distributed with Oh My Zsh, create a plugin of the same name in the `custom/plugins/` directory and it will be loaded instead of the one in `plugins/`.

## Getting Updates

By default, you will be prompted to check for upgrades every few weeks. If you would like `oh-my-zsh` to automatically upgrade itself without prompting you, set the following in your `~/.zshrc`:

`DISABLE_UPDATE_PROMPT=true`

To disable automatic upgrades, set the following in your `~/.zshrc`:

`DISABLE_AUTO_UPDATE=true`

### Manual Updates

If you'd like to upgrade at any point in time (maybe someone just released a new plugin and you don't want to wait a week?)... you just need to run:

`upgrade_oh_my_zsh`

Magic!

## Uninstalling Oh My Zsh

Oh My Zsh isn't for everyone. We'll miss you, but we want to make this an easy breakup.

If you want to uninstall `oh-my-zsh`, just run `uninstall_oh_my_zsh` from the command-line. It will remove itself and revert your previous `bash` or `zsh` configuration.

## Contributing

I'm far from being a [Zsh](http://www.zsh.org/) expert and suspect there are many ways to improve – if you have ideas on how to make the configuration easier to maintain (and faster), don't hesitate to fork and send pull requests!

We also need people to test out pull-requests. So take a look through [the open issues](https://github.com/robbyrussell/oh-my-zsh/issues) and help where you can.

### Do NOT Send Us Themes

We have (more than) enough themes for the time being. Please fork the project and add one in there – you can let people know how to grab it from there.

## Contributors

Oh My Zsh has a vibrant community of happy users and delightful contributors. Without all the time and help from our contributors, it wouldn't be so awesome.

Thank you so much!

## Follow Us

We have an [ohmyzsh](https://twitter.com/ohmyzsh) account. You should follow it.

## Merchandise

We have [stickers](http://shop.planetargon.com/products/ohmyzsh-stickers-set-of-3-stickers) and [shirts](http://shop.planetargon.com/products/ohmyzsh-t-shirts) for you to show off your love of Oh My Zsh. Again, this will help you become the talk of the town!

## LICENSE

Oh My Zsh is released under the [MIT license](https://github.com/robbyrussell/oh-my-zsh/blob/master/MIT-LICENSE.txt).
