# NestJS Plugin for Oh My Zsh

This plugin provides aliases for common [NestJS CLI](https://docs.nestjs.com/cli/overview) commands.

## Requirements

- [NestJS CLI](https://docs.nestjs.com/cli/overview#installation) installed globally:
  `npm install -g @nestjs/cli`

## Aliases

| Alias   | Command                      | Description                                 |
| :------ | :--------------------------- | :------------------------------------------ |
| `nnew`  | `nest new`                   | Create a new NestJS project                 |
| `nb`    | `nest build`                 | Build the NestJS application                |
| `ns`    | `nest start`                 | Start the application                       |
| `nsw`   | `nest start --watch`         | Start the application in watch mode         |
| `nsd`   | `nest start --dev`           | Start the application in dev mode           |
| `nsdbg` | `nest start --debug --watch` | Start the application in debug & watch mode |
| `ng`    | `nest generate`              | Generate a NestJS element                   |
| `ngm`   | `nest generate module`       | Generate a module                           |
| `ngc`   | `nest generate controller`   | Generate a controller                       |
| `ngs`   | `nest generate service`      | Generate a service                          |
| `ngg`   | `nest generate guard`        | Generate a guard                            |
| `ngp`   | `nest generate pipe`         | Generate a pipe                             |
| `ngf`   | `nest generate filter`       | Generate a filter                           |
| `ngr`   | `nest generate resolver`     | Generate a GraphQL resolver                 |
| `ngcl`  | `nest generate class`        | Generate a class                            |
| `ngi`   | `nest generate interface`    | Generate an interface                       |
| `ngit`  | `nest generate interceptor`  | Generate an interceptor                     |
| `ngmi`  | `nest generate middleware`   | Generate a middleware                       |
| `ngd`   | `nest generate decorator`    | Generate a custom decorator                 |
| `ngres` | `nest generate resource`     | Generate a CRUD resource                    |
| `nglib` | `nest generate library`      | Generate a new library                      |
| `ngsub` | `nest generate sub-app`      | Generate a new sub-application (monorepo)   |
| `na`    | `nest add`                   | Add a library to the project                |
| `ni`    | `nest info`                  | Display NestJS project information          |
| `nu`    | `nest update`                | Update NestJS dependencies                  |

## Usage

1.  Clone this repository into your Oh My Zsh plugins directory (usually `~/.oh-my-zsh/custom/plugins`):
    ```sh
    git clone https://github.com/ohmyzsh/ohmyzsh.git # Or your fork
    # Navigate to the plugins directory within the main repo if developing locally
    # cp -r path/to/your/nestjs/plugin ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/nestjs
    ```
    _(Adjust the clone/copy command based on whether you are contributing to the main repo or using a local
    copy)_
2.  Add `nestjs` to the `plugins` array in your `~/.zshrc` file:
    ```zsh
    plugins=(... nestjs)
    ```
3.  Restart your terminal or source your `~/.zshrc` file: `source ~/.zshrc`
