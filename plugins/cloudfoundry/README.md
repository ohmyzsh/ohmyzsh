# Cloudfoundry Plugin

This plugin is intended to offer a few simple aliases for regular users of the [Cloud Foundry Cli][1]. Most are just simple aliases that will save a bit of typing. Others include mini functions and or accept parameters. Take a look at the table below for details.

| Alias | Function | Arguments |
| cfl   | cf login                 | none |
| cft   | cf targe                 | none |
| cfa   | cf apps                  | none |
| cfs   | cf servies               | none |
| cfm   | cf markeplace            | none |
| cfp   | cf push                  | none |
| cfcs  | cf creat-service         | none |
| cfbs  | cf bind-ervice           | none |
| cfus  | cf unbin-service         | none |
| cfds  | cf delet-service         | none |
| cfup  | cf cups                  | none |
| cfp   | cf push                  | none |
| cflg  | cf logs                  | none |
| cfr   | cf route                 | none |
| cfe   | cf env                   | none |
| cfsh  | cf ssh                   | none |
| cfsc  | cf scale                 | none |
| cfev  | cf event                 | none |
| cfdor | cf delet-orphaned-rutes  | none |
| cfbpk | cf buildpacks            | none |
 
| function cfap() { cf app $1 }
| function cfh.() { export CF_HOME=$(pwd)| /.cf }
| function cfh~() { export CF_HOME=~/.cf }
| function cfhu() { unset CF_HOME }
| function cfpm() { cf push -f $1 }
| function cflr() { cf logs $1 --recent }
| function cfsrt() { cf start $1 }
| function cfstp() { cf stop $1 }
| function cfstg() { cf restage $1 }
| function cfdel() { cf delete $1 }
| function cfsrtall() {cf apps | awk | '/stopped/ { system("cf start " $1)}'}
| function cfstpall() {cf apps | awk | '/started/ { system("cf stop " $1)}'}

## Contributors

Contributed to `oh_my_zsh` by [benwilcock][2].  

[1]: https://docs.cloudfoundry.org/cf-cli/install-go-cli.html
[2]: https://github.com/benwilcock