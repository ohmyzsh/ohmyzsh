## Gradle Plugin

This plugin adds completions and aliases for [Gradle](https://gradle.org/).

To use it, add `gradle` to the plugins array in your zshrc file:

```zsh
plugins=(... gradle)
```

## Usage

This plugin creates an alias `gradle` which is used to determine whether the current working directory has a gradlew file. If gradlew is present it will be used otherwise `gradle` is used directly. Gradle tasks can be executed directly without regard for whether it is `gradle` or `gradlew`

Examples:
```zsh
gradle test
gradle build
```

## Completion

The completion provided for this plugin caches the parsed tasks into a file named `.gradletasknamecache` in the current working directory, so you might want to add that to your `.gitignore` file so that it's not accidentally committed.
