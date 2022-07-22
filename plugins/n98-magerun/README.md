# n98-magerun plugin

The swiss army knife for Magento developers, sysadmins and devops. The tool provides a huge set of well tested command line commands which save hours of work time.

The [n98-magerun plugin](https://github.com/netz98/n98-magerun) provides many
[useful aliases](#aliases) as well as completion for the `n98-magerun` command.

Enable it by adding `n98-magerun` to the plugins array in your zshrc file:

```zsh
plugins=(... n98-magerun)
```

## Aliases

| Alias     | Command                                            | Description                                                                       |
| --------- | -------------------------------------------------- | --------------------------------------------------------------------------------- |
| n98       | `n98-magerun.phar`                                 | The N98-Magerun phar-file (Version 1)                                             |
| n98-2     | `n98-magerun2.phar`                                | The N98-Magerun phar-file (Version 2)                                             |
| mage-get  | `wget https://files.magerun.net/n98-magerun.phar`  | Download the latest stable N98-Magerun phar-file from the file-server (Version 1) |
| mage2-get | `wget https://files.magerun.net/n98-magerun2.phar` | Download the latest stable N98-Magerun phar-file from the file-server (Version 2) |
