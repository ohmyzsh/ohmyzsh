# zig

To use it, add `zig` to the plugins array in your zshrc file:

```zsh
plugins=(... zig)
```
# Alias

| Alias                 | Command                                          | Description                                          |
|:----------------------|:-------------------------------------------------|:-----------------------------------------------------|
| `zbuild`              | `zig build`                                      | `Build project from build.zig`                       |
| `zbuildrun`           | `zig build run`                                  | `Build and run project from build.zig`               |
| `zbuildtest`          | `zig build test`                                 | `Build, run and test project from build.zig`         |
| `zbuildexe`           | `zig init-exe`                                   | `Initialize a "zig build" application in the cwd`    |
| `zbuildlib`           | `zig init-lib`                                   | `Initialize a "zig build" library in the cwd`        |
| `zfmt`                | `zig fmt`                                        | `Reformat Zig source into canonical form`            |
| `zlint`               | `zig ast-check`                                  | `Look for simple compile errors in any set of files` |
| `c2zig`               | `zig translate-c`                                | `Convert C code to Zig code`                         |
| `ztest`               | `zig test`                                       | `Create and run a test build`                        |
| `zrun`                | `zig run`                                        | `Create executable and run immediately`              |
| `zversion`            | `zig version`                                    | `Print version number and exit`                      |
| `zfind`               | `find . -name "*.zig"`                           | `Find all zig files`                                 |

# Export

| Export                | Command                                          | Description                                          |
|:----------------------|:-------------------------------------------------|:-----------------------------------------------------|
| `ZCC`                 | `zig cc`                                         | `Use Zig as a drop-in C compiler`                    |
| `ZCXX`                | `zig c++`                                        | `Use Zig as a drop-in C++ compiler`                  |

**Note:** Export the commands without modify the default values (`CC` & `CXX`).
