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


upstream_basename=zsh-history-substring-search
plugin_basename=history-substring-search
UPSTREAM_REPO=zsh-users/$upstream_basename
need_repo_cleanup=false
upstream_github_url="https://github.com/$UPSTREAM_REPO"

if [[ -z "$UPSTREAM_REPO_PATH" ]]; then
  # Do a clean checkout
  my_tempdir=$(mktemp -d -t omz-update-histsubstrsrch)
  UPSTREAM_REPO_PATH="$my_tempdir/$upstream_basename"
  git clone "$upstream_github_url" "$UPSTREAM_REPO_PATH"
  need_repo_cleanup=true
  print "Checked out upstream repo to $UPSTREAM_REPO_PATH"
else
	print "Using existing $upstream_basename repo at $UPSTREAM_REPO_PATH"
fi

upstream="$UPSTREAM_REPO_PATH"

# Figure out what we're pulling in
upstream_sha=$(cd $upstream && git rev-parse HEAD)
upstream_commit_date=$(cd $upstream && git log  -1 --pretty=format:%ci)
upstream_just_date=${${=upstream_commit_date}[1]}
print "upstream SHA:         $upstream_sha"
print "upstream commit time: $upstream_commit_date"
print "upstream commit date: $upstream_just_date"
print

# Copy the files over, using the OMZ plugin's names where needed
cp -v "$upstream"/* .
mv -v zsh-history-substring-search.zsh $plugin_basename.zsh
mv -v zsh-history-substring-search.plugin.zsh $plugin_basename.plugin.zsh

if [[ $need_repo_cleanup == true ]]; then
	print "Removing temporary repo at $my_tempdir"
	rm -rf "$my_tempdir"
fi

# Do OMZ-specific edits

print
print "Updating files with OMZ-specific stuff"
print

# OMZ binds the keys as part of the plugin loading

cat >> $plugin_basename.plugin.zsh <<EOF


# Bind terminal-specific up and down keys

if [[ -n "\$terminfo[kcuu1]" ]]; then
  bindkey "\$terminfo[kcuu1]" history-substring-search-up
fi
if [[ -n "\$terminfo[kcud1]" ]]; then
  bindkey "\$terminfo[kcud1]" history-substring-search-down
fi

EOF

# Tack OMZ-specific notes on to readme

thin_line="------------------------------------------------------------------------------"
cat >> README.md <<EOF

$thin_line
Oh My Zsh Distribution Notes
$thin_line

What you are looking at now is Oh My Zsh's repackaging of zsh-history-substring-search 
as an OMZ module inside the Oh My Zsh distribution.

The upstream repo, $UPSTREAM_REPO, can be found on GitHub at 
$upstream_github_url.

This downstream copy was last updated from the following upstream commit:

  SHA:          $upstream_sha
  Commit date:  $upstream_commit_date

Everything above this section is a copy of the original upstream's README, so things
may differ slightly when you're using this inside OMZ. In particular, you do not
need to set up key bindings for the up and down arrows yourself in \`~/.zshrc\`; the OMZ 
plugin does that for you. You may still want to set up additional emacs- or vi-specific
bindings as mentioned above.

EOF

# Announce success and generate git commit messages

cat <<EOF
Done OK

Now you can check the results and commit like this:

  git add *
  git commit -m "history-substring-search: update to upstream version $upstream_just_date" \\
      -m "Updates OMZ's copy to commit $upstream_sha from $UPSTREAM_REPO"

EOF

