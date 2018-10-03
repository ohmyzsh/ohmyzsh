## Gradle Plugin

This plugin adds completions and aliases for [Gradle](https://gradle.org/).

To use it, add `gradle` to the plugins array in your zshrc file:

```zsh
plugins=(... gradle)
```

## Usage
This plugin creates an alias `gradle` which is used to determine whether the current working directory has a gradlew file. If gradlew is present it will be used otherwise `gradle` is used directly. Gradle tasks can be executed directly without regard for whether it is `gradle` or `gradlew`

### Example: 
```zsh
gradle test
gradle build
```

## Aliases
| Alias  | Description |
|--------|-------------|
| gradle | Alias for the `gradle-or-gradlew` plugin function which determines whether to use `gradle` or `gradlew` and executes |

## Functions
| Function  | Description |
|--------|-------------|
| gradle-or-gradlew | If `gradlew` is present it is executed; otherwise `gradle` is called. Arguments and subcommands are passed along. |