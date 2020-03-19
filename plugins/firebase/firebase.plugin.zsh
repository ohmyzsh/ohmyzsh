## Aliases

# https://firebase.google.com/docs/cli#admin-commands
# Only implemented often used commands.

# INIT (FBI) - https://firebase.google.com/docs/cli#initialize_a_firebase_project
alias fbi="firebase init"                               # Initialize a Firebase project

# USE (FBU) - https://firebase.google.com/docs/cli#add_alias
alias fbu="firebase use"                                # Use a firebase project
alias fbua="firebase use -add"                          # Add and use a firebase project

# SERVE (FBS) - https://firebase.google.com/docs/cli#test-locally
alias fbs="firebase serve"                              # Serve a Firebase project locally
alias fbs0="firebase serve --host 0.0.0.0"              # Serve a Firebase projeczt on 0.0.0.0
alias fbsh="firebase serve --only hosting"              # Serve a Firebase project locally ()
alias fbsf="firebase serve --only functions"            # Serve a Firebase project locally ()

# DEPLOY (FBD) - https://firebase.google.com/docs/cli#partial_deploys
alias fbd="firebase deploy"                             # Deploy Firebase (Complete)
alias fbdh="firebase deploy --only hosting"             # Deploy Firebase Hosting
alias fbdd="firebase deploy --only database"            # Deploy Firebase Realtime Database
alias fbds="firebase deploy --only storage"             # Deploy Firebase Storage
alias fbdfs="firebase deploy --only firestore"          # Deploy Firebase Firestore
alias fbdfsr="firebase deploy --only firestore:rules"   # Deploy Firebase Firestore (only Rules)
alias fbdfsi="firebase deploy --only firestore:indexes" # Deploy Firebase Firestore (only Indexes)
alias fbdfu="firebase deploy --only functions"          # Deploy Firebase Functions

# FUNCTIONS (FBF) - https://firebase.google.com/docs/cli#delete_functions
alias fbfd="firebase functions:delete"                  # Delete Firebase Function

# MISC (FBx)
alias fbp="firebase projects:list"                      # List all projects