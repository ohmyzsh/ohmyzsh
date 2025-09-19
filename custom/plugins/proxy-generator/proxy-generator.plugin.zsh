for file in ${0:A:h}/*.zsh(.N); do
  source "$file"
done
