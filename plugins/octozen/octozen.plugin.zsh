# octozen plugin

# Displays a zen from octocat 
#
function display_octozen() {
  curl -m 2 -fsL "https://api.github.com/octocat"
}

display_octozen
