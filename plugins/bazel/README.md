# Bazel plugin

This plugin adds completion for [bazel](https://bazel.build), an open-source build and
test tool that scalably supports multi-language and multi-platform projects.

To use it, add `bazel` to the plugins array in your zshrc file:

```zsh
plugins=(... bazel)
```

The plugin has a copy of [the completion script from the git repository][1].

[1]: https://github.com/bazelbuild/bazel/blob/master/scripts/zsh_completion/_bazel
