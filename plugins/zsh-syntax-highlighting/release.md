# Release procedure (for developers):

- Ensure every `is-at-least` invocation passes a stable zsh release's version number as the first argument
- For minor (A.B.0) releases:
  - Check whether the release uses any not-yet-released zsh features
- Check open issues and outstanding pull requests
- Confirm `make test` passes
  - check with multiple zsh versions
    (easiest to check GitHub Actions: https://github.com/zsh-users/zsh-syntax-highlighting/actions)
- Update changelog.md
  `tig --abbrev=12  --abbrev-commit 0.4.1..upstream/master`
- Make sure there are no local commits and that `git status` is clean;
  Remove `-dev` suffix from `./.version`;
  Commit that using `git commit -m "Tag version $(<.version)." .version`;
  Tag it using `git tag -s -m "Tag version $(<.version)" $(<.version)`;
  Increment `./.version` and restore the `-dev` suffix;
  Commit that using `git commit -C b5c30ae52638e81a38fe5329081c5613d7bd6ca5 .version`.
- Push with `git push && git push --tags`
- Notify downstreams (OS packages)
  - anitya should autodetect the tag
- Update /topic on IRC
