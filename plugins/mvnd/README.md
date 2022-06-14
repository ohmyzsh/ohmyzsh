# mvnd plugin

The mvnd plugin provides many [useful aliases](#aliases) as well as completion for
the [Apache Maven Daemon](https://github.com/apache/maven-mvnd) command (`mvnd`).

Enable it by adding `mvnd` to the plugins array in your zshrc file:

```zsh
plugins=(... mvnd)
```

## Aliases

| Alias                 | Command                                          |
|:----------------------|:-------------------------------------------------|
| `mvnd!`               | `mvnd -f <root>/pom.xml`                         |
| `mvndag`              | `mvnd archetype:generate`                        |
| `mvndboot`            | `mvnd spring-boot:run`                           |
| `mvndqdev`            | `mvnd quarkus:dev`                               |
| `mvndc`               | `mvnd clean`                                     |
| `mvndcd`              | `mvnd clean deploy`                              |
| `mvndce`              | `mvnd clean eclipse:clean eclipse:eclipse`       |
| `mvndci`              | `mvnd clean install`                             |
| `mvndcie`             | `mvnd clean install eclipse:eclipse`             |
| `mvndcini`            | `mvnd clean initialize`                          |
| `mvndcist`            | `mvnd clean install -DskipTests`                 |
| `mvndcisto`           | `mvnd clean install -DskipTests --offline`       |
| `mvndcom`             | `mvnd compile`                                   |
| `mvndcp`              | `mvnd clean package`                             |
| `mvndct`              | `mvnd clean test`                                |
| `mvndcv`              | `mvnd clean verify`                              |
| `mvndcvst`            | `mvnd clean verify -DskipTests`                  |
| `mvndd`               | `mvnd deploy`                                    |
| `mvnddocs`            | `mvnd dependency:resolve -Dclassifier=javadoc`   |
| `mvnddt`              | `mvnd dependency:tree`                           |
| `mvnde`               | `mvnd eclipse:eclipse`                           |
| `mvndfmt`             | `mvnd fmt:format`                                |
| `mvndjetty`           | `mvnd jetty:run`                                 |
| `mvndp`               | `mvnd package`                                   |
| `mvnds`               | `mvnd site`                                      |
| `mvndsrc`             | `mvnd dependency:sources`                        |
| `mvndt`               | `mvnd test`                                      |
| `mvndtc`              | `mvnd tomcat:run`                                |
| `mvndtc7`             | `mvnd tomcat7:run`                               |
| `mvnd-updates`        | `mvnd versions:display-dependency-updates`       |

## mvnd-color

It's a function that wraps the mvnd command to colorize it's output. You can use it in place
of the `mvnd` command. For example: instead of `mvnd test`, use `mvnd-color test`.

Since [Maven 3.5.0](https://maven.apache.org/docs/3.5.0/release-notes.html) the mvn command
has colored output, so this function will be soon removed from the plugin.
