# pj plugin

The `pj` plugin (short for `Project Jump`) allows you to define a list of directories where your projects are located. You can quickly jump to a project directory using `pj project-name` or open it in your preferred editor with `pj open project-name`.

## Usage

1. Enable the `pj` plugin:

   ```zsh
   plugins=(... pj)
   ```

2. Add project to the registry:

   ```zsh
   $ pj add
   ```

> This will add the current directory to the registry, using the directory name as the project name.

3. Jump to project directory:

   ```zsh
   $ pj project-name
   ```
> `pj` has auto-complete support for project names.

4. Open the project in your defined `$EDITOR`:

   ```zsh
   $ pjo project-name
   ```
> Opens the project in your default $EDITOR. You can override the editor using `-e`.

## Commands

#### `pj <project-name>`

`cd` to the project directory with the given name. Note: you can use auto-complete for project names.

For example:
```zsh
$ pj my-project
```

#### `pj add [path] [name]`

Add a project to the registry.
Note: `pja` is an alias of `pj add`.

For example:
```zsh
$ pja
$ # Add the current directory with the name "my-project"
$ pja . my-project
$ # Add the specified directory to the registry with the name "my-project"
$ pja /path/to/project my-project
```

##### `pj open <project-name>`

Open the project with your defined `$EDITOR` or specify an editor with the `-e` flag.
Note: `pjo` is an alias of `pj open`.

For example:
```zsh
$ pjo my-project
$ # open the project path named "my-project" with VSCode
$ pjo -e code my-project
$ # open multiple projects
$ pjo my-project another-project
```

##### `pj ls [pattern]`

List all the projects in the registry.
Note: `pjl` is an alias of `pj ls`.

For example:
```zsh
$ pj ls
$ # list all the projects in the registry that match the pattern 'web-*'
$ pjl 'web-*'
```

##### `pj rm <project-name>`

Remove a project from the registry.

For example:
```zsh
$ pj rm my-project
$ # remove multiple projects from the registry
$ pj rm my-project another-project
```

#### `pj mv <old-name> <new-name>`

Rename a project in the registry.

For example:
```zsh
$ pj mv old-name new-name
```

## Aliases
| Alias | Command |
|-------|---------|
| `pja` | `pj add` |
| `pjo` | `pj open` |
| `pjl` | `pj ls` |

## Contributors
Code by [@ibrahimcetin](https://github.com/ibrahimcetin)

Original idea and code by Jan De Poorter ([@DefV](https://github.com/DefV))
Source: https://gist.github.com/pjaspers/368394#gistcomment-1016