# zfunctions plugin

Use a "zfunctions" directory to store your lazy-loaded zsh function files.

This plugin adds functionality similar to [fish's][fish] "~/.config/fish/functions" directory.

## Description

This plugin will create a new directory for you to store function files, and adds that directory to your zsh 'fpath'.
Any file placed in this directory should contain the script for a single function definition.
These files will then be "lazy-loaded" by zsh into a function of the same name upon their first call.
The lazy-loading functionality is a built-in feature of zsh called [function autoloading][zsh-autoload].

Your zfunctions path by default is '~/.zfunctions'.
However, if you have `$ZDOTDIR` defined, that will be respected and your path will become `$ZDOTDIR/.zfunctions`.
You can optionally override the path by setting a value for `$ZFUNCDIR` in your .zshrc:

```zsh
export ZFUNCDIR=/path/to/my/lazy/zfunctions
```

## Usage

Add zfunctions to the [oh my zsh][omz] plugins array in your zshrc file:

```zsh
plugins=(... zfunctions)
```

## Features

The following functions are defined by this plugin:

| Function  | Arguments     | Description                                   |
|:----------|:--------------|:----------------------------------------------|
| funced    | \<func-name\> | edit the function specified                   |
| funcsave  | \<func-name\> | save a function to your `$ZFUNCDIR` directory |

The following variables are defined by this plugin:

| Variable  | Description                                                 |
|:----------|:------------------------------------------------------------|
| ZFUNCDIR  | The directory to use for storing your lazy-loaded functions |

**Note:**
Additionally, the built-in zsh `functions` command will list all the zsh functions that are defined.
The built-in `function` keyword will allow you to define a new function.

## Example

First, make sure you have enabled the zfunctions plugin and started a new zsh session.
You can verify that zfunctions is enabled by running the following command:

```zsh
$ zsh
$ echo $ZFUNCDIR
~/.zfunctions
```

Now, let's make a quick function to play with called 'foo'.

The 'foo' function should always print "bar" and sometimes also print "baz".

From a zsh prompt, define this function:

```zsh
# 'foo' with comments and custom formatting
foo () {
  # print bar
  echo "bar"
  # and sometimes baz
  if [[ $[${RANDOM}%2] -eq 0 ]]; then
    echo "baz"
  fi
}
```

Next, we can save the function to `$ZFUNCDIR`.

```zsh
funcsave foo
```

Now you should have a function file called "foo" in your `$ZFUNCDIR`.
Let's verify:

```zsh
cat $ZFUNCDIR/foo
```

Notice that the function was reformatted and also that only the function's *internals* are saved to the "foo" file.
The header definition (ie: the "`function foo() {`") is purposely missing.

```zsh
# contents of $ZFUNCDIR/foo
echo "bar"
if [[ $[${RANDOM}%2] -eq 0 ]]
then
    echo "baz"
fi
```

Run `zsh` to start a new zsh session to show how lazy loading works.

```zsh
zsh
```

Now, check out the function definition for `foo` by using the `functions` built-in
(notice the trailing "s" on the word function**s**):

```zsh
functions foo
```

You should see something like this:

```zsh
foo () {
    # undefined
    builtin autoload -XUz ~/.zfunctions
}
```

Now execute the `foo` function once (or do it a few times for fun):

```zsh
# outputs bar, and sometimes baz
foo
foo
foo
```

Now go back and run `functions foo` again and check out the results...
The function definition is now completely filled in from the `foo` file in your `$ZFUNCDIR`.

```zsh
foo () {
    echo "bar"
    if [[ $[${RANDOM}%2] -eq 0 ]]
    then
        echo "baz"
    fi
}
```

You can edit the 'foo' function by using `funced`:

```zsh
# edit the foo function
funced foo

# or, make a new one entirely
funced bar
```

That's it!
Note that you do not need to use `funcsave` or `funced` if you don't prefer to.
Adding files to `$ZFUNCDIR` yourself is also an option.

Here's a great first function to create called "up". Start by typing `funced up` and add this to the file:

```zsh
# $ZFUNCDIR/up
# go up any number of directories
# ex: up 2 is equivalent to cd ../..
if [[ "$#" < 1 ]] ; then
  cd ..
else
  local repeat=$(printf "%${1}s")
  local cdstr=${repeat// /..\/}
  cd $cdstr
fi
```

Have fun building your zsh function library!

[omz]: https://github.com/ohmyzsh/ohmyzsh
[fish]: https://fishshell.com
[zsh-autoload]: http://zsh.sourceforge.net/Doc/Release/Functions.html#Autoloading-Functions
