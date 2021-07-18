# conda plugin

The conda plugin provides [aliases](#aliases) to `conda`, usually it's installed by [anaconda](https://www.anaconda.com/) or [miniconda](https://docs.conda.io/en/latest/miniconda.html).

To use it, add `conda` to the plugins array in your zshrc file:

```zsh
plugins=(... conda)
```

## Aliases
| Alias | Command                               |
| :---  | :---                                  |
| ca    | conda activate                        |
| cab   | conda activate base                   |
| cde   | conda deactivate                      |
| cl    | conda list                            |
| cle   | conda list --export                   |
| cles  | conda list --explicit > spec-file.txt |
| cel   | conda env list                        |
| ci    | conda install                         |
| ciy   | conda install -y                      |
| cr    | conda remove                          |
| cry   | conda remove -y                       |
| crn   | conda remove -y -all -n               |
| crp   | conda remove -y -all -p               |
| ccn   | conda create -y -n                    |
| ccp   | conda create -y -p                    |
| ccf   | conda env create -f                   |
| cconf | conda config                          |
| ccss  | conda config --show-source            |
| cu    | conda update                          |
| cuc   | conda update conda                    |
| cua   | conda update --all                    |

## Known Conflicts
Perform the following commands to check conflicts,
```bash
for alias in $(rg -N '^alias' conda.plugin.zsh | sed 's/^alias //g;s/=.*$//g'); do # Check each alias in `conda` plugin
        rg '[^-:\.%<]\b'"$alias"'\b[^-]' ~/.oh-my-zsh/plugins
done
```
and end up with
* `cr`, `ccp`, and `cu` are conflict with `composer` plugin.
So an solution to make sure the `conda` plugin is used is to make sure `conda` is loaded after `composer` is loaded, aka in `.zshrc`
```zsh
plugins=(... composer ... conda ...)
```

*Updated March 1, 2020*
