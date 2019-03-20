# Mix plugin

This plugin adds completions for the [Elixir's Mix build tool](https://hexdocs.pm/mix/Mix.html).

To use it, add `mix` to the plugins array in your zshrc file:

```zsh
plugins=(... mix)
```
## Supported Task Types

| Task Type               | Documentation                                            |
|-------------------------|----------------------------------------------------------|
| Elixir                  | [Elixir Lang](https://elixir-lang.org/)                  |
| Phoenix v1.2.1 and below| [Phoenix](https://hexdocs.pm/phoenix/1.2.1/Phoenix.html) |
| Phoenix v1.3.0 and above| [Phoenix](https://hexdocs.pm/phoenix/Phoenix.html)       |
| Ecto                    | [Ecto](https://hexdocs.pm/ecto/Ecto.html)                |
| Hex                     | [Hex](https://hex.pm/)                                   |
| Nerves                  | [Nerves](https://nerves-project.org/)                    |
