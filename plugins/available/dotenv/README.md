# dotenv

Automatically load your project ENV variables from `.env` file when you `cd` into project root directory.

Storing configuration in the environment is one of the tenets of a [twelve-factor app](http://www.12factor.net). Anything that is likely to change between deployment environments–such as resource handles for databases or credentials for external services–should be extracted from the code into environment variables.

## Installation

Just add the plugin to your `.zshrc`:

```sh
plugins=(git man dotenv)
```

## Usage

Create `.env` file inside your project directory and put your local ENV variables there.

For example:
```sh
export AWS_S3_TOKEN=d84a83539134f28f412c652b09f9f98eff96c9a
export SECRET_KEY=7c6c72d959416d5aa368a409362ec6e2ac90d7f
export MONGO_URI=mongodb://127.0.0.1:27017
export PORT=3001
```
`export` is optional. This format works as well:
```sh
AWS_S3_TOKEN=d84a83539134f28f412c652b09f9f98eff96c9a
SECRET_KEY=7c6c72d959416d5aa368a409362ec6e2ac90d7f
MONGO_URI=mongodb://127.0.0.1:27017
PORT=3001
```

**It's strongly recommended to add `.env` file to `.gitignore`**, because usually it contains sensitive information such as your credentials, secret keys, passwords etc. You don't want to commit this file, it supposed to be local only.
