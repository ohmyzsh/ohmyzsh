encode64(){ echo -n $1 | base64 }
decode64(){ echo -n $1 | base64 -D }