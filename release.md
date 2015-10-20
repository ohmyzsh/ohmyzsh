# Release procedure (for developers):

- Check open issues and outstanding pull requests
- Confirm `make test` passes
  - check with multiple zsh versions
- Update changelog.md
- Update ./.version
- `git tag $(<.version) && git push --tags`
- `perl -pi -e 's/$/-dev/' ./.version`
- Notify downstreams (OS packages)
  - anitya should autodetect the tag
