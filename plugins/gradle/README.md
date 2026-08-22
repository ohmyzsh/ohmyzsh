# Gradle plugin

This plugin adds completions and aliases for [Gradle](https://gradle.org/).

To use it, add `gradle` to the plugins array in your zshrc file:

```zsh
plugins=(... gradle)
```

## Usage

This plugin creates a function called `gradle-or-gradlew`, which is aliased
to `gradle` and `gradlew`. This function is is used to determine whether the
current project directory has a `gradlew` wrapper file. If this file is present
it will be used, otherwise the `gradle` binary from the system environment is
used instead. Gradle tasks can be executed directly without regard for whether
it is the environment `gradle` or the `gradlew` wrapper being invoked. It also
supports being called from any directory inside the root directory of a Gradle
project.

Examples:

```zsh
# Enter project directory
cd /my/gradle/project
# Will call `gradlew` if present or `gradle` if not
gradle test
# Enter a sub-directory of the project directory
cd my/sub/directory
# Will call `gradlew` from `/my/gradle/project` if present or `gradle` if not
gradlew build
```

## Completion

This plugin uses [the completion from the Gradle project](https://github.com/gradle/gradle-completion),
which is distributed under the MIT license.
