# Rake plugin

This plugin adds support for [rake](https://ruby.github.io/rake/), the Ruby
build tool or Ruby Make.

To use it, add `rake` to the plugins array in your zshrc file:

```zsh
plugins=(... rake)
```

## Aliases

The plugin aliases the rake command so you can pass arguments when invoking rake tasks
without having to escape the brackets, i.e., you can run
```
rake namespace:task['argument']
```
instead of having to do
```
rake namespace:task\['argument'\]
```

| Alias  | Command                        | Description                                   |
|--------|--------------------------------|-----------------------------------------------|
| rake   | `noglob rake`                  | Allows unescaped square brackets              |
| brake  | `noglob bundle exec rake`      | Same as above but call rake using bundler     |
| srake  | `noglob sudo rake`             | Same as rake but using sudo                   |
| sbrake | `noglob sudo bundle exec rake` | Same as above but using both sudo and bundler |

## Jim Weirich

The plugin also aliases `rake` to [`jimweirich`](https://github.com/jimweirich), author of Rake
and big time contributor to the Ruby open source community. He passed away in 2014:

> Thank you Jim for everything you contributed to the Ruby and open source community 
> over the years. We will miss you dearly. — [**@robbyrussell**](https://github.com/robbyrussell/oh-my-zsh/commit/598a9c6f990756386517d66b6bcf77e53791e905)
