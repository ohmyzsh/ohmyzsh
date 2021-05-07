# hitchhiker

This plugin adds quotes from The Hitchhiker's Guide to the Galaxy, from Douglas Adams.

To use it, add `hitchhiker` to the plugins array in your zshrc file:

```zsh
plugins=(... hitchhiker)
```

## Aliases

- `hitchhiker`: displays a quote from the book using `fortune`.
- `hitchhiker_cow`: displays a quote from the book using `cowthink`.

```console
$ hitchhiker_cow
 _______________________________________
( "OK, so ten out of ten for style, but )
( minus several million for good        )
( thinking, yeah? "                     )
 ---------------------------------------
        o   ^__^
         o  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```

## Requirements

- `fortune` and `strfile`.
- `cowthink` if using the `hitchhiker_cow` command.

## Credits

Fortune file: Andreas Gohr <andi@splitbrain.org> ([splitbrain.org](https://www.splitbrain.org/projects/fortunes/hg2g))

Spelling and formatting fixes: grok@resist.ca

Original quotes from:

- https://web.archive.org/web/20120106083254/http://tatooine.fortunecity.com/vonnegut/29/hitch/parhaat.html
- https://web.archive.org/web/20011112065737/http://www-personal.umd.umich.edu/~nhughes/dna/faqs/quotedir.html
