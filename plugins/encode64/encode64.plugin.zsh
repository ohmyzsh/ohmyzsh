encode64(){ echo -n $1 | base64 }
decode64(){ echo -n $1 | base64 --decode }
alias e64=encode64
alias d64=decode64
