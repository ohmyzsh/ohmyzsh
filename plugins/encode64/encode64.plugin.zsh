encode64(){ printf '%s' $1 | base64 }
decode64(){ printf '%s' $1 | base64 --decode }
alias e64=encode64
alias d64=decode64
