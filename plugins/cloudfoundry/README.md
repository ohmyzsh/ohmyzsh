# Cloudfoundry Plugin

This plugin is intended to offer a few simple aliases for regular users of the [Cloud Foundry Cli][1]. Most are just simple aliases that will save a bit of typing. Others include mini functions and or accept parameters. Take a look at the table below for details.

Alias | Replaces | Arguments
----- | -------- | ---------
cfl   | cf login                 | n/a 
cft   | cf targe                 | n/a 
cfa   | cf apps                  | n/a 
cfs   | cf servies               | n/a 
cfm   | cf markeplace            | n/a 
cfp   | cf push                  | n/a 
cfcs  | cf creat-service         | n/a 
cfbs  | cf bind-ervice           | n/a 
cfus  | cf unbin-service         | n/a 
cfds  | cf delet-service         | n/a 
cfup  | cf cups                  | n/a 
cfp   | cf push                  | n/a 
cflg  | cf logs                  | n/a 
cfr   | cf route                 | n/a 
cfe   | cf env                   | n/a 
cfsh  | cf ssh                   | n/a 
cfsc  | cf scale                 | n/a 
cfev  | cf event                 | n/a 
cfdor | cf delet-orphaned-rutes  | n/a 
cfbpk | cf buildpacks            | n/a 
cfap       | cf app                    | <APP_NAME>
cfh.       | export CF_HOME=$(pwd)/.cf | n/a
cfh~       | export CF_HOME=~/.cf      | n/a
cfhu       | unset CF_HOME             | n/a
cfpm       | cf push -f                | <MANIFEST_FILE>
cflr       | cf logs --recent          | <APP_NAME>
cfsrt      | cf start                  | <APP_NAME>
cfstp      | cf stop                   | <APP_NAME>
cfstg      | cf restage                | <APP_NAME>
cfdel      | cf delete                 | <APP_NAME>
cfsrtall   | cf apps | awk | '/stopped/ { system("cf start " $1)}'} | n/a
cfstpall   | cf apps | awk | '/started/ { system("cf stop " $1)}'} | n/a

For help and advice on what any of the commands does, consult the built in `cf` help functions as follows:-

```bash
cf help # List the most popular and commonly used commands
cf help -a # Complete list of all possible commands
cf <COMMAND_NAME> --help # Help on a specific command including arguments and examples
```

Alternatively, seek out the [online documentation][3]. And don't forget, there are loads of great [community plugins for the cf-cli][4] command line tool that can greatly extend its power and usefulness.

## Contributors

Contributed to `oh_my_zsh` by [benwilcock][2].  

[1]: https://docs.cloudfoundry.org/cf-cli/install-go-cli.html
[2]: https://github.com/benwilcock
[3]: https://docs.cloudfoundry.org/cf-cli/getting-started.html
[4]: https://plugins.cloudfoundry.org/