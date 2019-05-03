# Release procedure (for developers):

- For minor (A.B.0) releases:
  - Check whether the release uses any not-yet-released zsh features
- Check open issues and outstanding pull requests
- Confirm `make test` passes
  - check with multiple zsh versions
- Update changelog.md
  `tig --abbrev=12  --abbrev-commit 0.4.1..upstream/master`
- Remove `-dev` suffix from `./.version`;
  Commit that using `git commit -m "Tag version $(<.version)." .version`;
  Tag it using `git tag -m "Tag version $(<.version)"`;
  Increment `./.version` and restore the `-dev` suffix;
  Commit that using `git commit -C b5c30ae52638e81a38fe5329081c5613d7bd6ca5 .version`.
- Push with `git push && git push --tags`
- Notify downstreams (OS packages)
  - anitya should autodetect the tag
- Update /topic on IRC
