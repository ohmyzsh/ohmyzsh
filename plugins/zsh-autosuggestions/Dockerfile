FROM ruby:2.5.3-alpine

RUN apk add --no-cache autoconf
RUN apk add --no-cache libtool
RUN apk add --no-cache libcap-dev
RUN apk add --no-cache pcre-dev
RUN apk add --no-cache curl
RUN apk add --no-cache build-base
RUN apk add --no-cache ncurses-dev
RUN apk add --no-cache tmux

WORKDIR /zsh-autosuggestions

ADD ZSH_VERSIONS /zsh-autosuggestions/ZSH_VERSIONS
ADD install_test_zsh.sh /zsh-autosuggestions/install_test_zsh.sh
RUN ./install_test_zsh.sh

ADD Gemfile /zsh-autosuggestions/Gemfile
ADD Gemfile.lock /zsh-autosuggestions/Gemfile.lock
RUN bundle install
