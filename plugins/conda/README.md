# conda plugin

The conda plugin provides [aliases](#aliases) for `conda`, usually installed via [anaconda](https://www.anaconda.com/) or [miniconda](https://docs.conda.io/en/latest/miniconda.html).

To use it, add `conda` to the plugins array in your zshrc file:

```zsh
plugins=(... conda)
```

## Aliases

| Alias    | Command                                 | Description                                                                     |
| :------- | :-------------------------------------- | :------------------------------------------------------------------------------ |
| `cna`    | `conda activate`                        | Activate the specified conda environment                                        |
| `cnab`   | `conda activate base`                   | Activate the base conda environment                                             |
| `cncf`   | `conda env create -f`                   | Create a new conda environment from a YAML file                                 |
| `cncn`   | `conda create -y -n`                    | Create a new conda environment with the given name                              |
| `cnconf` | `conda config`                          | View or modify conda configuration                                              |
| `cncp`   | `conda create -y -p`                    | Create a new conda environment with the given prefix                            |
| `cncr`   | `conda create -n`                       | Create new virtual environment with given name                                  |
| `cncss`  | `conda config --show-source`            | Show the locations of conda configuration sources                               |
| `cnde`   | `conda deactivate`                      | Deactivate the current conda environment                                        |
| `cnel`   | `conda env list`                        | List all available conda environments                                           |
| `cni`    | `conda install`                         | Install given package                                                           |
| `cniy`   | `conda install -y`                      | Install given package without confirmation                                      |
| `cnl`    | `conda list`                            | List installed packages in the current environment                              |
| `cnle`   | `conda list --export`                   | Export the list of installed packages in the current environment                |
| `cnles`  | `conda list --explicit > spec-file.txt` | Export the list of installed packages in the current environment to a spec file |
| `cnr`    | `conda remove`                          | Remove given package                                                            |
| `cnrn`   | `conda remove -y -all -n`               | Remove all packages in the specified environment                                |
| `cnrp`   | `conda remove -y -all -p`               | Remove all packages in the specified prefix                                     |
| `cnry`   | `conda remove -y`                       | Remove given package without confirmation                                       |
| `cnsr`   | `conda search`                          | Search conda repositories for package                                           |
| `cnu`    | `conda update`                          | Update conda package manager                                                    |
| `cnua`   | `conda update --all`                    | Update all installed packages                                                   |
| `cnuc`   | `conda update conda`                    | Update conda package manager                                                    |
