# Cloudfoundry Plugin

This plugin is intended to offer a few simple aliases for regular users of the [Cloud Foundry Cli][1]. Most are just simple aliases that will save a bit of typing. Others include mini functions and or accept parameters. Take a look at the table below for details.

| Alias    | Command                     | Description                                                              |
|----------|-----------------------------|--------------------------------------------------------------------------|
| cfl      | `cf login`                  | Login to Cloud Foundry                                                   |
| cft      | `cf target`                 | Target the cli at a specific Org/Space in Cloud Foundry                  |
| cfa      | `cf apps`                   | List all applications in the current Org/Space                           |
| cfs      | `cf services`               | List all services in the current Org/Space                               |
| cfm      | `cf marketplace`            | List the services available in the Marketplace                           |
| cfp      | `cf push`                   | Push your application code to Cloud Foundry                              |
| cfcs     | `cf create-service`         | Create a service based on a Marketplace offering                         |
| cfbs     | `cf bind-service`           | Bind an application to a service you created                             |
| cfus     | `cf unbind-service`         | Unbind a service from an application                                     |
| cfds     | `cf delete-service`         | Delete a service you no longer have bound                                |
| cfup     | `cf cups`                   | Create a "user-provided-service"                                         |
| cflg     | `cf logs`                   | Tail the logs of an application (requires <APP_NAME>)                    |
| cfr      | `cf routes`                 | List all the routes in the current Space                                 |
| cfe      | `cf env`                    | Show the environment variables for an application (requires <APP_NAME>)  |
| cfsh     | `cf ssh`                    | Attach to a running container (requires an <APP_NAME> etc.)              |
| cfsc     | `cf scale`                  | Scale an application (requires an <APP_NAME> etc.)                       |
| cfev     | `cf events`                 | Show the application events (requires <APP_NAME>)                        |
| cfdor    | `cf delete-orphaned-routes` | Delete routes that are no longer bound to applications                   |
| cfbpk    | `cf buildpacks`             | List the available buildpacks                                            |
| cfdm     | `cf domains`                | List the domains associates with this Cloud Foundry foundation           |
| cfsp     | `cf spaces`                 | List all the Spaces in the current Org                                   |
| cfap     | `cf app`                    | Show the details of a deployed application (requires <APP_NAME>)         |
| cfh.     | `export CF_HOME=$PWD/.cf`   | Set the current directory as CF_HOME                                     |
| cfh~     | `export CF_HOME=~/.cf`      | Set the user's root directory as CF_HOME                                 |
| cfhu     | `unset CF_HOME`             | Unsets CF_HOME                                                           |
| cfpm     | `cf push -f`                | Push an application using a manifest (requires <MANIFEST_FILE> location) |
| cflr     | `cf logs --recent`          | Show the recent logs (requires <APP_NAME>)                               |
| cfsrt    | `cf start`                  | Start an application (requires <APP_NAME>)                               |
| cfstp    | `cf stop`                   | Stop an application (requires <APP_NAME>)                                |
| cfstg    | `cf restage`                | Restage an application (requires <APP_NAME>)                             |
| cfdel    | `cf delete`                 | Delete an application (requires <APP_NAME>)                              |
| cfsrtall | -                           | Start all apps that are currently in the "Stopped" state                 |
| cfstpall | -                           | Stop all apps that are currently in the "Started" state                  |

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
