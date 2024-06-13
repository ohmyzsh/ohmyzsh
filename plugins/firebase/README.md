## Firebase plugin

The Firebase plugin provides useful aliases for the [Firebase CLI](https://firebase.google.com/docs/cli).

To use it, add firebase to the plugins array of your zshrc file:

```
plugins=(... firebase)
```

## Aliases

Reference: https://firebase.google.com/docs/cli#admin-commands

### fbi: [firebase init](https://firebase.google.com/docs/cli#initialize_a_firebase_project)



| Alias | Command                                    | Description                  |
| :---- | :----------------------------------------- | :--------------------------- |
| fbi   | `firebase init`                        | Initialize a Firebase project             |

### fbi: [firebase use](https://firebase.google.com/docs/cli#add_alias)

| Alias | Command                                    | Description                  |
| :---- | :----------------------------------------- | :--------------------------- |
| fbu   | `firebase use`                        | Use a firebase project             |
| fbua   | `firebase use -add`                        | Add and use a firebase project             |

### fbs: [firebase serve](https://firebase.google.com/docs/cli#test-locally)

| Alias | Command                                    | Description                  |
| :---- | :----------------------------------------- | :--------------------------- |
| fbs   | `firebase serve`                        | Serve a Firebase project locally             |
| fbs0   | `firebase serve --host 0.0.0.0`                        | Serve a Firebase projeczt on 0.0.0.0             |
| fbsh   | `firebase serve --only hosting`                        | Serve a Firebase project locally (Only Hosting)             |
| fbsf   | `firebase serve --only functions`                        | Serve a Firebase project locally (only Functions)             |

#### fbd [firebase deploy](https://firebase.google.com/docs/cli#partial_deploys)

| Alias | Command                                    | Description                  |
| :---- | :----------------------------------------- | :--------------------------- |
| fbd   | `firebase deploy`                        | Deploy Firebase (Complete)             |
| fbdh   | `firebase deploy --only hosting`                        | Deploy Firebase Hosting             |
| fbdd   | `firebase deploy --only database`                        | Deploy Firebase Realtime Database             |
| fbds   | `firebase deploy --only storage`                        | Deploy Firebase Storage             |
| fbdfs   | `firebase deploy --only firestore`                        | Deploy Firebase Firestore             |
| fbdfsr   | `firebase deploy --only firestore:rules`                        | Deploy Firebase Firestore (only Rules)             |
| fbdfsi   | `firebase deploy --only firestore:indexes`                        | Deploy Firebase Firestore (only Indexes)             |
| fbdfu   | `firebase deploy --only functions`                        | Deploy Firebase Functions             |

#### fbf - [firebase functions](https://firebase.google.com/docs/cli#delete_functions)

| Alias | Command                                    | Description                  |
| :---- | :----------------------------------------- | :--------------------------- |
| fbfd   | `firebase functions:delete`                        | Delete Firebase Function             |

#### fb... - Misc

| Alias | Command                                    | Description                  |
| :---- | :----------------------------------------- | :--------------------------- |
| fbp   | `firebase projects:list`                        | List all projects             |