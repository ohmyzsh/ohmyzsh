# eecms plugin

This plugin adds auto-completion of console commands for [`eecms`](https://github.com/ExpressionEngine/ExpressionEngine). ExpressionEngine is a flexible, feature-rich, free open-source content management platform.

To use it, add `eecms` to the plugins array of your `.zshrc` file:
```
plugins=(... eecms)
```

It also adds the alias `eecms` which finds the eecms file in the current project
and runs it with php.
