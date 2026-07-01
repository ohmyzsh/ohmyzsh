# AWS CDK Plugin

This plugin provides aliases and autocompletion for the
[AWS Cloud Development Kit (CDK)](https://aws.amazon.com/cdk/) CLI.

## Requirements

- [AWS CDK CLI](https://docs.aws.amazon.com/cdk/v2/guide/getting_started.html) installed (`npm install -g aws-cdk`)

## Usage

Add `cdk` to the plugins array in your `.zshrc`:

```zsh
plugins=(... cdk)
```

## Aliases

| Alias        | Command           | Description                        |
| ------------ | ----------------- | ---------------------------------- |
| `cdkl`       | `cdk list`        | List all stacks in the app         |
| `cdksynth`   | `cdk synth`       | Synthesize CloudFormation template |
| `cdkdiff`    | `cdk diff`        | Compare deployed vs local stack    |
| `cdkdeploy`  | `cdk deploy`      | Deploy stack to AWS                |
| `cdkdestroy` | `cdk destroy`     | Destroy deployed stack             |
| `cdkboot`    | `cdk bootstrap`   | Bootstrap CDK environment          |
| `cdkdoc`     | `cdk docs`        | Open CDK documentation             |
| `cdkinit`    | `cdk init`        | Initialize a new CDK project       |
| `cdkwatch`   | `cdk watch`       | Watch for changes and auto-deploy  |
| `cdkctx`     | `cdk context`     | Manage cached context values       |
| `cdkack`     | `cdk acknowledge` | Acknowledge a notice               |
| `cdkver`     | `cdk --version`   | Print CDK version                  |