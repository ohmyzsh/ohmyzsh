FROM gitpod/workspace-full

RUN sudo apt-get update && \
    sudo apt-get install -y zsh && \
    sudo rm -rf /var/lib/apt/lists/*
