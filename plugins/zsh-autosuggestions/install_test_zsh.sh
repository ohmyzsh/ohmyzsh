#!/bin/sh

set -ex

for v in $(grep "^[^#]" ZSH_VERSIONS); do
  mkdir zsh-$v
  cd zsh-$v

  curl -L https://api.github.com/repos/zsh-users/zsh/tarball/zsh-$v | tar xz --strip=1

  ./Util/preconfig
  ./configure --enable-pcre \
              --enable-cap \
              --enable-multibyte \
              --with-term-lib='ncursesw tinfo' \
              --with-tcsetpgrp \
              --program-suffix="-$v"

  make install.bin
  make install.modules
  make install.fns

  cd ..

  rm -rf zsh-$v
done
