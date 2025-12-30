# fixme - the load process here seems a bit bizarre
zmodload -i zsh/complist

WORDCHARS=''

unsetopt menu_complete   # do not autoselect the first completion entry
unsetopt flowcontrol
setopt auto_menu         # show completion menu on successive tab press
setopt complete_in_word
setopt always_to_end

# should this be in keybindings?
bindkey -M menuselect '^o' accept-and-infer-next-history
zstyle ':completion:*:*:*:*:*' menu select


# Completion matcher configuration:
# - case-sensitive: if 'yes', matching is case-sensitive (default: no, case-insensitive)
# - hyphen-insensitive: if 'yes', treat hyphens and underscores as equivalent (default: no)
# - substring-match: if 'yes', match substrings anywhere in completion (e.g., "de" matches "abcdef") (default: yes)
# - fuzzy-match: if 'yes', match characters with gaps (e.g., "ad" matches "abcdef") (default: no)
#   Note: fuzzy-match is more permissive and may impact performance; it includes substring behavior

# Support legacy environment variables (will be deprecated)
[[ "$CASE_SENSITIVE" = true ]] && zstyle ':omz:completion' case-sensitive 'yes'
[[ "$HYPHEN_INSENSITIVE" = true ]] && zstyle ':omz:completion' hyphen-insensitive 'yes'
unset CASE_SENSITIVE HYPHEN_INSENSITIVE

# Set defaults if not already configured
zstyle -s ':omz:completion' case-sensitive _ || zstyle ':omz:completion' case-sensitive 'no'
zstyle -s ':omz:completion' hyphen-insensitive _ || zstyle ':omz:completion' hyphen-insensitive 'no'
zstyle -s ':omz:completion' substring-match _ || zstyle ':omz:completion' substring-match 'yes'
zstyle -s ':omz:completion' fuzzy-match _ || zstyle ':omz:completion' fuzzy-match 'no'

# Build matcher-list based on enabled features
() {
  local -a matchers=()
  local -i case_sensitive hyphen_insensitive substring_match fuzzy_match

  # Query zstyle settings (convert to 0 or 1)
  zstyle -t ':omz:completion' case-sensitive && case_sensitive=1 || case_sensitive=0
  zstyle -t ':omz:completion' hyphen-insensitive && hyphen_insensitive=1 || hyphen_insensitive=0
  zstyle -t ':omz:completion' substring-match && substring_match=1 || substring_match=0
  zstyle -t ':omz:completion' fuzzy-match && fuzzy_match=1 || fuzzy_match=0
  
  # Matcher 1: Case and hyphen sensitivity
  if (( ! case_sensitive )); then
    if (( hyphen_insensitive )); then
      # Case-insensitive + hyphen-insensitive
      matchers+=('m:{[:lower:][:upper:]-_}={[:upper:][:lower:]_-}')
    else
      # Case-insensitive only
      matchers+=('m:{[:lower:][:upper:]}={[:upper:][:lower:]}')
    fi
  else
    if (( hyphen_insensitive )); then
      # Case-sensitive + hyphen-insensitive
      matchers+=('m:{-_}={_-}')
    fi
    # If both case-sensitive and hyphen-sensitive, no first matcher needed
  fi

  # Matcher 2: Partial word completion (left anchor)
  # Matches from the left side of words: "ab" matches "abcd"
  matchers+=('r:|=*')

  # Matcher 3 & 4: Substring and fuzzy match
  if (( fuzzy_match )); then
    # Fuzzy match: allows match characters with gaps, also includes substring behavior
    # "ad" can match "abcdef" (a...d...), very permissive
    matchers+=('r:|?=**')
  elif (( substring_match )); then
    # Substring match: matches contiguous substrings anywhere
    # "de" matches "abcdef", but "ad" would not match
    matchers+=('l:|=* r:|=*')
  fi

  # Apply the final matcher-list
  zstyle ':completion:*' matcher-list $matchers
}


# Complete . and .. special directories
zstyle ':completion:*' special-dirs true

zstyle ':completion:*' list-colors ''
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

if [[ "$OSTYPE" = solaris* ]]; then
  zstyle ':completion:*:*:*:*:processes' command "ps -u $USERNAME -o pid,user,comm"
else
  zstyle ':completion:*:*:*:*:processes' command "ps -u $USERNAME -o pid,user,comm -w -w"
fi

# disable named-directories autocompletion
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories

# Use caching so that commands like apt and dpkg complete are usable
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path $ZSH_CACHE_DIR

# Don't complete uninteresting users
zstyle ':completion:*:*:*:users' ignored-patterns \
        adm amanda apache at avahi avahi-autoipd beaglidx bin cacti canna \
        clamav daemon dbus distcache dnsmasq dovecot fax ftp games gdm \
        gkrellmd gopher hacluster haldaemon halt hsqldb ident junkbust kdm \
        ldap lp mail mailman mailnull man messagebus mldonkey mysql nagios \
        named netdump news nfsnobody nobody nscd ntp nut nx obsrun openvpn \
        operator pcap polkitd postfix postgres privoxy pulse pvm quagga radvd \
        rpc rpcuser rpm rtkit scard shutdown squid sshd statd svn sync tftp \
        usbmux uucp vcsa wwwrun xfs '_*'

# ... unless we really want to.
zstyle '*' single-ignored show

if [[ ${COMPLETION_WAITING_DOTS:-false} != false ]]; then
  expand-or-complete-with-dots() {
    # use $COMPLETION_WAITING_DOTS either as toggle or as the sequence to show
    [[ $COMPLETION_WAITING_DOTS = true ]] && COMPLETION_WAITING_DOTS="%F{red}…%f"
    # turn off line wrapping and print prompt-expanded "dot" sequence
    printf '\e[?7l%s\e[?7h' "${(%)COMPLETION_WAITING_DOTS}"
    zle expand-or-complete
    zle redisplay
  }
  zle -N expand-or-complete-with-dots
  # Set the function as the default tab completion widget
  bindkey -M emacs "^I" expand-or-complete-with-dots
  bindkey -M viins "^I" expand-or-complete-with-dots
  bindkey -M vicmd "^I" expand-or-complete-with-dots
fi

# automatically load bash completion functions
autoload -U +X bashcompinit && bashcompinit
