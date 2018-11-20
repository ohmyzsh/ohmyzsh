Just command runner oh-my-zsh plugin
======================================

Just is a command runner and handy way to save and run project-specific commands.
Commands are stored in a file called justfile or Justfile with syntax inspired by make:

```
# build the project
build:
    cc *.c -o main

# test everything
test-all: build
    ./test --all

# run a specific test
test TEST: build
    ./test --test {{TEST}}
```

With oh-my-zsh plugin support, all recipes could be completed by press tab like following:

```
just<tab>
command
build     --  build the project
test      --  run a specific test
test-all  --  test everything
```

# References

* Just Home: https://github.com/casey/just