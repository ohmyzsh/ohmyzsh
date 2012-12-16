c() { cd ~/code/$1;  }

_c() { _files -W ~/code -/; }
compdef _c c




b() { cd ~/code/biokm/$1;  }

_b() { _files -W ~/code/biokm -/; }
compdef _b b




p() { cd ~/private_projects/$1;  }

_p() { _files -W ~/private_projects -/; }
compdef _p p


alias gmf='git merge --no-ff'
compdef _git gmf=git-merge--no-ff