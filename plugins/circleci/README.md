# CircleCi Plugin

This plugin provides easy to use cli commands to query circle ci job statuses

To use it, add `circleci` to the plugins array in your zshrc file:

```zsh
plugins=(... circleci)
```

## Prerequisites
You need to have the `CIRCLECI_API_TOKEN` and `CIRCLECI_ORG_SLUG` as environment
variables before calling the `circleci_status` function <br>
You can learn how to add a circleci api token [here](https://circleci.com/docs/managing-api-tokens/) <br>
The org slug takes the format of `{vcs}/{org_name}`

## Usage
```shell
> circleci_status
```
The above command would list down all the jobs (with their run status) on the
repository and branch that you are currently on <br>
You can also use the `cis` alias to run the above function
