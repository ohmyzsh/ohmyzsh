# React Native plugin

This plugin adds completion for [`react-native`](https://facebook.github.io/react-native/).
It also defines a few [aliases](#aliases) for the commands more frequently used.

To enable, add `react-native` to your `plugins` array in your zshrc file:

```zsh
plugins=(... react-native)
```

## Aliases

| Alias           | React Native command                                                       |
| :-------------- | :------------------------------------------------------------------------- |
| **rn**          | `react-native`                                                             |
| **rns**         | `react-native start`                                                       |
| **rnlink**      | `react-native link`                                                        |
| _Logging_       |                                                                            |
| **rnland**      | `react-native log-android`                                                 |
| **rnlios**      | `react-native log-ios`                                                     |
| _App Testing_   |                                                                            |
| **rnand**       | `react-native run-android`                                                 |
| **rnios**       | `react-native run-ios`                                                     |
| _iPhone_        |                                                                            |
| **rnios4s**     | `react-native run-ios --simulator "iPhone 4s"`                             |
| **rnios5**      | `react-native run-ios --simulator "iPhone 5"`                              |
| **rnios5s**     | `react-native run-ios --simulator "iPhone 5s"`                             |
| **rnios6**      | `react-native run-ios --simulator "iPhone 6"`                              |
| **rnios6s**     | `react-native run-ios --simulator "iPhone 6s"`                             |
| **rnios6p**     | `react-native run-ios --simulator "iPhone 6 Plus"`                         |
| **rnios6sp**    | `react-native run-ios --simulator "iPhone 6s Plus"`                        |
| **rnios7**      | `react-native run-ios --simulator "iPhone 7"`                              |
| **rnios7p**     | `react-native run-ios --simulator "iPhone 7 Plus"`                         |
| **rnios8**      | `react-native run-ios --simulator "iPhone 8"`                              |
| **rnios8p**     | `react-native run-ios --simulator "iPhone 8 Plus"`                         |
| **rniosse**     | `react-native run-ios --simulator "iPhone SE"`                             |
| **rniosx**      | `react-native run-ios --simulator "iPhone X"`                              |
| **rniosxs**     | `react-native run-ios --simulator "iPhone Xs"`                             |
| **rniosxsm**    | `react-native run-ios --simulator "iPhone Xs Max"`                         |
| **rniosxr**     | `react-native run-ios --simulator "iPhone Xʀ"`                             |
| **rnios11**     | `react-native run-ios --simulator "iPhone 11"`                             |
| **rnios11p**    | `react-native run-ios --simulator "iPhone 11 Pro"`                         |
| **rnios11pm**   | `react-native run-ios --simulator "iPhone 11 Pro Max"`                     |
| **rnios12**     | `react-native run-ios --simulator "iPhone 12"`                             |
| **rnios12m**    | `react-native run-ios --simulator "iPhone 12 mini"`                        |
| **rnios12p**    | `react-native run-ios --simulator "iPhone 12 Pro"`                         |
| **rnios12pm**   | `react-native run-ios --simulator "iPhone 12 Pro Max"`                     |
| **rnios13**     | `react-native run-ios --simulator "iPhone 13"`                             |
| **rnios13m**    | `react-native run-ios --simulator "iPhone 13 mini"`                        |
| **rnios13p**    | `react-native run-ios --simulator "iPhone 13 Pro"`                         |
| **rnios13pm**   | `react-native run-ios --simulator "iPhone 13 Pro Max"`                     |
| **rnios14**     | `react-native run-ios --simulator "iPhone 14"`                             |
| **rnios14pl**   | `react-native run-ios --simulator "iPhone 14 Plus"`                        |
| **rnios14p**    | `react-native run-ios --simulator "iPhone 14 Pro"`                         |
| **rnios14pm**   | `react-native run-ios --simulator "iPhone 14 Pro Max"`                     |
| **rnios15**     | `react-native run-ios --simulator "iPhone 15"`                             |
| **rnios15pl**   | `react-native run-ios --simulator "iPhone 15 Plus"`                        |
| **rnios15p**    | `react-native run-ios --simulator "iPhone 15 Pro"`                         |
| **rnios15pm**   | `react-native run-ios --simulator "iPhone 15 Pro Max"`                     |
| _iPad_          |                                                                            |
| **rnipad2**     | `react-native run-ios --simulator "iPad 2"`                                |
| **rnipad5**     | `react-native run-ios --simulator "iPad (5th generation)"`                 |
| **rnipad6**     | `react-native run-ios --simulator "iPad (6th generation)"`                 |
| **rnipadr**     | `react-native run-ios --simulator "iPad Retina"`                           |
| **rnipada**     | `react-native run-ios --simulator "iPad Air"`                              |
| **rnipada2**    | `react-native run-ios --simulator "iPad Air 2"`                            |
| **rnipada3**    | `react-native run-ios --simulator "iPad Air (3rd generation)"`             |
| **rnipadm2**    | `react-native run-ios --simulator "iPad mini 2"`                           |
| **rnipadm3**    | `react-native run-ios --simulator "iPad mini 3"`                           |
| **rnipadm4**    | `react-native run-ios --simulator "iPad mini 4"`                           |
| **rnipadm5**    | `react-native run-ios --simulator "iPad mini (5th generation)"`            |
| **rnipadp9**    | `react-native run-ios --simulator "iPad Pro (9.7-inch)"`                   |
| **rnipadp12**   | `react-native run-ios --simulator "iPad Pro (12.9-inch)"`                  |
| **rnipadp122**  | `react-native run-ios --simulator "iPad Pro (12.9-inch) (2nd generation)"` |
| **rnipadp10**   | `react-native run-ios --simulator "iPad Pro (10.5-inch)"`                  |
| **rnipad11**    | `react-native run-ios --simulator "iPad Pro (11-inch)"`                    |
| **rnipad123**   | `react-native run-ios --simulator "iPad Pro (12.9-inch) (3rd generation)"` |
| _Apple TV_      |                                                                            |
| **rnatv**       | `react-native run-ios --simulator "Apple TV"`                              |
| **rnatv4k**     | `react-native run-ios --simulator "Apple TV 4K"`                           |
| **rnatv4k1080** | `react-native run-ios --simulator "Apple TV 4K (at 1080p)"`                |
| **rnipad123**   | `react-native run-ios --simulator "iPad Pro (12.9-inch) (3rd generation)"` |
| _Apple Watch_   |                                                                            |
| **rnaw38**      | `react-native run-ios --simulator "Apple Watch - 38mm"`                    |
| **rnaw42**      | `react-native run-ios --simulator "Apple Watch - 42mm"`                    |
| **rnaws238**    | `react-native run-ios --simulator "Apple Watch Series 2 - 38mm"`           |
| **rnaws242**    | `react-native run-ios --simulator "Apple Watch Series 2 - 42mm"`           |
| **rnaws338**    | `react-native run-ios --simulator "Apple Watch Series 3 - 38mm"`           |
| **rnaws342**    | `react-native run-ios --simulator "Apple Watch Series 3 - 42mm"`           |
| **rnaws440**    | `react-native run-ios --simulator "Apple Watch Series 4 - 40mm"`           |
| **rnaws444**    | `react-native run-ios --simulator "Apple Watch Series 4 - 44mm"`           |
