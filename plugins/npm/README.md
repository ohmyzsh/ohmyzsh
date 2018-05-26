## The npm Plugin

The [npm](https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins/npm) plugin provides many [aliases](#aliases).

Enable it by adding _npm_ to the [_plugins array_](https://github.com/robbyrussell/oh-my-zsh/blob/master/templates/zshrc.zsh-template#L61) before sourcing OMZ (see [[Plugins]]).

## Aliases

| Alias       | Command                      |
|:------------|:-----------------------------|
| npmg        | npm i -g                     |
| npmS        | npm i -S                     |
| npmD        | npm i -D                     |
| npmE        | PATH="$(npm bin)":"$PATH"    |
| npmO        | npm outdated                 |
| npmV        | npm -v                       |
| npmL        | npm list                     |
| npmL0       | npm ls --depth=0             |
| npmst       | npm start                    |
| npmt        | npm test                     |
| npmR        | npm run                      |
| npmP        | npm publish                  |
| npmI        | npm init                     |