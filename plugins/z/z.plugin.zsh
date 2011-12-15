. `brew --prefix`/etc/profile.d/z.sh

 function precmd () {
     z --add "$(pwd -P)"
 }
