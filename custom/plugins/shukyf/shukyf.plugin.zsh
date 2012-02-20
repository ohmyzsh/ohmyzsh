c() { cd ~/code/$1;  }

_c() { _files -W ~/code -/; }
compdef _c c




b() { cd ~/code/biokm/$1;  }

_b() { _files -W ~/code/biokm -/; }
compdef _b b