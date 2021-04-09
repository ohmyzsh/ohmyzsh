# projen

This plugin provides some aliases for [projen](https://github.com/projen/projen) 

[Awesome List](https://github.com/p6m7g8/awesome-projen)

To use it, make sure [projen](https://github.com/projen/projen) is installed, and add `projen` to the plugins array in your zshrc file.

```zsh
plugins=(... projen)
```

## Plugin commands

* `pj_install` installs the `npm` module globally
* `pj_pr_rebuild` comments on the pr with "@projen build" which which will run the GiitHub Actions workflow


* `pgjn='projen new'`
* `pgjv='projen --version'`

* `pj='npx projen'`

* `pjv='pj --version'`
* `pjb='pj build'`

* `pjd='pj deploy'`
* `pjdd='pj diff'`
* `pjD='pj destroy'`

* `pjU='pj projen:upgrade'`

* `pjR='pj_pr_rebuild'

## Dependencies

As projen is an `npm` and/or `yarn` Node.js TypeScript application, it depends on the relevant packager to install itself
