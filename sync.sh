#!/bin/sh
git fetch upstream
git checkout master
git merge upstream/master
