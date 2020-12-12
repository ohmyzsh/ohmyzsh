# genpass

This plugin provides three unique password generators for ZSH. Each generator
has at least a 128-bit security margin and generates passwords from the
cryptographically secure `/dev/urandom`. Each generator can also take an
optional numeric argument to generate multiple passwords.

Requirements:

* `grep(1)`
* GNU coreutils (or appropriate for your system)
* Word list providing `/usr/share/dict/words`

To use it, add `genpass` to the plugins array in your zshrc file:

    plugins=(... genpass)

## genpass-apple

Generates a pronounceable pseudoword passphrase of the "cvccvc" consonant/vowel
syntax, inspired by [Apple's iCloud Keychain password generator][1]. Each
pseudoword has exactly 1 digit placed at the edge of a "word" and exactly 1
capital letter to satisfy most password security requirements.

    % genpass-apple
    gelcyv-foqtam-fotqoh-viMleb-lexduv-6ixfuk

    % genpass-apple 3
    japvyz-qyjti4-kajrod-nubxaW-hukkan-dijcaf
    vydpig-fucnul-3ukpog-voggom-zygNad-jepgad
    zocmez-byznis-hegTaj-jecdyq-qiqmiq-5enwom

[1]: https://developer.apple.com/password-rules/

## genpass-monkey

Generates visually unambiguous random meaningless strings using [Crockford's
base32][2].

    % genpass-monkey
    xt7gn976e7jj3fstgpy27330x3

    % genpass-monkey 3
    n1qqwtzgejwgqve9yzf2gxvx4m
    r2n3f5s6vbqs2yx7xjnmahqewy
    296w9y9rts3p5r9yay0raek8e5

[2]: https://www.crockford.com/base32.html

## genpass-xkcd

Generates passphrases from `/usr/share/dict/words` inspired by the [famous (and
slightly misleading) XKCD comic][3]. Each passphrase is prepended with a digit
showing the number of words in the passphrase to adhere to password security
requirements that require digits. Each word is 6 characters or less.

    % genpass-xkcd
    9-eaten-Slav-rife-aired-hill-cordon-splits-welsh-napes

    % genpass-xkcd 3
    9-worker-Vlad-horde-shrubs-smite-thwart-paw-alters-prawns
    9-tutors-stink-rhythm-junk-snappy-hooray-barbs-mewl-clomp
    9-vital-escape-Angkor-Huff-wet-Mayra-abbés-putts-guzzle

[3]: https://xkcd.com/936/
