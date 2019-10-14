# Rake plugin

This plugin adds support for the Ruby build tool
[rake][https://ruby.github.io/rake/] -- Ruby Make.

It allows you to pass arguments when invoking rake tasks without having to
escape the brackets.

i.e. `rake namespace:task['argument']` instead of having to do `rake
namespace:task\['argument'\]`

To use it, add `rake` to the plugins array in your zshrc file:

```zsh plugins=(... rake) ```

## Aliases

| Alias  | Command                         | Description                                    |
|--------|---------------------------------|------------------------------------------------|
| rake   | `noglob rake`                   | allows square brackts for rake task invocation |
| brake  | `noglob bundle exec rake`       | execute the bundled rake gem                   |
| srake  | `noglob sudo rake`              | execute rake as root                           |
| sbrake | `noglob sudo bundle exec rake`  | altogether now ...                             | 


