# Code Climate CLI

codeclimate is a command line interface for the Code Climate analysis platform. It allows you to run Code Climate engines on your local machine inside of Docker containers.

To use it, add `codeclimate` to the plugins array in your zshrc file:

```zsh
plugins=(... codeclimate)
```

## Commands

| Command                                                   |            Description                               |
|-----------------------------------------------------------|----------------------------------------------------- |
| `analyze [-f format] [-e engine[:channel]] [--dev] [path]`|  Analyze all relevant files in the current           |  |                                                           |  working directory. All engines that are enabled in  | 
|                                                           |  your .codeclimate.yml file will run, one after      |
|                                                           |  another. The -f (or format) argument allows you to  | 
|                                                           |  set the output format of the analysis (using json,  |
|                                                           |  text, or html). The --dev flag lets you run engines | 
|                                                           |  not known to the CLI, for example if you're an      |
|                                                           |  engine author developing your own, unreleased       |
|                                                           |  image.                                              |  |                                                           |  You can optionally provide a specific path to       |
|                                                           |  analyze. If not provided, the CLI will analyze      |  
|                                                           |  your entire repository, except for your configured  |  |                                                           |  exclude_paths. When you do provide an explicit path | 
|                                                           |  to analyze, your configured exclude_paths are       |
|                                                           |  ignored, and normally excluded files will be        |
|                                                           |  analyzed.                                           |
|-----------------------------------------------------------|------------------------------------------------------| 
| `console`                                                 |  start an interactive session providing access to the|  |                                                           |  classes within the CLI. Useful for engine developers|  |                                                           |  and maintainers.                                    |
|------------------------------------------------------------------------------------------------------------------|
| `engines:install`                                         |  Compares the list of engines in your                |
|                                                           |  .codeclimate.yml file to those that are currently   |  |                                                           |  installed, then installs any missing engines.       |  |------------------------------------------------------------------------------------------------------------------|  | `engines:list`                                            | Lists all available engines in the [Code Climate     |
|                                                           | Docker Hub](https://hub.docker.com/u/codeclimate/).  | 
|-----------------------------------------------------------|------------------------------------------------------|
| `help`                                                    | Displays a list of commands that can be passed to the|  |                                                           | Code Climate CLI.                                    |
|-----------------------------------------------------------|------------------------------------------------------|
| `validate-config`                                         | Validates the .codeclimate.yml file in the current   |  |                                                           | working directory.                                   |
|-----------------------------------------------------------|------------------------------------------------------|
| `version`                                                 | Displays the current version of the Code Climate CLI.|

## Environment Variables

* To run `codeclimate` in debug mode:

  ```
  CODECLIMATE_DEBUG=1 codeclimate analyze
  ```

  Prints additional information about the analysis steps, including any stderr
  produced by engines.

* To increase the amount of time each engine container may run (default 15 min):

  ```
  # 30 minutes
  CONTAINER_TIMEOUT_SECONDS=1800 codeclimate analyze
  ```

* You can also configure the default alotted memory with which each engine runs
  (default is 1,024,000,000 bytes):

  ```
  # 2,000,000,000 bytes
  ENGINE_MEMORY_LIMIT_BYTES=2000000000 codeclimate analyze
  ```