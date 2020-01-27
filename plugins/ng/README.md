## NG Plugin

This [ng plugin](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/ng)
 adds completion support for Angular's CLI (named ng).

Ng is hosted on [ng home](https://github.com/catull/angular-cli)

It is used to generate Angular 2 app "stubs", build those apps, configure them,
test them, lint them etc.

Ahem, "stubs" is not what Angular engineers refer to the items ng can generate
for you.

"Stubs" can be any one of:
- class
- component
- directive
- enum
- module
- pipe
- route
- service

At the moment, `ng completion` creates a very rough completion for Zsh and
Bash.

It is missing most of the options and a few arguments.
In future, this plugin may be shortened to simply being

```zsh
eval `ng completion`
```

There is hope this materialises in the 21st century.

### CONTRIBUTOR
 - Carlo Dapor ([catull](https://github.com/catull))
