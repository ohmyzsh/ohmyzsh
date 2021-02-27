# conda plugin

The conda plugin provides many [aliases](#aliases).

To use it, add `conda` to the plugins array in your zshrc file:

```zsh
plugins=(... conda)
```

## Aliases
| Alias  | Command                               |
| :----- | :---                                  |
| ca     | conda activate                        |
| cab    | conda activate base                   |
| cde    | conda deactivate                      |
| cel    | conda env list                        |
| cl     | conda list                            |
| cle    | conda list --export                   |
| cles   | conda list --explicit > spec-file.txt |
| ci     | conda install                         |
| ciy    | conda install -y                      |
| cr     | conda remove                          |
| cry    | conda remove -y                       |
| ccn    | conda create -y -n                    |
| ccp    | conda create -y -p                    |
| ccf    | conda env create -f                   |
| crn    | conda remove -y -all -n               |
| crp    | conda remove -y -all -p               |
| cconf  | conda config                          |
| ccss   | conda config --show-source            |
| cu     | conda update                          |
| cuc    | conda update conda                    |
| cua    | conda update --all                    |

## Welcome to make contribution
Anaconda has become an important platform for data scientists and it seems strange to me that ohmyzsh doesn't have an integrated conda plugin. Like the convention used in the [git](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git) plugin, I add some useful alias for conda commands which are the ones I use everyday. Welcome to make the plugin more powerful.
