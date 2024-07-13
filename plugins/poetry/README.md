# Poetry Plugin

This plugin automatically installs [Poetry](https://python-poetry.org/)'s completions for you, and keeps them up to date as your Poetry version changes.

To use it, add `poetry` to the plugins array in your zshrc file:

```zsh
plugins=(... poetry)
```

## Aliases

| Alias | Command                                            | Description    
|:----- |--------------------------------------------------- |:--------------------------------------------------------------------------------------- |
| pad   | `poetry add`                                       | Add packages to `pyproject.toml` and install them                                       |
| pbld  | `poetry build`                                     | Build the source and wheels archives                                                    |
| pch   | `poetry check`                                     | Validate the content of the `pyproject.toml` and its consistency with the `poetry.lock` |
| pcmd  | `poetry list`                                      | Display all the available Poetry commands                                               |
| pconf | `poetry config --list`                             | Allow you to edit poetry config settings and repositories                               |
| pexp  | `poetry export --without-hashes > requirements.txt | Export the lock file to `requirements.txt`                                              |
| pin   | `poetry init`                                      | Create a `pyproject.toml` interactively                                                 |
| pinst | `poetry install`                                   | Read the `pyproject.toml`, resolve the dependencies, and install them                   |
| plck  | `poetry lock`                                      | Lock the dependencies in `pyproject.toml` without installing                            |
| pnew  | `poetry new`                                       | Create a directory structure suitable for most Python projects                          |
| ppath | `poetry env info --path`                           | Get the path of the currently activated virtualenv`                                     |
| pplug | `poetry self show plugins`                         | List all the installed Poetry plugins                                                   |
| ppub  | `poetry publish`                                   | Publish the builded (`poetry build` command) package to the remote repository           |
| prm   | `poetry remove`                                    | Remove packages from `pyproject.toml` and uninstall them                                |
| prun  | `poetry run`                                       | Executes the given command inside the project’s virtualenv                              |
| psad  | `poetry self add`                                  | Add the Poetry plugin and install dependencies to make it work                          |
| psh   | `poetry shell`                                     | Spawns a shell within the virtual environment. If one doesn’t exist, it will be created |
| pshw  | `poetry show`                                      | List all the available dependencies                                                     |
| pslt  | `poetry show --latest`                             | List lastest version of the dependencies                                                |
| psup  | `poetry self update`                               | Update Poetry to the latest version (default) or to the specified version               |
| psync | `poetry install --sync`                            | Synchronize your environment with the `poetry.lock`                                     |
| ptree | `poetry show --tree`                               | List the dependencies as tree                                                           |
| pup   | `poetry update`                                    | Get the latest versions of the dependencies and to update the `poetry.lock`             |
| pvinf | `poetry env info`                                  | Get basic information about the currently activated virtualenv                          |
| pvoff | `poetry config virtualenvs.create false`           | Disable automatic virtualenv creation                                                   |
| pvrm  | `poetry env remove`                                | Delete existing virtualenvs                                                             |
| pvrma | `poetry env remove --all`                          | Delete all existing virtualenvs                                                         |
| pvu   | `poetry env use`                                   | Switch between existing virtualenvs                                                     |
