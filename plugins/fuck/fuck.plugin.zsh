if [ $commands[thefuck] ]; then
  alias fuck='eval $(thefuck $(fc -ln -1 | tail -n 1)); fc -R'
  alias FUCK='fuck'
else
  echo 'thefuck is not installed, you should "pip install thefuck" first'
fi
