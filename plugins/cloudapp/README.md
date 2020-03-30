# CloudApp plugin

[CloudApp](https://www.getcloudapp.com) brings screen recording, screenshots, and GIF creation to the cloud, in an easy-to-use enterprise-level app. The CloudApp plugin allows you to upload a file to your CloadApp account from the command line.

To use it, add `cloudapp` to the plugins array of your `~/.zshrc` file:

```zsh
plugins=(... cloudapp)
```

## Requirements

1. [Aaron Russell's `cloudapp_api` gem](https://github.com/aaronrussell/cloudapp_api#installation)

2. That you set your CloudApp credentials in `~/.cloudapp` as a simple text file like below:
   ```
   email
   password
   ```

## Usage

- `cloudapp <filename>`: uploads `<filename>` to your CloudApp account, and if you're using
  macOS, copies the URL to your clipboard.
