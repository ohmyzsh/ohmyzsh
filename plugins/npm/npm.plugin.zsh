# Copyright notice for use and modification of SemVer Loose Regex:

# Copyright (c) Isaac Z. Schlueter ("Author")
# All rights reserved.

# The BSD License

# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:

# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.

# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.

# THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# All additional code released under project MIT license

eval "$(npm completion 2>/dev/null)"

# More helpful `npm view {package} version`
nvv() {
  echo "NPM registry package: $(npm view $1 version)"

  SEMVER_LOOSE="$1\@([0-9]+\.[0-9]+\.[0-9]+(-?(([0-9]+|\d*[a-zA-Z-][a-zA-Z0-9-]*)(\.([0-9]+|\d*[a-zA-Z-][a-zA-Z0-9-]*))*))?(\+([0-9A-Za-z-]+(\.[0-9A-Za-z-]+)*))?)"
  LOCAL_PKG=`npm ls $1 --depth=0`
  GLOBAL_PKG=`npm ls $1 -g --depth=0`

  if [[ $LOCAL_PKG =~ $SEMVER_LOOSE ]]; then
    echo "Local package: $match[1]"
  fi

  if [[ $GLOBAL_PKG =~ $SEMVER_LOOSE ]]; then
    echo "Global package: $match[1]"
  fi

  unset LOCAL_PKG
  unset GLOBAL_PKG
  unset SEMVER_LOOSE
}
