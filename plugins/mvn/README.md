## Introduction

The [mvn plugin](https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins/mvn) provides many
[useful aliases](#aliases) as well as completion for the `mvn` command.

Enable it by adding `mvn` to the plugins array in your zshrc file:
```zsh
plugins=(... mvn)
```

## Aliases

| Alias                | Command                                         |
|:---------------------|:------------------------------------------------|
| `mvncie`             | `mvn clean install eclipse:eclipse`             |
| `mvnci`              | `mvn clean install`                             |
| `mvncist`            | `mvn clean install -DskipTests`                 |
| `mvncisto`           | `mvn clean install -DskipTests --offline`       |
| `mvne`               | `mvn eclipse:eclipse`                           |
| `mvncv`              | `mvn clean verify`                              |
| `mvnd`               | `mvn deploy`                                    |
| `mvnp`               | `mvn package`                                   |
| `mvnc`               | `mvn clean`                                     |
| `mvncom`             | `mvn compile`                                   |
| `mvnct`              | `mvn clean test`                                |
| `mvnt`               | `mvn test`                                      |
| `mvnag`              | `mvn archetype:generate`                        |
| `mvn-updates`        | `mvn versions:display-dependency-updates`       |
| `mvntc7`             | `mvn tomcat7:run`                               |
| `mvnjetty`           | `mvn jetty:run`                                 |
| `mvndt`              | `mvn dependency:tree`                           |
| `mvns`               | `mvn site`                                      |
| `mvnsrc`             | `mvn dependency:sources`                        |
| `mvndocs`            | `mvn dependency:resolve -Dclassifier=javadoc`   |
