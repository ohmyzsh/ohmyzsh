#!/usr/bin/env bash

function atlas_usage {
  cat <<-USAGE

    usage: atlas command [map name]

      new     Create new hosts map file
      init    Create ~/.hosts to store host maps in
      map     link /etc/hosts to map supplying map name


USAGE
}

function atlas_new {
  if [ -z "$1" ]; then
    echo "need a name of new map";
  else
    if [[ -e "/Users/nstilwell/.hosts/template" ]]; then
      cp /Users/nstilwell/.hosts/template ~/.hosts/$1;
    else
      touch ~/.hosts/$1;
    fi
    echo "Created $1 at ~/.hosts/$1";
  fi
}

function atlas_init {
  if [ ! -d "/Users/nstilwell/.hosts" ]; then
    mkdir /Users/nstilwell/.hosts;
  fi

  echo "Atlas initialized";
}

function atlas_map {
  if [ -d "/Users/nstilwell/.hosts" ] && [ -e "/Users/nstilwell/.hosts/$1" ]; then
    sudo ln -f /Users/nstilwell/.hosts/$1 /etc/hosts;
    echo "mapped ~/.hosts/$1 to /etc/hosts";
  else
    echo "$1 doesn't exist at ~/.hosts/$1";
  fi
}

function atlas {
  if [ -z "$1" ]; then
    atlas_usage;
  else
    [ "$1" = "new" ] && atlas_new "$2";
    [ "$1" = "init" ] && atlas_init;
    [ "$1" = "map" ] && atlas_map "$2";
  fi
}
