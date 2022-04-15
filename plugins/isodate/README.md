# Isodate plugin

**Maintainer:** [@Frani](https://github.com/frani)

This plugin adds completion for the [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601),
as well as some aliases for common Date commands.

To use it, add `isodate` to the plugins array in your zshrc file:

```zsh
plugins=(... isodate)
```

## Aliases

| Alias         | Command                              | Description                                                                |
|---------------|--------------------------------------|----------------------------------------------------------------------------|
| isodate       | `date +%Y-%m-%dT%H:%M:%S%z`          | Display the current date with UTC offset and ISO 8601-2 extended format    |
| isodate_utc   | `date -u +%Y-%m-%dT%H:%M:%SZ`        | Display the current date in UTC and ISO 8601-2 extended format             |
| isodate_basic | `date -u +%Y%m%dT%H%M%SZ`            | Display the current date in UTC and ISO 8601 basic format                  |
| unixstamp     | `date +%s`                           | Display the current date as a Unix timestamp (seconds since the Unix epoch)|
| date_locale   | `date +"%c"`                         | Display the current date using the default locale's format                 |
