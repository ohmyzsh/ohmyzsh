FROM ubuntu:latest

# Install system packages
RUN apt-get update && apt-get install -y \
    curl \
    git \
    zsh \
    gpg \
    ripgrep
# Install oh-my-zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

RUN mkdir -p /root/.oh-my-zsh/plugins/history-sync
COPY history-sync.plugin.zsh /root/.oh-my-zsh/plugins/history-sync/
COPY test/zshrc /root/.zshrc
COPY test/test.zsh /root
RUN chmod +x /root/test.zsh

ARG ACCESS_KEY
ENV ACCESS_KEY=${ACCESS_KEY}
ENTRYPOINT /usr/bin/zsh -i /root/test.zsh $ACCESS_KEY
