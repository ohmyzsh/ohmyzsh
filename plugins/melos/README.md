## Melos plugin

The Melos plugin provides completion and useful aliases for [Melos](https://melos.invertase.dev/).

To use it, add `melos` to the plugins array of your zshrc file:

```zsh
plugins=(... melos)
```

## Aliases

| Alias      | Command                 | Description                                                                |
| :--------- | :---------------------- | :------------------------------------------------------------------------- |
| `mb`       | `melos bs`              | Initializes the workspace, installs remaining package dependencies.        |                                     |
| `mc`       | `melos clean`           | Cleans the current workspace.                                              |
| `me`       | `melos exec`            | Execute an arbitrary command in each package.                              |
| `mla`      | `melos list --all`      | List information about all of the local packages.                          |
| `mll`      | `melos list --long`     | Show extended/verbose information.                                         |
| `mlr`      | `melos list --relative` | Use package paths relative to the root of the workspace.                   |
| `mlp`      | `melos list --parsable` | Show parsable output instead of columnified view.                          |
| `mlj`      | `melos list --json`     | Show information as a JSON array.                                          |
| `mlg`      | `melos list --gviz`     | Show dependency graph in Graphviz DOT language.                            |
| `mlc`      | `melos list --cycles`   | Find cycles in package dependencies in the workspace.                      |
| `mp`       | `melos publish`         | Publish any unpublished packages or package versions in your repository.   |
| `mpdr`     | `melos p --dry-run`     | Publish packages with dry run.                                             |
| `mpndr`    | `melos p --no-dry-run`  | Publish packages without dry run.                                          |
| `mr`       | `melos run`             | Run a script by name defined in the workspace melos.yaml config file.      |
| `mv`       | `melos version`         | Automatically version and generate changelogs for all packages.            |
| `mvp`      | `--prerelease`          | Version any packages with changes as a prerelease.                         |
| `mvg`      | `--graduate`            | Graduate current prerelease versioned packages to stable versions.         |
| `mvc`      | `--changelog`           | Update CHANGELOG.md files.                                                 |
| `mvgt`     | `--git-tag-version`     | Create a git tag.                                                          |
| `mvru`     | `--release-url`         | Generate and print a link to the prefilled release creation page.          |
| `mva`      | `--all`                 | Version private packages that are skipped by default.                      |
      
