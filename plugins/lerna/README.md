# lerna

A tool for managing JavaScript projects with multiple packages.

To use it, make sure [lerna](https://github.com/projen/projen) is installed in this project, and add `lerna` to the plugins array in your zshrc file.

```zsh
plugins=(... lerna)
```

## Plugin commands

- lr='npx lerna run --stream --scope $(node -p "require(\"./package.json\").name")'
- lb='lr build'
- lt='lr test'
- lw='lr watch'


## Dependencies

As lerna is an `npm` and/or `yarn` Node.js application, it depends on the relevant packager to install itself.
