# Golang plugin

This plugin adds completion for the [Go Programming Language](https://golang.org/),
as well as some aliases for common Golang commands.

To use it, add `golang` to the plugins array in your zshrc file:

```zsh
plugins=(... golang)
```

## Aliases

| Alias  | Command           | Description                                                   |
| ------ | ----------------- | ------------------------------------------------------------- |
| gob    | `go build`        | Build your code                                               |
| goc    | `go clean`        | Removes object files from package source directories          |
| god    | `go doc`          | Prints documentation comments                                 |
| goe    | `go env`          | Prints Go environment information                             |
| gof    | `go fmt`          | Gofmt formats (aligns and indents) Go programs.               |
| gofa   | `go fmt ./...`    | Run go fmt for all packages in current directory, recursively |
| gofx   | `go fix`          | Update packages to use a new API                              |
| gog    | `go get`          | Downloads packages and then installs them to $GOPATH          |
| goga   | `go get ./...`    | Installs all dependencies in current directory, recursively   |
| goi    | `go install`      | Compiles and installs packages to $GOPATH                     |
| gol    | `go list`         | Lists Go packages                                             |
| gom    | `go mod`          | Access to operations on modules                               |
| gomt   | `go mod tidy`     | Tidies up the go.mod file                                     |
| gopa   | `cd $GOPATH`      | Takes you to `$GOPATH`                                        |
| gopb   | `cd $GOPATH/bin`  | Takes you to `$GOPATH/bin`                                    |
| gops   | `cd $GOPATH/src`  | Takes you to `$GOPATH/src`                                    |
| gor    | `go run`          | Compiles and runs your code                                   |
| got    | `go test`         | Runs tests                                                    |
| gota   | `go test ./...`   | Runs tests in all subdirectories                              |
| goto   | `go tool`         | Prints all the available tools                                |
| gotoc  | `go tool compile` | Generates object file                                         |
| gotod  | `go tool dist`    | Utility to bootstrap, build and test go runtime               |
| gotofx | `go tool fix`     | Fixes an application to use newer features                    |
| gov    | `go vet`          | Vet examines Go source code and reports suspicious constructs |
| gove   | `go version`      | Prints Go version                                             |
| gow    | `go work`         | Work provides access to operations on workspaces              |
