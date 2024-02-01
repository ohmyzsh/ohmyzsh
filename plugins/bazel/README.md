# Bazel plugin

This plugin adds completion and aliases for [bazel](https://bazel.build), an open-source build and test tool that scalably supports multi-language and multi-platform projects.

To use it, add `bazel` to the plugins array in your zshrc file:

```zsh
plugins=(... bazel)
```

The plugin has a copy of [the completion script from the git repository][1].

[1]: https://github.com/bazelbuild/bazel/blob/master/scripts/zsh_completion/_bazel

## Aliases

| Alias   | Command                                | Description                                            |
| ------- | -------------------------------------- | ------------------------------------------------------ |
| bzb      | `bazel build`                          | The `bazel build` command                              |
| bzt      | `bazel test`                           | The `bazel test` command                               |
| bzr      | `bazel run`                            | The `bazel run` command                                |
| bzq      | `bazel query`                          | The `bazel query` command                              |
