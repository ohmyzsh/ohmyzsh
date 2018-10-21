# Conda

The plugin provides functions and aliases for the use with [Conda](https://conda.io/docs/).

To use it, add `conda` to the plugins array of your zshrc file:
```
plugins=(... conda)
```
## Aliases

| Alias | Command           | Description                                    |
|-------|-------------------|------------------------------------------------|
| cac   | `source activate` | Activate a given virtual environment           |
| cup   | `conda update`    | Update given conda package                     |
| csr   | `conda search`    | Search conda repositories for package          |
| cin   | `conda install`   | Install given package                          |
| crm   | `conda remove`    | Remove given package                           |
| ccr   | `conda create -n` | Create new virtual environment with given name |

## Functions

| Function          | Usage               | Description                                      |
|-------------------|---------------------|--------------------------------------------------|
| conda_prompt_info | `conda_prompt_info` | Return the name of the current Conda environment |

Use `ZSH_THEME_CONDA_PREFIX` and `ZSH_THEME_CONDA_SUFFIX` to print delimeters
etc. in front or after the environment name. Defaults to `[` and `]`.
