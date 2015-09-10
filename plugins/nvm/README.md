# NVM

The `nvm` plugin locates and loads [NVM](https://github.com/creationix/nvm) if it is installed on this system. It also provides completion support, either through its own completion definition, or the `bash_completion` shipped with NVM itself.

### Installation Locations

This plugin looks in a few well-known locations for the NVM installation, in the following order:

* `$NVM_DIR` - Lets user force loading from an arbitrary location
* `~/.nvm` - Default installation location for NVM
* `$(brew --prefix nvm)` - Mac Homebrew's NVM installation location

After NVM is loaded, `$NVM_DIR` is set as part of NVM initialization, so you can use it regardless of whether you set it explicitly earlier.

Note that the NVM installer adds the commands to load NVM (by `source`ing it from the install location) directly to your `~/.zshrc` or other initialization file. This is not required for NVM to be "installed" in the sense that this plugin means. This plugin provides an alternate way of loading NVM, and you shouldn't use both. If you use this plugin, remove any `source ~/.nvm/nvm.sh` or similar lines from your `~/.zshrc`.

Other package managers may install NVM to other locations, and we'll add those in if you let us know about them by [opening an issue or PR on GitHub](https://github.com/robbyrussell/oh-my-zsh/issues/new).

### Completion Alternatives

This plugin supplies a zsh-native `_nvm` completion definition, which is loaded by default. This provides descriptions of the options it can complete.

You can also use the portable `bash` completion definition that is bundled with the NVM installation. This has the advantages:
* More complete with respect to options (because you're using the exact completion definitions for the version of NVM you're running).
* Able to complete Node.js versions based on the versions installed in the NVM you have loaded.

To use NVM's bundled bash completions, set `ZSH_NVM_BUNDLED_COMPLETION=true` in your `~/.zshrc` before loading Oh My Zsh.

### Environment Variables

* `$ZSH_NVM_BUNDLED_COMPLETION` - if `true`, uses NVM's own completion definition instead of the OMZ nvm plugin's definition.
