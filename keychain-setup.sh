#!/bin/sh

# This script sets up the keychain and is sourced by .{ba,z}shrc.
keychain ~/.ssh/id_rsa
. ~/.keychain/${HOST}-sh
