# sbt plugin

This plugin adds completion for the [sbt, the interactive build tool](https://scala-sbt.org/),
as well as some aliases for common sbt commands.

To use it, add `sbt` to the plugins array in your zshrc file:

```zsh
plugins=(... sbt)
```

## Aliases

| Alias | Command               | Description                                                                                       |
|-------|-----------------------|---------------------------------------------------------------------------------------------------|
| sbc   | `sbt compile`         | Compiles the main sources                                                                         |
| sbcln | `sbt clean`           | Deletes all generated files                                                                       |
| sbcc  | `sbt clean compile`   | Deletes all generated files and then compiles the main sources                                    |
| sbco  | `sbt console`         | Starts the Scala interpreter with a classpath including the compiled sources and all dependencies |
| sbcq  | `sbt console-quick`   | Starts the Scala interpreter with a classpath including all dependencies                          |
| sbcp  | `sbt console-project` | Starts the Scala interpreter with sbt and the build definition on the classpath                   |
| sbd   | `sbt doc`             | Generates API documentation for Scala source files                                                |
| sbdc  | `sbt dist:clean`      | Deletes the distribution packages                                                                 |
| sbdi  | `sbt dist`            | Creates the distribution packages                                                                 |
| sbgi  | `sbt gen-idea`        | Create Idea project files                                                                         |
| sbp   | `sbt publish`         | Publishes artifacts (such as jars) to the repository                                              |
| sbpl  | `sbt publish-local`   | Publishes artifacts (such as jars) to the local Ivy repository                                    |
| sbr   | `sbt run`             | Runs the main class for the project                                                               |
| sbrm  | `sbt run-main`        | Runs the specified main class for the project                                                     |
| sbu   | `sbt update`          | Resolves and retrieves external dependencies                                                      |
| sbt   | `sbt test`            | Compiles and runs all tests                                                                       |
| sba   | `sbt assembly`        | Create a fat JAR of your project with all of its dependencies                                     |
