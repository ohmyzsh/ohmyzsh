## Coffeescript Plugin

This plugin provides aliases for quickly compiling and previewing your
coffeescript code.

When writing Coffeescript it's very common to want to preview the output of a
certain snippet of code, either because you want to test the output or because
you'd like to execute it in a browser console which doesn't accept Coffeescript.

Preview the compiled result of your coffeescript with `cf "code"` as per the
following:

```zsh
$ cf 'if a then b else c'
if (a) {
  b;
} else {
  c;
}
```

Also provides the following aliases:

* **cfc:** Copies the compiled JS to your clipboard. Very useful when you want
           to run the code in a JS console.

* **cfp:** Compiles from your currently copied clipboard. Useful when you want 
           to compile large/multi-line snippets

* **cfpc:** Paste coffeescript from clipboard, compile to JS, then copy the
            the result back to clipboard.
