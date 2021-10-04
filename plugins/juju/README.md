# juju plugin

This plugin provides useful aliases and functions for [juju](https://juju.is/) (for TAB completion,
refer to the [official repo](https://github.com/juju/juju/blob/develop/etc/bash_completion.d/juju)).

To use this plugin, add `juju` to the plugins array in your zshrc file.

```zsh
plugins=(... juju)
```

## Aliases

Naming convention:

- `!` suffix: `--force --no-wait -y`.
- `ds` suffix: `--destroy-storage`.

### General

| Alias  | Command                                     | Description                                            |
|--------|---------------------------------------------|--------------------------------------------------------|
| `jdl`  | `juju debug-log --ms`                       | Display log, with millisecond resolution               |
| `jdlr` | `juju debug-log --ms --replay`              | Replay entire log                                      |
| `jh`   | `juju help`                                 | Show help on a command or other topic                  |
| `jssl` | `juju juju show-status-log`                 | Output past statuses for the specified entity          |
| `jstj` | `juju status --format=json`                 | Show status in json format (more detailed)             |
| `jst`  | `juju status --relations --storage --color` | Show status, including relations and storage, in color |

### Bootstrap

| Alias | Command                   | Description                               |
|-------|---------------------------|-------------------------------------------|
| `jb`  | `juju bootstrap`          | Initializing a Juju cloud environment     |
| `jbm` | `juju bootstrap microk8s` | Initializing a MicroK8s cloud environment |

### Controller

| Alias    | Command                                                                               | Description                                                       |
|----------|---------------------------------------------------------------------------------------|-------------------------------------------------------------------|
| `jdc`    | `juju destroy-controller --destroy-all-models`                                        | Destroy a controller                                              |
| `jdc!`   | `juju destroy-controller --destroy-all-models --force --no-wait -y`                   | Destroy a controller                                              |
| `jdcds`  | `juju destroy-controller --destroy-all-models --destroy-storage`                      | Destroy a controller and associated storage                       |
| `jdcds!` | `juju destroy-controller --destroy-all-models --destroy-storage --force --no-wait -y` | Destroy a controller and associated storage                       |
| `jkc`    | `juju kill-controller -y -t 0`                                                        | Forcibly terminate all associated resources for a Juju controller |
| `jsw`    | `juju switch`                                                                         | Select or identify the current controller and model               |

### Model

| Alias    | Command                                                     | Description                                           |
|----------|-------------------------------------------------------------|-------------------------------------------------------|
| `jam`    | `juju add-model`                                            | Add a hosted model                                    |
| `jdm`    | `juju destroy-model`                                        | Non-recoverable, complete removal of a model          |
| `jdm!`   | `juju destroy-model --force --no-wait -y`                   | Non-recoverable, complete removal of a model          |
| `jdmds`  | `juju destroy-model --destroy-storage`                      | Non-recoverable, complete removal of a model          |
| `jdmds!` | `juju destroy-model --destroy-storage --force --no-wait -y` | Non-recoverable, complete removal of a model          |
| `jmc`    | `juju model-config`                                         | Display or set configuration values on a model        |
| `jm`     | `juju models`                                               | List models a user can access on a controller         |
| `jshm`   | `juju show-model`                                           | Show information about the current or specified model |
| `jsw`    | `juju switch`                                               | Select or identify the current controller and model   |

### Application / unit

| Alias    | Command                                                       | Description                                                               |
|----------|---------------------------------------------------------------|---------------------------------------------------------------------------|
| `jc`     | `juju config`                                                 | Get, set, or reset configuration for a deployed application               |
| `jde`    | `juju deploy --channel=edge`                                  | Deploy a new application or bundle from the edge channel                  |
| `jd`     | `juju deploy`                                                 | Deploy a new application or bundle                                        |
| `jra`    | `juju run-action`                                             | Queue an action for execution                                             |
| `jraw`   | `juju run-action --wait`                                      | Queue an action for execution and wait for results, with optional timeout |
| `jrm`    | `juju remove-application`                                     | Remove application                                                        |
| `jrm!`   | `juju remove-application --force --no-wait`                   | Remove application forcefully                                             |
| `jrmds`  | `juju remove-application --destroy-storage`                   | Remove application and destroy attached storage                           |
| `jrmds!` | `juju remove-application --destroy-storage --force --no-wait` | Remove application forcefully, destroying attached storage                |
| `jrp`    | `juju refresh --path`                                         | Upgrade charm from local charm file                                       |
| `jsa`    | `juju scale-application`                                      | Set the desired number of application units                               |
| `jsh`    | `juju ssh`                                                    | Initiate an SSH session or execute a command on a Juju target             |
| `jshc`   | `juju ssh --container`                                        | Initiate an SSH session or execute a command on a given container         |
| `jsu`    | `juju show-unit`                                              | Displays information about a unit                                         |

### Storage

| Alias   | Command                       | Description                                     |
|---------|-------------------------------|-------------------------------------------------|
| `jrs`   | `juju remove-storage`         | Remove storage                                  |
| `jrs!`  | `juju remove-storage --force` | Remove storage even if it is currently attached |

### Relation

| Alias     | Command                        | Description                                                       |
|-----------|--------------------------------|-------------------------------------------------------------------|
| `jrel`    | `juju relate`                  | Relate two applications                                           |
| `jrmrel`  | `juju remove-relation`         | Remove an existing relation between two applications.             |
| `jrmrel!` | `juju remove-relation --force` | Remove an existing relation between two applications, forcefully. |

### Cross-model relation (CMR)

| Alias    | Command            | Description                                                    |
|----------|--------------------|----------------------------------------------------------------|
| `jex`    | `juju expose`      | Make an application publicly available over the network        |
| `jof`    | `juju offer`       | Offer application endpoints for use in other models            |
| `jcon`   | `juju consume`     | Add a remote offer to the model                                |
| `jrmsas` | `juju remove-saas` | Remove consumed applications (SAAS) from the model             |
| `junex`  | `juju unexpose`    | Remove public availability over the network for an application |

### Bundle

| Alias | Command              | Description                                                 |
|-------|----------------------|-------------------------------------------------------------|
| `jeb` | `juju export-bundle` | Export the current model configuration as a reusable bundle |

## Functions

- `jaddr <app_name> [unit_num]`: display app or unit IP address.
- `jreld <relation_name> <app_name> <unit_num>`: display app and unit relation data.
- `wjst [interval_secs] [args_for_watch]`: watch juju status, with optional interval
  (default: 5s); you may pass additional arguments to `watch`.
