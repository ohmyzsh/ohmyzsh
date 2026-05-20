# AWS CDK

This plugin adds completion for the [AWS Cloud Development Kit (CDK)](https://aws.amazon.com/cdk/), as well as some aliases for common commands.

To use it, add `cdk` to the plugins array in your zshrc file:

```zsh
plugins=(... cdk)
```

## Aliases

| Alias     | Command        | Description                                               |
| --------- | -------------- | --------------------------------------------------------- |
| `cdkc`    | `cdk context`  | Manage cached context values                              |
| `cdkd`    | `cdk deploy`   | Deploys the stack(s) named STACKS into your AWS account   |
| `cdkdiff` | `cdk diff`     | Compares the specified stack with the deployed stack      |
| `cdki`    | `cdk init`     | Create a new, empty CDK project                           |
| `cdkl`    | `cdk list`     | Lists all stacks in the app                               |
| `cdks`    | `cdk synth`    | Synthesizes and prints the CloudFormation template        |
| `cdkx`    | `cdk destroy`  | Destroy the stack(s) named STACKS                         |
