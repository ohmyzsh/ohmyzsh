# AWS CDK plugin

This plugin adds completion for the [AWS Cloud Development Kit (CDK)](https://aws.amazon.com/cdk/) CLI.

To use it, add `cdk` to the plugins array in your zshrc file:

```zsh
plugins=(... cdk)
```

If the `cdk` command is installed globally, the plugin uses it directly. If `cdk` is not found but `npx` is
available, the plugin defines a `cdk` wrapper that runs `npx -- cdk`, which supports project-local CDK
installations.

This plugin does not add any aliases.
