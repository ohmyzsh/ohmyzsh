alias cjump="nvim $(mdfind -onlyin . -name 'main' | grep -A 1 /Users)"

alias clist="mdfind -onlyin . -interpret .cpp & mdfind -onlyin . -interpret .cc"

function cgen(){
  mkdir $1
  cd $1
  touch CMakeLists.txt
  cat ~/.oh-my-zsh/custom/plugins/cMaker/ListTemplate.txt >> CMakeLists.txt
  mkdir src
  cd src
  touch main.cpp
  cd ../..
}

function crun(){
  #VAR=${1:-.} 
  cd $1
  cmake .
  cmake --build .
}

function cbin(){
  cbuild CPP
  cat $1 >> CPP/src/main.cpp
  crun CPP
  mv cpc ../
  cd ..
  rm -r CPP
}

function cput(){
  mv $1/*(DN) $2/
}

function ccomp(){
  cbuild qwertyu
  cd qwertyu/src
  rm main.cpp
  cd ../..
  mv $1/*(DN) qwertyu/src/
  crun qwertyu
  mv cpc ../
  rm -r qwertyu
}

function ctemp(){
  open ~/.oh-my-zsh/custom/plugins/cMaker/ListTemplate.txt
}
