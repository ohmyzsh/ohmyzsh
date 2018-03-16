# React Native plugin

This plugin adds completion for [`react-native`](https://facebook.github.io/react-native/).
It also defines a few [aliases](#aliases) for the commands more frequently used.

To enable, add `react-native` to your `plugins` array in your zshrc file:

```zsh
plugins=(... react-native)
```

## Aliases

| Alias       | React Native command                           |
|:------------|:-----------------------------------------------|
| **rn**      | `react-native`                                 |
| **rns**     | `react-native start`                           |
| **rnlink**  | `react-native link`                            |
| _App testing_                                                |
| **rnand**   | `react-native run-android`                     |
| **rnios**   | `react-native run-ios`                         |
| **rnios4s** | `react-native run-ios --simulator "iPhone 4s"` |
| **rnios5**  | `react-native run-ios --simulator "iPhone 5"`  |
| **rnios5s** | `react-native run-ios --simulator "iPhone 5s"` |
| **rnios6**  | `react-native run-ios --simulator "iPhone 6"`  |
| **rnios6s** | `react-native run-ios --simulator "iPhone 6s"` |
| _Logging_                                                    |
| **rnland**  | `react-native log-android`                     |
| **rnlios**  | `react-native log-ios`                         |
