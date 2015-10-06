## atom-cygwin

This plugin allows invoking the Atom Editor from Cygwin using the `atom` command.
For this purpose, it uses `cygpath` to convert between Unix and Windows paths.

### Requirements

 * [Atom](https://atom.io/)
 * [Cygwin](https://www.cygwin.com/)

### Usage

Same as the original CLI script (pointed by `${LOCALAPPDATA}/atom/bin/atom`).

 * If `atom` command is called without an argument, launch Atom
 * If `atom` is passed a directory, open it in Atom
 * If `atom` is passed a file, open it in Atom
