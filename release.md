# Release procedure (for developers):

- Check open issues and outstanding pull requests
- Confirm `make test` passes
  - check with multiple zsh versions
- Update changelog.md
- Remove `-dev` suffix from `./.version`;
  Commit that using 'git commit -m "Tag version $(<.version).";
  Tag it using `git tag $(<.version)`;
  Increment `./.version` and restore the `-dev` suffix;
  Commit that using 'git commit -C b5c30ae52638e81a38fe5329081c5613d7bd6ca5'.
- Push with `git push --tags`
- Notify downstreams (OS packages)
  - anitya should autodetect the tag
- Update /topic on IRC
