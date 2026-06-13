
## Introduction

The `cdk plugin` uses the original aws cdk cli tool's  implementation for getting completion suggestions using --get-yargs-completions option 

## Usage
To use it, add `cdk` to the plugins list of your zshrc file:

```
plugins=(... cdk)
```
1. For completion suggestions, start typing the command upto the point from where onwards you would like to get suggestions, after you reach that point hit [SPACEBAR] and then [TAB].
Then completion suggestions will get listed below where you were typing the command at the same time the cursor will  be left at where you last typed so that you can refer below and continue typing the command using the suggestions.

e.g
if you were to type :

    cdk<space>[TAB]
    You will see the following command suggestions with their respective descriptions:

    acknowledge  -- Acknowledge a notice so that it does not show up anymore
    bootstrap    -- Deploys the CDK toolkit stack into an AWS environment
    context      -- Manage cached context values
    deploy       -- Deploys the stack(s) named STACKS into your AWS account
    destroy      -- Destroy the stack(s) named STACKS
    diff         -- Compares the specified stack with the deployed stack or a local template file, and returns with status 1 if any difference is found
    docs         -- Opens the reference documentation in a browser
    doctor       -- Check your set-up for potential problems
    import       -- Import existing resource(s) into the given STACK
    init         -- Create a new, empty CDK project from a template.
    list         -- Lists all stacks in the app
    metadata     -- Returns all metadata associated with this stack
    notices      -- Returns a list of relevant notices
    synthesize   -- Synthesizes and prints the CloudFormation template for this stack
    watch        -- Shortcut for 'deploy --watch' 

2. let's say you picked one command from the suggestion and further wanted some suggestions regarding options, then after typing the command from the suggestion you can further hit [SPACEBAR] and press [TAB] and it will first append '--' to the command you typed so far and then list out the possible options and it's descriptions below where you were typing all the while leaving the cursor right after  where '--' got appended so that you can refer below and pick an option and type.
e.g
after typing:
    cdk init<space>[TAB]
    At this point your current command string which you were typing will get appended with a '--';
    cdk init --
    Further if you press [TAB] again with your command string looking like;
    cdk init --[TAB]
    You will see the following options suggestions with their respective descriptions:

    --app                -- REQUIRED WHEN RUNNING APP: command-line for executing your app or a cloud assembly directory (e.g. "node bin/my-app.js"). Can also be specified in cdk.json or ~/.cdk.json
    --asset-metadata     -- Include "aws:asset:*" CloudFormation metadata for resources that uses assets (enabled by default)
    --build              -- Command-line for a pre-synth build
    --ca-bundle-path     -- Path to CA certificate to use when validating HTTPS requests. Will read from AWS_CA_BUNDLE environment variable if not specified
    --ci                 -- Force CI detection. If CI=true then logs will be sent to stdout instead of stderr
    --context            -- Add contextual string parameter (KEY=VALUE)
    --debug              -- Enable emission of additional debugging information, such as creation stack traces of tokens
    --ec2creds           -- Force trying to fetch EC2 instance credentials. Default: guess EC2 instance status
    --generate-only      -- If true, only generates project files, without executing additional operations such as setting up a git repo, installing dependencies or compiling the project
    --help               -- Show help
    --ignore-errors      -- Ignores synthesis errors, which will likely produce an invalid output
    --json               -- Use JSON output instead of YAML when templates are printed to STDOUT
    --language           -- The language to be used for the new project (default can be configured in ~/.cdk.json)
    --list               -- List the available templates
    --lookups            -- Perform context lookups (synthesis fails if this is disabled and context lookups need to be performed)
    --no-color           -- Removes colors and other style from console output
    --notices            -- Show relevant notices
    --output             -- Emits the synthesized cloud assembly into a directory (default: cdk.out)
    --path-metadata      -- Include "aws:cdk:path" CloudFormation metadata for each resource (enabled by default)
    --plugin             -- Name or path of a node package that extend the CDK features. Can be specified multiple times
    --profile            -- Use the indicated AWS profile as the default environment
    --proxy              -- Use the indicated proxy. Will read from HTTPS_PROXY environment variable if not specified
    --role-arn           -- ARN of Role to use when invoking CloudFormation
    --staging            -- Copy assets to the output directory (use --no-staging to disable the copy of assets which allows local debugging via the SAM CLI to reference the original source files)
    --strict             -- Do not construct stacks with warnings
    --trace              -- Print trace for stack warnings
    --verbose            -- Show debug logs (specify multiple times to increase verbosity)
    --version            -- Show version number
    --version-reporting  -- Include the "AWS::CDK::Metadata" resource in synthesized templates (enabled by default)

Note: You can avoid the appendment of '--' step by typing it yourself in your command string and then pressing [TAB] to save time.

3. The second usage of getting suggestions for options can be repeated in succession indefinitely. 
e.g
after getting the options suggestions for cdk init command from the previous example, let's say you picked --app option:
    cdk init --app
    You can get further suggestions for more options by following the exact same steps for options suggestion as you did in previous example.
    cdk init --app[TAB]
    At this point your current command string which you were typing will get appended with a '--';
    cdk init --app --
    Further if you press [TAB] again with your command string looking like;
    cdk init --app --[TAB]
    You will see the further options suggestions with their respective descriptions:

    --asset-metadata     -- Include "aws:asset:*" CloudFormation metadata for resources that uses assets (enabled by default)
    --build              -- Command-line for a pre-synth build
    --ca-bundle-path     -- Path to CA certificate to use when validating HTTPS requests. Will read from AWS_CA_BUNDLE environment variable if not specified
    --ci                 -- Force CI detection. If CI=true then logs will be sent to stdout instead of stderr
    --context            -- Add contextual string parameter (KEY=VALUE)
    --debug              -- Enable emission of additional debugging information, such as creation stack traces of tokens
    --ec2creds           -- Force trying to fetch EC2 instance credentials. Default: guess EC2 instance status
    --generate-only      -- If true, only generates project files, without executing additional operations such as setting up a git repo, installing dependencies or compiling the project
    --help               -- Show help
    --ignore-errors      -- Ignores synthesis errors, which will likely produce an invalid output
    --json               -- Use JSON output instead of YAML when templates are printed to STDOUT
    --language           -- The language to be used for the new project (default can be configured in ~/.cdk.json)
    --list               -- List the available templates
    --lookups            -- Perform context lookups (synthesis fails if this is disabled and context lookups need to be performed)
    --no-color           -- Removes colors and other style from console output
    --notices            -- Show relevant notices
    --output             -- Emits the synthesized cloud assembly into a directory (default: cdk.out)
    --path-metadata      -- Include "aws:cdk:path" CloudFormation metadata for each resource (enabled by default)
    --plugin             -- Name or path of a node package that extend the CDK features. Can be specified multiple times
    --profile            -- Use the indicated AWS profile as the default environment
    --proxy              -- Use the indicated proxy. Will read from HTTPS_PROXY environment variable if not specified
    --role-arn           -- ARN of Role to use when invoking CloudFormation
    --staging            -- Copy assets to the output directory (use --no-staging to disable the copy of assets which allows local debugging via the SAM CLI to reference the original source files)
    --strict             -- Do not construct stacks with warnings
    --trace              -- Print trace for stack warnings
    --verbose            -- Show debug logs (specify multiple times to increase verbosity)
    --version            -- Show version number
    --version-reporting  -- Include the "AWS::CDK::Metadata" resource in synthesized templates (enabled by default)

## Requirements
    1. Disable any plugin or zsh configuration that interferes with tab completions,

    2.  Clear zcompdump Files: Sometimes, issues with completion are related to cached completion files. 
        You can try clearing your zcompdump files by running the command
            rm -f ~/.zcompdump*
        After deleting these files, you should restart your Zsh shell.

## Caveats

If aws-cdk npm package is installed on the system globally it will work really well, but if it is not installed the completion suggestions will still work but has a bit of a overhead since in such cases it will use npx under the hood to run the command and it can affect the performance depending on whether npx is able to find a local installation of the package in your current working directory or in the parent directories of your current working directory. If npx is able to find it installed locally, it will use it, but if it doesnt find any local installations it will first install the package temporarily in a local temporary directory on your system whose location can vary depending on the operating system and configuration but is typically somewhere under the user's home directory.
The package is installed for the duration of the command execution, and once the command is finished, the temporary installation is removed automatically. This means that you don't have to worry about manually cleaning up the temporary installation. npx is designed to handle this for you.

## References 
 1. Solution discussion - https://github.com/aws/aws-cdk/issues/5199
 2. zsh-completions docs, can come in handy for futher development  - https://github.com/zsh-users/zsh-completions/blob/master/zsh-completions-howto.org#writing-simple-completion-functions-using-_describe

## Contributer
https://github.com/donalshijan