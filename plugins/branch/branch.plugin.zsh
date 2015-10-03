# Branch: displays the current Git or Mercurial branch fast.
# Victor Torres <vpaivatorres@gmail.com>
# Oct 2, 2015

function branch_prompt_info() {
  # Defines path as current directory
  path=$(pwd)
  # While current path is not root path
  while [ $path != '/' ];
  do
    # Git repository
    if [ -d ${path}/.git ];
    then
      echo '±' $(/bin/cat ${path}/.git/HEAD | /usr/bin/cut -d / -f 3-)
      return;
    fi
    # Mercurial repository
    if [ -d ${path}/.hg ];
    then
      echo '☿' $(/bin/cat ${path}/.hg/branch)
      return;
    fi
    # Defines path as parent directory and keeps looking for :)
    path=$(/usr/bin/dirname $path)
  done
}
