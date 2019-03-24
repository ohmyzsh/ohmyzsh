# React Native plugin

This plugin adds completion for [`react-native`](https://facebook.github.io/react-native/).
It also defines a few [aliases](#aliases) for the commands more frequently used.

To enable, add `react-native` to your `plugins` array in your zshrc file:

```zsh
plugins=(... react-native)
```

## Aliases

| Alias          | React Native command                                                         |
| :------------  | :-------------------------------------------------                           |
| **rn**         | `react-native`                                                               |
| **rns**        | `react-native start`                                                         |
| **rnlink**     | `react-native link`                                                          |
| _App testing_  |
| **rnand**      | `react-native run-android`                                                   |
| **rnios**      | `react-native run-ios`                                                       |
| **rnios4s**    | `react-native run-ios --simulator "iPhone 4s"`                               |
| **rnios5**     | `react-native run-ios --simulator "iPhone 5"`                                |
| **rnios5s**    | `react-native run-ios --simulator "iPhone 5s"`                               |
| **rnios6**     | `react-native run-ios --simulator "iPhone 6"`                                |
| **rnios6s**    | `react-native run-ios --simulator "iPhone 6s"`                               |
| **rnios7**     | `react-native run-ios --simulator "iPhone7"`                                 |
| **rnios7p**    | `react-native run-ios --simulator "iPhone 7 Plus"`                           |
| **rnios8**     | `react-native run-ios --simulator "iPhone 8"`                                |
| **rnios8p**    | `react-native run-ios --simulator "iPhone 8 Plus"`                           |
| **rniosse**    | `react-native run-ios --simulator "iPhone SE"`                               |
| **rniosx**     | `react-native run-ios --simulator "iPhone X"`                                |
| **rniosxs**    | `react-native run-ios --simulator "iPhone XS"`                               |
| **rniosxsm**   | `react-native run-ios --simulator "iPhone XS Max"`                           |
| **rniosxr**    | `react-native run-ios --simulator "iPhone XR"`                               |
| _iPads_        |                                                                              |
| **rnipad2**    | `react-native run-ios --simulator "iPad 2"`                                  |
| **rnipadr**    | `react-native run-ios --simulator "iPad Retina"`                             |
| **rnipada**    | 'react-native run-ios --simulator "iPad Air"'                                |
| **rnipada2**   | 'react-native run-ios --simulator "iPad Air 2"'                              |
| **rnipad5**    | 'react-native run-ios --simulator "iPad (5th generation)"'                   |
| **rnipad9**    | 'react-native run-ios --simulator "iPad Pro (9.7-inch)"'                     |
| **rnipad12**   | 'react-native run-ios --simulator "iPad Pro (12.9-inch)"'                    |
| **rnipad122**  | 'react-native run-ios --simulator "iPad Pro (12.9-inch) (2nd generation)"'   |
| **rnipad10**   | 'react-native run-ios --simulator "iPad Pro (10.5-inch)"'                    |
| **rnipad6**    | 'react-native run-ios --simulator "iPad Pro (6th generation)"'               |
| **rnipad11**   | 'react-native run-ios --simulator "iPad Pro (11-inch)"'                      |
| **rnipad123**  | 'react-native run-ios --simulator "iPad Pro (12.9-inch) (3rd generation)"'   |
| _Apple TVs_    |                                                                              |
| **rnatv**      | `react-native run-ios --simulator "Apple TV"`                                |
| **rnatv4k**    | `react-native run-ios --simulator "Apple TV 4K"`                             |
| **rnatv4k1080**| `react-native run-ios --simulator "Apple TV 4K (at 1080p)"`                  |
| _Logging_      |
| **rnland**     | `react-native log-android`                                                   |
| **rnlios**     | `react-native log-ios`                                                       |
