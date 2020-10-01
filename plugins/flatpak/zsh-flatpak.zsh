# List installed flatpaks
alias flatpaks='flatpak list --app'

# Show flatpak alias
alias fp-a='alias | grep "flatpak run"'
alias fp-alias=fp-a

# Install flatpaks
alias fp-in='flatpak install'
alias fp-inu='flatpak install --user'

# List installed flatpaks
alias fp-ls='flatpak list --app'
alias fp-lsu='flatpak list --app --user'

# Search flatpaks
alias fp-se='flatpak search'
alias fp-seu='flatpak search --user'

# Update flatpaks
alias fp-up='flatpak update'
alias fp-upu='flatpak update --user'

# Adds a single flatpak alias given the application name
flatpak_add_alias () {
	# Using Application name, extract the name and lowercase it
	local name=$(echo ${1:l} | grep -Po '[^\.]+$')

	# Alias the function
	alias $name="flatpak run $2 $1"
}

# Adds an alias for every install flatpak application
foreach app in $(flatpak list --columns=application --app) ; do
    flatpak_add_alias $app
; done

# Adds an alias for every user installed flatpak (overwriting all alias)
foreach app in $(flatpak list --columns=application --user --app) ; do
    flatpak_add_alias $app --user
; done
