if [[ "$DISABLE_CORRECTION" == "true" ]]; then
  return
else
  setopt correct_all
  alias man='nocorrect man'
  alias mv='nocorrect mv'
  alias mysql='nocorrect mysql'
  alias mkdir='nocorrect mkdir'
  alias gist='nocorrect gist'
  alias heroku='nocorrect heroku'
  alias ebuild='nocorrect ebuild'
  alias hpodder='nocorrect hpodder'
  alias sudo='nocorrect sudo'
fi
