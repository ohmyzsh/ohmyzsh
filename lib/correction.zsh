if [[ "$ENABLE_CORRECTION" == "true" ]]; then
  alias cp='nocorrect cp'
  alias man='nocorrect man'
  alias mkdir='nocorrect mkdir'
  alias mv='nocorrect mv'
  alias su='nocorrect su'

  zstyle -s ':omz' 'subexecutor' _subex
  alias "$_subex"="nocorrect $_subex"
  unset _subex
  alias subex='nocorrect subex'

  setopt correct_all
fi
