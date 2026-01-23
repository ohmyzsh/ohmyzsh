# Spryker

This plugin provides aliases for the most frequently used [Spryker SDK](https://github.com/spryker-sdk) commands,
as well as code completion for the commands `console` and `boot`.

To use it add spryker to the plugins array in your zshrc file.

```bash
plugins=(... spryker)
```

## Aliases

| Alias     | Command                        | Description                                   |
|-----------|--------------------------------|-----------------------------------------------|
| `spk`     | docker/sdk                     | Runs the Spryker SDK                          |
| `spkc`    | spk console                    | Runs a Spryker console command                |
| `spkb`    | spk boot                       | Bootstrap spryker with a deploy file          |
| `spkt`    | spk testing                    | Starts a testing container                    |
| `spku`    | spk up                         | Builds and runs Spryker applications          |
| `spkup`   | spk up --build --assets --data | Same as up + build, assets and data           |
| `spkcli`  | spk cli                        | Starts a terminal container                   |
| `spkcc`   | spk clean && spk clean-data    | Removes all images, volumes and storage       |
| `spkl`    | spk logs                       | Tails all application exception logs          |
| `spkp`    | spk prune                      | Remove all docker resources. Wipe everything. |
