## OH-MY-ZSH PLUGIN HELPER

This is a pretty straightforward plugin for oh-my-zsh that's sole purpose is to
be a helper for other available OMZ plugins.

---

### FEATURES

| Function              | Alias | Description                                   |
|:----------------------|:-----:|----------------------------------------------:|
| disable_plugin        | phdp  | Disable specified plugin                      |
| enable_plugin         | phep  | Enable specified plugin                       |
| print_all_plugins     | phpap | List all plugins                              |
| print_enabled_plugins | phpep | List all enabled plugins                      |
| print_all_readmes     | phpar | Get a list of all plugins with a README       |
| print_aliases         | phpa  | Print list of aliases for specified plugin(s) |
| print_readme          | phpr  | Print README for the specified plugin         |

---

### NOTES

The output of the README's  in the print_readme function looks a lot better with
[Pandoc](http://johnmacfarlane.net/pandoc/), but it's not required.

##### Mac OS
```
brew install pandoc
```
##### Ubuntu
```
sudo apt-get install pandoc
```

---

### LICENSE

The project is licensed under the
[MIT-license](https://github.com/mfaerevaag/wd/blob/master/LICENSE).

---

### CONTRIBUTORS
KhasMek - Creator

---
