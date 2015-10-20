# Release procedure (for developers):

- Check open issues and outstanding pull requests
- Confirm `make test` passes
  - check with multiple zsh versions
- Update changelog.md
- Remove `-dev` suffix from `./.version`;
  Commit that;
  Tag it using `git tag $(<.version)`;
  Increment `./.version` and restore the `-dev` suffix;
  Commit that.
- Push with `git push --tags`
- Notify downstreams (OS packages)
  - anitya should autodetect the tag
- Update /topic on IRC
