alias cloudapp="${0:a:h}/cloudapp.rb"

# Ensure only the owner can access the credentials file
if [[ -f ~/.cloudapp ]]; then
  chmod 600 ~/.cloudapp
fi
