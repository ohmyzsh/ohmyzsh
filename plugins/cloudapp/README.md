# ![CloudApp logo](https://assets-global.website-files.com/58e32bace1998d6e3fee8d71/5a6d6fef10ba58000189d801_58e32bace1998d6e3fee8f08_CloudApp-Dark-Logo.png)

[CloudApp](https://www.getcloudapp.com) brings screen recording, screenshots, and GIF creation to the cloud, in an easy-to-use enterprise-level app.

The CloudApp plugin allows you to upload a file to your CloadApp account from the command line.

### How to enable the plugin

To use it, add `cloudapp` to the plugins array of your `~/.zshrc` file:

```
plugins=(... dash)
```

Additionally, this requires:

- [Aaron Russell's `cloudapp_api` gem](https://github.com/aaronrussell/cloudapp_api)
- That you set your CloudApp credentials in `~/.cloudapp` as a simple text file like below

```
email
password
```

### How to use the plugin

`cloudapp image.png` — Uploads `image.png` to your CloudApp account, and if you're using a Mac, copies the file to your clipboard

### Contributors

- [@matthewmccullough](https://github.com/matthewmccullough)
- [@mcornella](https://github.com/mcornella)
- [@austinratcliff](https://github.com/austinratcliff)
