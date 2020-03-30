# gcloud

This plugin provides completion support for the
[Google Cloud SDK CLI](https://cloud.google.com/sdk/gcloud/).

To use it, add `gcloud` to the plugins array in your zshrc file.

```zsh
plugins=(... gcloud)
```

It relies on you having installed the SDK using one of the supported options
listed [here](https://cloud.google.com/sdk/install).

## Plugin Options

* Set `CLOUDSDK_HOME` in your `zshrc` file before you load oh-my-zsh if you have
your GCloud SDK installed in a non-standard location. The plugin will use this
as the base for your SDK if it finds it set already.

* If you do not have a `python2` in your `PATH` you'll also need to set the
`CLOUDSDK_PYTHON` environment variable at the end of your `.zshrc`. This is
used by the SDK to call a compatible interpreter when you run one of the
SDK commands.
