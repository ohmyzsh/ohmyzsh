# pylint 

This plugin adds code analysis for python through [Pylint](https://www.pylint.org/).

To use it, add `pylint` to the plugins array in your zshrc file:

```zsh
plugins=(... pylint)
```

## Aliases

| Alias        | Command              | Description                                                                                                              |
| -------------| -------------------- | -------------------------------------------------------------------------------------------------------------------------|
| pylint-quick | `pylint --reports=n` | Displays a set of reports each one focusing on a particular aspect of the project, default set `no` for multiple reports |                                         |
