## Introduction

The [meteor plugin](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/meteor) provides many
[useful aliases](#aliases) as well as completion for the `meteor` command.

Enable it by adding `meteor` to the plugins array in your zshrc file:
```zsh
plugins=(... meteor)
```

## Aliases

| Alias   | Command                    | Description                                                      |
|---------|----------------------------|------------------------------------------------------------------|
| `ma`    | `meteor add`               | Add a package to this project                                    |
| `map`   | `meteor add-platform`      | Add a platform to this project                                   |
| `mad`   | `meteor admin`             | Administrative commands                                          |
| `mau`   | `meteor authorized`        | View or change authorized users and organizations for a site     |
| `mb`    | `meteor build`             | Build this project for all platforms                             |
| `mcl`   | `meteor claim`             | Claim a site deployed with an old Meteor version                 |
| `mca`   | `meteor configure-android` | Run the Android configuration tool from Meteor's ADK environment |
| `mc`    | `meteor create`            | Create a new project                                             |
| `mdb`   | `meteor debug`             | Run the project, but suspend the server process for debugging    |
| `mde`   | `meteor deploy`            | Deploy this project to Meteor                                    |
| `mis`   | `meteor install-sdk`       | Installs SDKs for a platform                                     |
| `ml`    | `meteor list`              | List the packages explicitly used by your project                |
| `mlp`   | `meteor list-platforms`    | List the platforms added to your project                         |
| `mls`   | `meteor list-sites`        | List sites for which you are authorized                          |
| `mli`   | `meteor login`             | Log in to your Meteor developer account                          |
| `mlo`   | `meteor logout`            | Log out of your Meteor developer account                         |
| `mlog`  | `meteor logs`              | Show logs for specified site                                     |
| `mm`    | `meteor mongo`             | Connect to the Mongo database for the specified site             |
| `mp`    | `meteor publish`           | Publish a new version of a package to the package server         |
| `mpa`   | `meteor publish-for-arch`  | Builds an already-published package for a new platform           |
| `mpr`   | `meteor publish-release`   | Publish a new meteor release to the package server               |
| `mr`    | `meteor remove`            | Remove a package from this project                               |
| `mrp`   | `meteor remove-platform`   | Remove a platform from this project                              |
| `mre`   | `meteor reset`             | Reset the project state. Erases the local database               |
| `m`     | `meteor run`               | **[default]** Run this project in local development mode         |
| `ms`    | `meteor search`            | Search through the package server database                       |
| `msh`   | `meteor shell`             | Launch a Node REPL for interactively evaluating server-side code |
| `msw`   | `meteor show`              | Show detailed information about a release or package             |
| `mt`    | `meteor test-packages`     | Test one or more packages                                        |
| `mu`    | `meteor update`            | Upgrade this project's dependencies to their latest versions     |
| `mw`    | `meteor whoami`            | Prints the username of your Meteor developer account             |
