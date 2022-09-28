# Contributing

## How to Contribute to zsh-completions

Contributions are welcome, just make sure you follow the guidelines:

 * Completions are not accepted when already available in zsh.
 * Completions are not accepted when already available in their original project.
 * Please do not just copy/paste someone else's completion, ask before.
 * Partially implemented completions are not accepted.
 * Please add a header containing authors, status and origin of the script and license header if you do not wish to use the Zsh license (example [here](src/_tox)).
 * Any reasonable open source license is acceptable but note that we recommend the use of the Zsh license and that you should use it if you hope for the function to migrate to zsh itself.
 * Please try to follow the [Zsh completion style guide](https://github.com/zsh-users/zsh/blob/master/Etc/completion-style-guide).
 * Please send one separate pull request per file.
 * Send a pull request or ask for committer access.

## Contributing Completion Functions to Zsh

The zsh project itself welcomes completion function contributions via
[github pull requests](https://github.com/zsh-users/zsh/),
[gitlab merge requests](https://gitlab.com/zsh-org/zsh/) or via patch
files sent to its mailing list, `zsh-workers@zsh.org`.

Contributing to zsh has the advantage of reaching the most users.

## Including Completion Functions in Upstream Projects

Many upstream projects include zsh completions.

If well maintained, this has the advantage that users get a completion
function that matches the installed version of their software.

If you are the upstream maintainer this is a good choice. If the project
already includes completions for bash, fish, tcsh, etc then they are
likely open to including zsh's too. It can also be a good option for
completions handling commands that are system or distribution specific.

Ideally, arrange for the project's build system to install the
completion function in `$prefix/share/zsh/site-functions`.
