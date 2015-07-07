#!/usr/bin/env zsh
#
# update-from-upstream.zsh
#
# This script updates the Oh My Zsh version of the zsh-history-substring-search
# plugin from the independent upstream repo. This is to be run by OMZ developers
# when they want to pull in new changes from upstream to OMZ. It is not run
# during normal use of the plugin.
#
# The official upstream repo is zsh-users/zsh-history-substring-search
# https://github.com/zsh-users/zsh-history-substring-search
#
# This is a zsh script, not a function. Call it with `zsh update-from-upstream.zsh`
# from the command line, running it from within the plugin directory.
#
# You can set the environment variable REPO_PATH to point it at an upstream
# repo you have already prepared. Otherwise, it will do a clean checkout of
# upstream's HEAD to a temporary local repo and use that.


# Just bail on any error so we don't have to do extra checking.
# This is a developer-use script, so terse output like that should
# be fine.
set -e


UPSTREAM_BASE=zsh-history-substring-search
UPSTREAM_REPO=zsh-users/$UPSTREAM_BASE
need_repo_cleanup=false
upstream_github_url="https://github.com/$UPSTREAM_REPO"

if [[ -z "$UPSTREAM_REPO_PATH" ]]; then
  # Do a clean checkout
  my_tempdir=$(mktemp -d -t omz-update-histsubstrsrch)
  UPSTREAM_REPO_PATH="$my_tempdir/$UPSTREAM_BASE"
  git clone "$upstream_github_url" "$UPSTREAM_REPO_PATH"
  need_repo_cleanup=true
  print "Checked out upstream repo to $UPSTREAM_REPO_PATH"
else
	print "Using existing zsh-history-substring-search repo at $UPSTREAM_REPO_PATH"
fi

upstream="$UPSTREAM_REPO_PATH"

# Figure out what we're pulling in
upstream_sha=$(cd $upstream && git rev-parse HEAD)
upstream_commit_date=$(cd $upstream && git log  -1 --pretty=format:%ci)
print "upstream SHA:         $upstream_sha"
print "upstream commit date: $upstream_commit_date"
print

# Copy the files over, using the OMZ plugin's names where needed
cp -v "$upstream"/* .
mv zsh-history-substring-search.plugin.zsh history-substring-search.plugin.zsh
mv zsh-history-substring-search.zsh history-substring-search.zsh

if [[ $need_repo_cleanup == true ]]; then
	print "Removing temporary repo at $my_tempdir"
	rm -rf "$my_tempdir"
fi

# Do OMZ-specific edits

print
print "Updating files with OMZ-specific stuff"

# Tack OMZ-specific notes on to readme
thin_line="------------------------------------------------------------------------------"
cat >> README.md <<EOF

$thin_line
Oh My Zsh Notes
$thin_line

This is Oh My Zsh's repackaging of zsh-history-substring-search as an OMZ module
inside the Oh My Zsh distribution.

The upstream repo, $UPSTREAM_REPO, can be found on GitHub at $upstream_github_url.

This downstream copy was last updated from the following upstream commit:

  SHA:          $upstream_sha
  Commit date:  $upstream_commit_date

Everything above this section is a copy of the original upstream's README, so things
may differ slightly when you're using this inside OMZ. In particular, you do not
need to set up key bindings yourself in \`~/.zshrc\`; the OMZ plugin does that for
you.

EOF

print
print "Done OK"

