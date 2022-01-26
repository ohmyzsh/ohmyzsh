# check-spelling/check-spelling configuration

File | Purpose | Format | Info
-|-|-|-
[dictionary.txt](dictionary.txt) | Replacement dictionary (creating this file will override the default dictionary) | one word per line | [dictionary](https://github.com/check-spelling/check-spelling/wiki/Configuration#dictionary)
[allow.txt](allow.txt) | Add words to the dictionary | one word per line (only letters and `'`s allowed) | [allow](https://github.com/check-spelling/check-spelling/wiki/Configuration#allow)
[reject.txt](reject.txt) | Remove words from the dictionary (after allow) | grep pattern matching whole dictionary words | [reject](https://github.com/check-spelling/check-spelling/wiki/Configuration-Examples%3A-reject)
[excludes.txt](excludes.txt) | Files to ignore entirely | perl regular expression | [excludes](https://github.com/check-spelling/check-spelling/wiki/Configuration-Examples%3A-excludes)
[only.txt](only.txt) | Only check matching files (applied after excludes) | perl regular expression | [only](https://github.com/check-spelling/check-spelling/wiki/Configuration-Examples%3A-only)
[patterns.txt](patterns.txt) | Patterns to ignore from checked lines | perl regular expression (order matters, first match wins) | [patterns](https://github.com/check-spelling/check-spelling/wiki/Configuration-Examples%3A-patterns)
[expect.txt](expect.txt) | Expected words that aren't in the dictionary | one word per line (sorted, alphabetically) | [expect](https://github.com/check-spelling/check-spelling/wiki/Configuration#expect)
[advice.md](advice.md) | Supplement for GitHub comment when unrecognized words are found | GitHub Markdown | [advice](https://github.com/check-spelling/check-spelling/wiki/Configuration-Examples%3A-advice)

Note: you can replace any of these files with a directory by the same name (minus the suffix)
and then include multiple files inside that directory (with that suffix) to merge multiple files together.
