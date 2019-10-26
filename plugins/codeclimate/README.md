# Code Climate CLI

codeclimate is a command line interface for the Code Climate analysis platform. It allows you to run Code Climate engines on your local machine inside of Docker containers.

To use it, add `codeclimate` to the plugins array in your zshrc file:

```zsh
plugins=(... codeclimate)
```

## Commands

```
    analyze [-f format] [-e engine[:channel]] [--dev] [path]
    console
    engines:install
    engines:list
    help [command]
    prepare [--allow-internal-ips]
    validate-config
    version
```

The following is a brief explanation of each available command.

* `analyze`
  Analyze all relevant files in the current working directory. All
  engines that are enabled in your `.codeclimate.yml` file will run, one after
  another. The `-f` (or `format`) argument allows you to set the output format of
  the analysis (using `json`, `text`, or `html`). The `--dev` flag lets you run
  engines not known to the CLI, for example if you're an engine author developing
  your own, unreleased image.

  You can optionally provide a specific path to analyze. If not provided, the
  CLI will analyze your entire repository, except for your configured
  `exclude_paths`. When you do provide an explicit path to analyze, your
  configured `exclude_paths` are ignored, and normally excluded files will be
  analyzed.

  You can also pipe in source in combination with a path to analyze code that is
  not yet written to disk. This is useful when you want to check if your source
  code style matches the project's. This is also a good way to implement
  integration with an editor to check style on the fly.

* `console`
  start an interactive session providing access to the classes
  within the CLI. Useful for engine developers and maintainers.

* `engines:install`
  Compares the list of engines in your `.codeclimate.yml` file to those that
  are currently installed, then installs any missing engines.

* `engines:list`
  Lists all available engines in the
  [Code Climate Docker Hub](https://hub.docker.com/u/codeclimate/)

* `help`
  Displays a list of commands that can be passed to the Code Climate CLI.

* `validate-config`
  Validates the `.codeclimate.yml` file in the current working directory.

* `version`
  Displays the current version of the Code Climate CLI.