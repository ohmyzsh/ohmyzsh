# mvn plugin

The mvn plugin provides many [useful aliases](#aliases) as well as completion for
the [Apache Maven](https://maven.apache.org/) command (`mvn`).

Enable it by adding `mvn` to the plugins array in your zshrc file:

```zsh
plugins=(... mvn)
```

## Aliases

The plugin aliases mvn to a function that calls `mvnw` (the [Maven Wrapper](https://github.com/takari/maven-wrapper))
if it's found, or the mvn command otherwise.

| Alias                | Command                                         |
|:---------------------|:------------------------------------------------|
| `mvn!`               | `mvn -f <root>/pom.xml`                         |
| `mvnag`              | `mvn archetype:generate`                        |
| `mvnboot`            | `mvn spring-boot:run`                           |
| `mvnqdev`            | `mvn quarkus:dev`                               |
| `mvnc`               | `mvn clean`                                     |
| `mvncd`              | `mvn clean deploy`                              |
| `mvnce`              | `mvn clean eclipse:clean eclipse:eclipse`       |
| `mvnci`              | `mvn clean install`                             |
| `mvncie`             | `mvn clean install eclipse:eclipse`             |
| `mvncini`            | `mvn clean initialize`                          |
| `mvncist`            | `mvn clean install -DskipTests`                 |
| `mvncisto`           | `mvn clean install -DskipTests --offline`       |
| `mvncom`             | `mvn compile`                                   |
| `mvncp`              | `mvn clean package`                             |
| `mvnct`              | `mvn clean test`                                |
| `mvncv`              | `mvn clean verify`                              |
| `mvncvst`            | `mvn clean verify -DskipTests`                  |
| `mvndp`              | `mvn deploy`                                    |
| `mvndocs`            | `mvn dependency:resolve -Dclassifier=javadoc`   |
| `mvndt`              | `mvn dependency:tree`                           |
| `mvne`               | `mvn eclipse:eclipse`                           |
| `mvnfmt`             | `mvn fmt:format`                                |
| `mvnjetty`           | `mvn jetty:run`                                 |
| `mvnp`               | `mvn package`                                   |
| `mvns`               | `mvn site`                                      |
| `mvnsrc`             | `mvn dependency:sources`                        |
| `mvnt`               | `mvn test`                                      |
| `mvntc`              | `mvn tomcat:run`                                |
| `mvntc7`             | `mvn tomcat7:run`                               |
| `mvn-updates`        | `mvn versions:display-dependency-updates`       |

## mvn-color

It's a function that wraps the mvn command to colorize it's output. You can use it in place
of the `mvn` command. For example: instead of `mvn test`, use `mvn-color test`.

Since [Maven 3.5.0](https://maven.apache.org/docs/3.5.0/release-notes.html) the mvn command
has colored output, so this function will be soon removed from the plugin.

### Known bugs

It has a bug where it will swallow mvn prompts for user input, _e.g._ when using
`archetype:generate`. See [#5052](https://github.com/ohmyzsh/ohmyzsh/issues/5052).
