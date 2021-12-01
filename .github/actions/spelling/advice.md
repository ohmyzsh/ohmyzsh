<!-- See https://github.com/check-spelling/check-spelling/wiki/Configuration-Examples%3A-advice --> <!-- markdownlint-disable MD033 MD041 -->
<details><summary>If you see a bunch of garbage</summary>

If it relates to a ...
<details><summary>well-formed pattern</summary>

See if there's a [pattern](https://github.com/check-spelling/check-spelling/wiki/Configuration-Examples:-patterns) that would match it.

If not, try writing one and adding it to the `patterns.txt` file.

Patterns are Perl 5 Regular Expressions - you can [test](
https://www.regexplanet.com/advanced/perl/) yours before committing to verify it will match your lines.

Note that patterns can't match multiline strings.
</details>
<details><summary>binary-ish string</summary>

Please add a file path to the `excludes.txt` file instead of just accepting the garbage.

File paths are Perl 5 Regular Expressions - you can [test](
https://www.regexplanet.com/advanced/perl/) yours before committing to verify it will match your files.

`^` refers to the file's path from the root of the repository, so `^README\.md$` would exclude [README.md](
../tree/HEAD/README.md) (on whichever branch you're using).
</details>

</details>
