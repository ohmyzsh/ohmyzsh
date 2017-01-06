# Authors:
# https://github.com/AlexBio
# https://github.com/dbb
# https://github.com/Mappleconfusers
# Nicolas Jonas nextgenthemes.com
# https://github.com/loctauxphilippe
#
# Debian, Ubuntu and friends related zsh aliases and functions for zsh

alias acs='apt-cache search'
compdef _acs acs='apt-cache search'

alias afs='apt-file search --regexp'
compdef _afs afs='apt-file search --regexp'

# These are apt-get only
alias ags='apt-get source'   # asrc
compdef _ags ags='apt-get source'

alias acp='apt-cache policy' # app
compdef _acp acp='apt-cache policy'

# superuser operations ######################################################
alias afu='sudo apt-file update'
compdef _afu afu='sudo apt-file update'

alias ppap='sudo ppa-purge'
compdef _ppap ppap='sudo ppa-purge'

alias ag='sudo apt-get'            # age - but without sudo
alias aga='sudo apt-get autoclean' # aac
alias agb='sudo apt-get build-dep' # abd
alias agc='sudo apt-get clean'     # adc
alias agd='sudo apt-get dselect-upgrade' # ads
alias agi='sudo apt-get install'  # ai
alias agp='sudo apt-get purge'    # ap
alias agr='sudo apt-get remove'   # ar
alias agu='sudo apt-get update'   # ad
alias agud='sudo apt-get update && sudo apt-get dist-upgrade' #adu
alias agug='sudo apt-get upgrade' # ag
alias aguu='sudo apt-get update && sudo apt-get upgrade'      #adg
alias agar='sudo apt-get autoremove'

compdef _ag ag='sudo apt-get'
compdef _aga aga='sudo apt-get autoclean'
compdef _agb agb='sudo apt-get build-dep'
compdef _agc agc='sudo apt-get clean'
compdef _agd agd='sudo apt-get dselect-upgrade'
compdef _agi agi='sudo apt-get install'
compdef _agp agp='sudo apt-get purge'
compdef _agr agr='sudo apt-get remove'
compdef _agu agu='sudo apt-get update'
compdef _agud agud='sudo apt-get update && sudo apt-get dist-upgrade'
compdef _agug agug='sudo apt-get upgrade'
compdef _aguu aguu='sudo apt-get update && sudo apt-get upgrade'
compdef _agar agar='sudo apt-get autoremove'

# Remove ALL kernel images and headers EXCEPT the one in use
alias kclean='sudo aptitude remove -P ?and(~i~nlinux-(ima|hea) \
  ?not(~n`uname -r`))'

# Misc. #####################################################################
# print all installed packages
alias allpkgs='dpkg --get-selections | grep -v deinstall'

# Create a basic .deb package
alias mydeb='time dpkg-buildpackage -rfakeroot -us -uc'

# apt-add-repository with automatic install/upgrade of the desired package
# Usage: aar ppa:xxxxxx/xxxxxx [packagename]
# If packagename is not given as 2nd argument the function will ask for it and guess the default by taking
# the part after the / from the ppa name which is sometimes the right name for the package you want to install
aar() {
  if [ -n "$2" ]; then
    PACKAGE=$2
  else
  read "PACKAGE?Type in the package name to install/upgrade with this ppa [${1##*/}]: "
  fi

  if [ -z "$PACKAGE" ]; then
    PACKAGE=${1##*/}
  fi

  sudo apt-add-repository $1 && sudo apt-get update
  sudo apt-get install $PACKAGE
}

# Prints apt history
# Usage:
#   apt-history install
#   apt-history upgrade
#   apt-history remove
#   apt-history rollback
#   apt-history list
# Based On: http://linuxcommando.blogspot.com/2008/08/how-to-show-apt-log-history.html
apt-history () {
  case "$1" in
    install)
      zgrep --no-filename 'install ' $(ls -rt /var/log/dpkg*)
      ;;
    upgrade|remove)
      zgrep --no-filename $1 $(ls -rt /var/log/dpkg*)
      ;;
    rollback)
      zgrep --no-filename upgrade $(ls -rt /var/log/dpkg*) | \
        grep "$2" -A10000000 | \
        grep "$3" -B10000000 | \
        awk '{print $4"="$5}'
      ;;
    list)
      zgrep --no-filename '' $(ls -rt /var/log/dpkg*)
      ;;
    *)
      echo "Parameters:"
      echo " install - Lists all packages that have been installed."
      echo " upgrade - Lists all packages that have been upgraded."
      echo " remove - Lists all packages that have been removed."
      echo " rollback - Lists rollback information."
      echo " list - Lists all contains of dpkg logs."
      ;;
  esac
}

# Kernel-package building shortcut
kerndeb () {
    # temporarily unset MAKEFLAGS ( '-j3' will fail )
    MAKEFLAGS=$( print - $MAKEFLAGS | perl -pe 's/-j\s*[\d]+//g' )
    print '$MAKEFLAGS set to '"'$MAKEFLAGS'"
    appendage='-custom' # this shows up in $ (uname -r )
    revision=$(date +"%Y%m%d") # this shows up in the .deb file name

    make-kpkg clean

    time fakeroot make-kpkg --append-to-version "$appendage" --revision \
        "$revision" kernel_image kernel_headers
}

# List packages by size
function apt-list-packages {
    dpkg-query -W --showformat='${Installed-Size} ${Package} ${Status}\n' | \
    grep -v deinstall | \
    sort -n | \
    awk '{print $1" "$2}'
}

function spotify-ctl {
  ## CONSTANTS ##
  SP_DEST="org.mpris.MediaPlayer2.spotify"
  SP_PATH="/org/mpris/MediaPlayer2"
  SP_MEMB="org.mpris.MediaPlayer2.Player"

  ## UTILITY FUNCTIONS ##
  function require {
    hash $1 2>/dev/null || {
      echo >&2 "Error: '$1' is required, but is not available in your system."; return 0;
    }
  }

  ## COMMON REQUIRED BINARIES ##
  # We need dbus-send to talk to Spotify.
  require dbus-send

  # Assert standard Unix utilities are available.
  require grep
  require sed
  require cut
  require tr

  ## 'SPECIAL' (NON-DBUS-ALIAS) COMMANDS ##
  # Sends the given method to Spotify over dbus.
  function sp-dbus {
    dbus-send --print-reply --dest=$SP_DEST $SP_PATH $SP_MEMB.$1 ${*:2} > /dev/null
  }

  # Opens the given spotify: URI in Spotify.
  function sp-open {
    sp-dbus OpenUri string:$1
  }

  # Prints the currently playing track in a parseable format.
  function sp-metadata {
    dbus-send                                                                   \
    --print-reply                                  `# We need the reply.`       \
    --dest=$SP_DEST                                                             \
    $SP_PATH                                                                    \
    org.freedesktop.DBus.Properties.Get                                         \
    string:"$SP_MEMB" string:'Metadata'                                         \
    | grep -Ev "^method"                           `# Ignore the first line.`   \
    | grep -Eo '("(.*)")|(\b[0-9][a-zA-Z0-9.]*\b)' `# Filter interesting fiels.`\
    | sed -E '2~2 a|'                              `# Mark odd fields.`         \
    | tr -d '\n'                                   `# Remove all newlines.`     \
    | sed -E 's/\|/\n/g'                           `# Restore newlines.`        \
    | sed -E 's/(xesam:)|(mpris:)//'               `# Remove ns prefixes.`      \
    | sed -E 's/^"//'                              `# Strip leading...`         \
    | sed -E 's/"$//'                              `# ...and trailing quotes.`  \
    | sed -E 's/"+/|/'                             `# Regard "" as seperator.`  \
    | sed -E 's/ +/ /g'                            `# Merge consecutive spaces.`
  }

  # Prints the currently playing track in a friendly format.
  function sp-current {
    require column

    sp-metadata \
    | grep --color=never -E "(title)|(album)|(artist)" \
    | sed 's/^\(.\)/\U\1/' \
    | column -t -s'|'
  }

  # Prints the currently playing track as shell variables, ready to be eval'ed
  function sp-eval {
    require sort

    sp-metadata \
    | grep --color=never -E "(title)|(album)|(artist)|(trackid)|(trackNumber)" \
    | sort -r \
    | sed 's/^\([^|]*\)\|/\U\1/' \
    | sed -E 's/\|/="/' \
    | sed -E 's/$/"/' \
    | sed -E 's/^/SPOTIFY_/'
  }

  # Prints the artUrl.
  function sp-art {
    sp-metadata | grep "artUrl" | cut -d'|' -f2
  }

  # Prints the HTTP url.
  function sp-url {
    TRACK=$(sp-metadata | grep "url" | cut -d'|' -f2 )
    echo "$TRACK"
  }

  # xdg-opens the HTTP url.
  function sp-http {
    require xdg-open
    xdg-open $(sp-url)
  }

  # Prints usage information.
  function sp-help {
    echo "Usage: soptify-ctl [command]"
    echo "Control a running Spotify instance from the command line."
    echo ""
    echo "  spotify-ctl play       - Play Spotify"
    echo "  spotify-ctl pause      - Pause Spotify"
    echo "  spotify-ctl playpause  - Toggles between Play and Pause"
    echo "  spotify-ctl next       - Go to next track"
    echo "  spotify-ctl prev       - Go to previous track"
    echo ""
    echo "  spotify-ctl current    - Format the currently playing track"
    echo "  spotify-ctl metadata   - Dump the current track's metadata"
    echo "  spotify-ctl eval       - Return the metadata as a shell script"
    echo "  spotify-ctl art        - Print the URL to the current track's album artwork"
    echo ""
    echo "  spotify-ctl url        - Print the HTTP URL for the currently playing track"
    echo "  spotify-ctl http       - Open the HTTP URL in a web browser"
    echo ""
    echo "  spotify-ctl open <uri> - Open a spotify: uri"
    echo "  spotify-ctl search <q> - Start playing the best search result for the given query"
    echo ""
    echo "  spotify-ctl help       - Show this information"
    echo ""
    echo "Any other argument will start a search (i.e. 'sp foo' will search for foo)."
  }

  # Searches for tracks, plays the first result.
  function sp-search {
    require curl

    Q="$@"
    SPTFY_URI=$( \
      curl -s -G  --data-urlencode "q=$Q" --data-urlencode "type=track" https://api.spotify.com/v1/search \
      | grep -E -o "spotify:track:[a-zA-Z0-9]+" -m 1 \
    )

    sp-open $SPTFY_URI
  }

  # Aliased common comands
  alias sp-play="       sp-dbus Play"
  alias sp-pause="      sp-dbus Pause"
  alias sp-playpause="  sp-dbus PlayPause"
  alias sp-next="       sp-dbus Next"
  alias sp-prev="       sp-dbus Previous"

  # DISPATCHER
  # First, we connect to the dbus session spotify is on. This isn't really needed
  # when running locally, but is crucial when we don't have an X display handy
  # (for instance, when running sp over ssh.)
  SPOTIFY_PID="$(pidof -s spotify)"

  if [[ -z "$SPOTIFY_PID" ]]; then
    echo "Error: Spotify is not running."
    exit 1
  fi

  QUERY_ENVIRON="$(cat /proc/${SPOTIFY_PID}/environ | tr '\0' '\n' | grep "DBUS_SESSION_BUS_ADDRESS" | cut -d "=" -f 2-)"
  if [[ "${QUERY_ENVIRON}" != "" ]]; then
    export DBUS_SESSION_BUS_ADDRESS="${QUERY_ENVIRON}"
  fi

  # Then we dispatch the command.
  subcommand="$1"

  if [[ -z "$subcommand" ]]; then
    # No arguments given, print help.
    sp-help
  else
    # Arguments given, check if it's a command.
    if $(type sp-$subcommand > /dev/null 2> /dev/null); then
      # It is. Run it.
      shift
      eval "sp-$subcommand $@"
    else
      # It's not. Try a search.
      eval "sp-search $@"
    fi
  fi
}
