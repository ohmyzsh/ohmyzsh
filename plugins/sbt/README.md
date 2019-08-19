# sbt plugin

This plugin adds completion for the [sbt, the interactive build tool](https://scala-sbt.org/),
as well as some aliases for common sbt commands.

To use it, add `sbt` to the plugins array in your zshrc file:

```zsh
plugins=(... sbt)
```

## Aliases

| Alias | Command               | Description                                                  |
|-------|-----------------------|--------------------------------------------------------------|
| sbc   | `sbt compile`         | Compiles the main sources                                    |
| sbcln | `sbt clean`           | Deletes all generated files                                  |
| sbcc  | `sbt clean compile`   | Deletes generated files, compiles the main sources           |
| sbco  | `sbt console`         | Starts Scala with the compiled sources and all dependencies  |
| sbcq  | `sbt console-quick`   | Starts Scala with all dependencies                           |
| sbcp  | `sbt console-project` | Starts Scala with sbt and the build definitions              |
| sbd   | `sbt doc`             | Generates API documentation for Scala source files           |
| sbdc  | `sbt dist:clean`      | Deletes the distribution packages                            |
| sbdi  | `sbt dist`            | Creates the distribution packages                            |
| sbgi  | `sbt gen-idea`        | Create Idea project files                                    |
| sbp   | `sbt publish`         | Publishes artifacts to the repository                        |
| sbpl  | `sbt publish-local`   | Publishes artifacts to the local Ivy repository              |
| sbr   | `sbt run`             | Runs the main class for the project                          |
| sbrm  | `sbt run-main`        | Runs the specified main class for the project                |
| sbu   | `sbt update`          | Resolves and retrieves external dependencies                 |
| sbx   | `sbt test`            | Compiles and runs all tests                                  |
| sba   | `sbt assembly`        | Create a fat JAR with all dependencies                       |
