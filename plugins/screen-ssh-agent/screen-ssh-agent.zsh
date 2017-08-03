if [ $SSH_AUTH_SOCK ]; then
  # set up SSH agent socket symlink
  export SSH_AUTH_SOCK_LINK="/tmp/ssh-$USER/agent"
  if ! [ -r $(readlink -m $SSH_AUTH_SOCK_LINK) ] && [ -r $SSH_AUTH_SOCK ]; then
	  mkdir -p "$(dirname $SSH_AUTH_SOCK_LINK)" &&
	  chmod go= "$(dirname $SSH_AUTH_SOCK_LINK)" &&
	  ln -sfn $SSH_AUTH_SOCK $SSH_AUTH_SOCK_LINK
  fi
fi

