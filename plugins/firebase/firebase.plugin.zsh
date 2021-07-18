## Aliases

# https://firebase.google.com/docs/cli#admin-commands
# Only implemented often used commands.

# INIT (fbi) - https://firebase.google.com/docs/cli#initialize_a_firebase_project
alias fbi="firebase init"

# USE (fbu) - https://firebase.google.com/docs/cli#add_alias
alias fbu="firebase use"
alias fbua="firebase use -add"

# SERVE (fbs) - https://firebase.google.com/docs/cli#test-locally
alias fbs="firebase serve"
alias fbs0="firebase serve --host 0.0.0.0"
alias fbsh="firebase serve --only hosting"
alias fbsf="firebase serve --only functions"

# DEPLOY (gbd) - https://firebase.google.com/docs/cli#partial_deploys
alias fbd="firebase deploy"
alias fbdh="firebase deploy --only hosting"
alias fbdd="firebase deploy --only database"
alias fbds="firebase deploy --only storage"
alias fbdfs="firebase deploy --only firestore"
alias fbdfsr="firebase deploy --only firestore:rules"
alias fbdfsi="firebase deploy --only firestore:indexes"
alias fbdfu="firebase deploy --only functions"

# FUNCTIONS (fbf) - https://firebase.google.com/docs/cli#delete_functions
alias fbfd="firebase functions:delete"

# MISC (fb..)
alias fbp="firebase projects:list"