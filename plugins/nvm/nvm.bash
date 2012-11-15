# Node Version Manager
# Implemented as a bash function
# To use source this file from your bash profile
#
# Implemented by Tim Caswell <tim@creationix.com>
# with much bash help from Matthew Ranney

# set NVM_DIR

# Auto detect the NVM_DIR
if [ ! -d "$NVM_DIR" ]; then
    export NVM_DIR=$(cd $(dirname ${BASH_SOURCE[0]:-$0}) && pwd)
fi

# Make zsh glob matching behave same as bash
# This fixes the "zsh: no matches found" errors
if [ ! -z "$(which unsetopt 2>/dev/null)" ]; then
    unsetopt nomatch 2>/dev/null
fi

# Try to figure out the os and arch for binary fetching
uname="$(uname -a)"
os=
arch="$(uname -m)"
case "$uname" in
  Linux\ *) os=linux ;;
  Darwin\ *) os=darwin ;;
  SunOS\ *) os=sunos ;;
esac
case "$uname" in
  *x86_64*) arch=x64 ;;
  *i*86*) arch=x86 ;;
esac

# Expand a version using the version cache
nvm_version()
{
    PATTERN=$1
    # The default version is the current one
    if [ ! "$PATTERN" ]; then
        PATTERN='current'
    fi

    VERSION=`nvm_ls $PATTERN | tail -n1`
    echo "$VERSION"

    if [ "$VERSION" = 'N/A' ]; then
        return
    fi
}

nvm_remote_version()
{
    PATTERN=$1
    VERSION=`nvm_ls_remote $PATTERN | tail -n1`
    echo "$VERSION"

    if [ "$VERSION" = 'N/A' ]; then
        return
    fi
}

nvm_ls()
{
    PATTERN=$1
    VERSIONS=''
    if [ "$PATTERN" = 'current' ]; then
        echo `node -v 2>/dev/null`
        return
    fi

    if [ -f "$NVM_DIR/alias/$PATTERN" ]; then
        nvm_version `cat $NVM_DIR/alias/$PATTERN`
        return
    fi
    # If it looks like an explicit version, don't do anything funny
    if [[ "$PATTERN" == v?*.?*.?* ]]; then
        VERSIONS="$PATTERN"
    else
        VERSIONS=`(cd $NVM_DIR; \ls -d v${PATTERN}* 2>/dev/null) | sort -t. -k 1.2,1n -k 2,2n -k 3,3n`
    fi
    if [ ! "$VERSIONS" ]; then
        echo "N/A"
        return
    fi
    echo "$VERSIONS"
    return
}

nvm_ls_remote()
{
    PATTERN=$1
    if [ "$PATTERN" ]; then
        if echo "${PATTERN}" | grep -v '^v' ; then
            PATTERN=v$PATTERN
        fi
    else
        PATTERN=".*"
    fi
    VERSIONS=`curl -s http://nodejs.org/dist/ \
            | egrep -o 'v[0-9]+\.[0-9]+\.[0-9]+' \
            | grep -w "${PATTERN}" \
            | sort -t. -u -k 1.2,1n -k 2,2n -k 3,3n`
    if [ ! "$VERSIONS" ]; then
        echo "N/A"
        return
    fi
    echo "$VERSIONS"
    return
}

nvm_checksum()
{
    if [ "$1" = "$2" ]; then
        return
    else
        echo 'Checksums do not match.'
        return 1
    fi
}


print_versions()
{
    OUTPUT=''
    for VERSION in $1; do
        PADDED_VERSION=`printf '%10s' $VERSION`
        if [[ -d "$NVM_DIR/$VERSION" ]]; then
             PADDED_VERSION="\033[0;34m$PADDED_VERSION\033[0m"
        fi
        OUTPUT="$OUTPUT\n$PADDED_VERSION"
    done
    echo -e "$OUTPUT" | column
}

nvm()
{
  if [ $# -lt 1 ]; then
    nvm help
    return
  fi
  case $1 in
    "help" )
      echo
      echo "Node Version Manager"
      echo
      echo "Usage:"
      echo "    nvm help                    Show this message"
      echo "    nvm install <version>       Download and install a <version>"
      echo "    nvm uninstall <version>     Uninstall a version"
      echo "    nvm use <version>           Modify PATH to use <version>"
      echo "    nvm run <version> [<args>]  Run <version> with <args> as arguments"
      echo "    nvm ls                      List installed versions"
      echo "    nvm ls <version>            List versions matching a given description"
      echo "    nvm ls-remote               List remote versions available for install"
      echo "    nvm deactivate              Undo effects of NVM on current shell"
      echo "    nvm alias [<pattern>]       Show all aliases beginning with <pattern>"
      echo "    nvm alias <name> <version>  Set an alias named <name> pointing to <version>"
      echo "    nvm unalias <name>          Deletes the alias named <name>"
      echo "    nvm copy-packages <version> Install global NPM packages contained in <version> to current version"
      echo
      echo "Example:"
      echo "    nvm install v0.4.12         Install a specific version number"
      echo "    nvm use 0.2                 Use the latest available 0.2.x release"
      echo "    nvm run 0.4.12 myApp.js     Run myApp.js using node v0.4.12"
      echo "    nvm alias default 0.4       Auto use the latest installed v0.4.x version"
      echo
    ;;
    "install" )
      if [ ! `which curl` ]; then
        echo 'NVM Needs curl to proceed.' >&2;
      fi

      if [ $# -lt 2 ]; then
        nvm help
        return
      fi
      VERSION=`nvm_remote_version $2`
      ADDITIONAL_PARAMETERS=''
      shift
      shift
      while [ $# -ne 0 ]
      do
        ADDITIONAL_PARAMETERS="$ADDITIONAL_PARAMETERS $1"
        shift
      done

      [ -d "$NVM_DIR/$VERSION" ] && echo "$VERSION is already installed." && return

      # shortcut - try the binary if possible.
      if [ -n "$os" ]; then
        binavail=
        # binaries started with node 0.8.6
        case "$VERSION" in
          v0.8.[012345]) binavail=0 ;;
          v0.[1234567]) binavail=0 ;;
          *) binavail=1 ;;
        esac
        if [ $binavail -eq 1 ]; then
          t="$VERSION-$os-$arch"
          url="http://nodejs.org/dist/$VERSION/node-${t}.tar.gz"
          sum=`curl -s http://nodejs.org/dist/$VERSION/SHASUMS.txt.asc | grep node-${t}.tar.gz | awk '{print $1}'`
          if (
            mkdir -p "$NVM_DIR/bin/node-${t}" && \
            cd "$NVM_DIR/bin" && \
            curl -C - --progress-bar $url -o "node-${t}.tar.gz" && \
            nvm_checksum `shasum node-${t}.tar.gz | awk '{print $1}'` $sum && \
            tar -xzf "node-${t}.tar.gz" -C "node-${t}" --strip-components 1 && \
            mv "node-${t}" "../$VERSION" && \
            rm -f "node-${t}.tar.gz"
            )
          then
            nvm use $VERSION
            return;
          else
            echo "Binary download failed, trying source." >&2
            cd "$NVM_DIR/bin" && rm -rf "node-${t}.tar.gz" "node-${t}"
          fi
        fi
      fi

      echo "Additional options while compiling: $ADDITIONAL_PARAMETERS"

      tarball=''
      sum=''
      if [ "`curl -Is "http://nodejs.org/dist/$VERSION/node-$VERSION.tar.gz" | grep '200 OK'`" != '' ]; then
        tarball="http://nodejs.org/dist/$VERSION/node-$VERSION.tar.gz"
        sum=`curl -s http://nodejs.org/dist/$VERSION/SHASUMS.txt | grep node-$VERSION.tar.gz | awk '{print $1}'`
      elif [ "`curl -Is "http://nodejs.org/dist/node-$VERSION.tar.gz" | grep '200 OK'`" != '' ]; then
        tarball="http://nodejs.org/dist/node-$VERSION.tar.gz"
      fi
      if (
        [ ! -z $tarball ] && \
        mkdir -p "$NVM_DIR/src" && \
        cd "$NVM_DIR/src" && \
        curl --progress-bar $tarball -o "node-$VERSION.tar.gz" && \
        if [ "$sum" = "" ]; then : ; else nvm_checksum `shasum node-$VERSION.tar.gz | awk '{print $1}'` $sum; fi && \
        tar -xzf "node-$VERSION.tar.gz" && \
        cd "node-$VERSION" && \
        ./configure --prefix="$NVM_DIR/$VERSION" $ADDITIONAL_PARAMETERS && \
        make && \
        rm -f "$NVM_DIR/$VERSION" 2>/dev/null && \
        make install
        )
      then
        nvm use $VERSION
        if ! which npm ; then
          echo "Installing npm..."
          if [[ "`expr match $VERSION '\(^v0\.1\.\)'`" != '' ]]; then
            echo "npm requires node v0.2.3 or higher"
          elif [[ "`expr match $VERSION '\(^v0\.2\.\)'`" != '' ]]; then
            if [[ "`expr match $VERSION '\(^v0\.2\.[0-2]$\)'`" != '' ]]; then
              echo "npm requires node v0.2.3 or higher"
            else
              curl https://npmjs.org/install.sh | clean=yes npm_install=0.2.19 sh
            fi
          else
            curl https://npmjs.org/install.sh | clean=yes sh
          fi
        fi
      else
        echo "nvm: install $VERSION failed!"
      fi
    ;;
    "uninstall" )
      [ $# -ne 2 ] && nvm help && return
      if [[ $2 == `nvm_version` ]]; then
        echo "nvm: Cannot uninstall currently-active node version, $2."
        return
      fi
      VERSION=`nvm_version $2`
      if [ ! -d $NVM_DIR/$VERSION ]; then
        echo "$VERSION version is not installed yet... installing"
        nvm install $VERSION
        return;
      fi

      t="$VERSION-$os-$arch"

      # Delete all files related to target version.
      (mkdir -p "$NVM_DIR/src" && \
          cd "$NVM_DIR/src" && \
          rm -rf "node-$VERSION" 2>/dev/null && \
          rm -f "node-$VERSION.tar.gz" 2>/dev/null && \
          mkdir -p "$NVM_DIR/bin" && \
          cd "$NVM_DIR/bin" && \
          rm -rf "node-${t}" 2>/dev/null && \
          rm -f "node-${t}.tar.gz" 2>/dev/null && \
          rm -rf "$NVM_DIR/$VERSION" 2>/dev/null)
      echo "Uninstalled node $VERSION"

      # Rm any aliases that point to uninstalled version.
      for A in `grep -l $VERSION $NVM_DIR/alias/*`
      do
        nvm unalias `basename $A`
      done

    ;;
    "deactivate" )
      if [[ $PATH == *$NVM_DIR/*/bin* ]]; then
        export PATH=${PATH%$NVM_DIR/*/bin*}${PATH#*$NVM_DIR/*/bin:}
        hash -r
        echo "$NVM_DIR/*/bin removed from \$PATH"
      else
        echo "Could not find $NVM_DIR/*/bin in \$PATH"
      fi
      if [[ $MANPATH == *$NVM_DIR/*/share/man* ]]; then
        export MANPATH=${MANPATH%$NVM_DIR/*/share/man*}${MANPATH#*$NVM_DIR/*/share/man:}
        echo "$NVM_DIR/*/share/man removed from \$MANPATH"
      else
        echo "Could not find $NVM_DIR/*/share/man in \$MANPATH"
      fi
    ;;
    "use" )
      if [ $# -ne 2 ]; then
        nvm help
        return
      fi
      VERSION=`nvm_version $2`
      if [ ! -d $NVM_DIR/$VERSION ]; then
        echo "$VERSION version is not installed yet"
        return;
      fi
      if [[ $PATH == *$NVM_DIR/*/bin* ]]; then
        PATH=${PATH%$NVM_DIR/*/bin*}$NVM_DIR/$VERSION/bin${PATH#*$NVM_DIR/*/bin}
      else
        PATH="$NVM_DIR/$VERSION/bin:$PATH"
      fi
      if [[ $MANPATH == *$NVM_DIR/*/share/man* ]]; then
        MANPATH=${MANPATH%$NVM_DIR/*/share/man*}$NVM_DIR/$VERSION/share/man${MANPATH#*$NVM_DIR/*/share/man}
      else
        MANPATH="$NVM_DIR/$VERSION/share/man:$MANPATH"
      fi
      export PATH
      hash -r
      export MANPATH
      export NVM_PATH="$NVM_DIR/$VERSION/lib/node"
      export NVM_BIN="$NVM_DIR/$VERSION/bin"
      echo "Now using node $VERSION"
    ;;
    "run" )
      # run given version of node
      if [ $# -lt 2 ]; then
        nvm help
        return
      fi
      VERSION=`nvm_version $2`
      if [ ! -d $NVM_DIR/$VERSION ]; then
        echo "$VERSION version is not installed yet"
        return;
      fi
      echo "Running node $VERSION"
      $NVM_DIR/$VERSION/bin/node "${@:3}"
    ;;
    "ls" | "list" )
      print_versions "`nvm_ls $2`"
      if [ $# -eq 1 ]; then
        echo -ne "current: \t"; nvm_version current
        nvm alias
      fi
      return
    ;;
    "ls-remote" | "list-remote" )
        print_versions "`nvm_ls_remote $2`"
        return
    ;;
    "alias" )
      mkdir -p $NVM_DIR/alias
      if [ $# -le 2 ]; then
        (cd $NVM_DIR/alias && for ALIAS in `\ls $2* 2>/dev/null`; do
            DEST=`cat $ALIAS`
            VERSION=`nvm_version $DEST`
            if [ "$DEST" = "$VERSION" ]; then
                echo "$ALIAS -> $DEST"
            else
                echo "$ALIAS -> $DEST (-> $VERSION)"
            fi
        done)
        return
      fi
      if [ ! "$3" ]; then
          rm -f $NVM_DIR/alias/$2
          echo "$2 -> *poof*"
          return
      fi
      mkdir -p $NVM_DIR/alias
      VERSION=`nvm_version $3`
      if [ $? -ne 0 ]; then
        echo "! WARNING: Version '$3' does not exist." >&2
      fi
      echo $3 > "$NVM_DIR/alias/$2"
      if [ ! "$3" = "$VERSION" ]; then
          echo "$2 -> $3 (-> $VERSION)"
      else
        echo "$2 -> $3"
      fi
    ;;
    "unalias" )
      mkdir -p $NVM_DIR/alias
      [ $# -ne 2 ] && nvm help && return
      [ ! -f $NVM_DIR/alias/$2 ] && echo "Alias $2 doesn't exist!" && return
      rm -f $NVM_DIR/alias/$2
      echo "Deleted alias $2"
    ;;
    "copy-packages" )
        if [ $# -ne 2 ]; then
          nvm help
          return
        fi
        VERSION=`nvm_version $2`
        ROOT=`nvm use $VERSION && npm -g root`
        INSTALLS=`nvm use $VERSION > /dev/null && npm -g -p ll | grep "$ROOT\/[^/]\+$" | cut -d '/' -f 8 | cut -d ":" -f 2 | grep -v npm | tr "\n" " "`
        npm install -g $INSTALLS
    ;;
    "clear-cache" )
        rm -f $NVM_DIR/v* 2>/dev/null
        echo "Cache cleared."
    ;;
    "version" )
        print_versions "`nvm_version $2`"
    ;;
    * )
      nvm help
    ;;
  esac
}

nvm ls default &>/dev/null && nvm use default >/dev/null || true
