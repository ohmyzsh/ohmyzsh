## Introduction ##

> Searches for your frontend web development made easier


## Installation ##

Open your `~/.zshrc` file and enable the `frontend-search` plugin:

```zsh

plugins=( ... frontend-search)

```


## Usage ##

You can use the frontend-search plugin in these two forms:

* `frontend <context> <term> [more terms if you want]`
* `<context> <term> [more terms if you want]`

For example, these two are equivalent:

```zsh
$ frontend angularjs dependency injection
$ angularjs dependency injection
```

Available search contexts are:

| context       | URL                                                                      |
|---------------|--------------------------------------------------------------------------|
| angularjs     | `https://google.com/search?as_sitesearch=angularjs.org&as_q=`            |
| aurajs        | `http://aurajs.com/api/#stq=`                                            |
| bem           | `https://google.com/search?as_sitesearch=bem.info&as_q=`                 |
| bootsnipp     | `http://bootsnipp.com/search?q=`                                         |
| caniuse       | `http://caniuse.com/#search=`                                            |
| codepen       | `http://codepen.io/search?q=`                                            |
| compass       | `http://compass-style.org/search?q=`                                     |
| cssflow       | `http://www.cssflow.com/search?q=`                                       |
| dartlang      | `https://api.dartlang.org/apidocs/channels/stable/dartdoc-viewer/dart:`  |
| emberjs       | `http://emberjs.com/api/#stp=1&stq=`                                     |
| fontello      | `http://fontello.com/#search=`                                           |
| html5please   | `http://html5please.com/#`                                               |
| jquery        | `https://api.jquery.com/?s=`                                             |
| lodash        | `https://devdocs.io/lodash/index#`                                       |
| mdn           | `https://developer.mozilla.org/search?q=`                                |
| npmjs         | `https://www.npmjs.com/search?q=`                                        |
| qunit         | `https://api.qunitjs.com/?s=`                                            |
| reactjs       | `https://google.com/search?as_sitesearch=facebook.github.io/react&as_q=` |
| smacss        | `https://google.com/search?as_sitesearch=smacss.com&as_q=`               |
| stackoverflow | `http://stackoverflow.com/search?q=`                                     |
| unheap        | `http://www.unheap.com/?s=`                                              |

If you want to have another context, open an Issue and tell us!


## Author

**Wilson Mendes (willmendesneto)**
+ <https://plus.google.com/+WilsonMendes>
+ <https://twitter.com/willmendesneto>
+ <http://github.com/willmendesneto>
