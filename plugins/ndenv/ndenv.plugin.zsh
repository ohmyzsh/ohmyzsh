_homebrew-installed() {
  type brew &> /dev/null
}

FOUND_NDENV=0
ndenvdirs=("$HOME/.ndenv" "/usr/local/ndenv" "/opt/ndenv" "/usr/local/opt/ndenv")

if _homebrew-installed && ndenv_homebrew_path=$(brew --prefix ndenv 2>/dev/null); then
    ndenvdirs=($ndenv_homebrew_path "${ndenvdirs[@]}")
    unset ndenv_homebrew_path
fi

for ndenvdir in "${ndenvdirs[@]}" ; do
  if [ -d $ndenvdir/bin -a $FOUND_NDENV -eq 0 ] ; then
    FOUND_NDENV=1

    if [[ $NDENV_ROOT = '' ]]; then
      NDENV_ROOT=$ndenvdir
    fi

    export NDENV_ROOT
    export PATH=${ndenvdir}/bin:$PATH

    eval "$(ndenv init --no-rehash - zsh)"

    alias nodes="ndenv versions"

    function current_node() {
      echo "$(ndenv version-name)"
    }

    function ndenv_prompt_info() {
      echo "$(current_node)"
    }
  fi
done
unset ndenvdir

if [ $FOUND_NDENV -eq 0 ] ; then
  alias nodes='node -v'
  function ndenv_prompt_info() { echo "system: $(node -v | cut -f-2 -d ' ')" }
fi
