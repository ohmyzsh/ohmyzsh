<<<<<<< HEAD
## Rationale ##

> Searches for your Frontend contents more easier


## Instalation ##


Open your `.zshrc` file and load `frontend-search` plugin

```bash
...
plugins=( <your-plugins-list>... frontend-search)
...
```


## Commands ##

All command searches are accept only in format

* `frontend <search-content> <search-term>`

The search content are

* `jquery <api.jquery.com>`
* `mdn <developer.mozilla.org>`
* `compass <compass-style.org>`
* `html5please <html5please.com>`
* `caniuse <caniuse.com>`
* `aurajs <aurajs.com>`
* `dartlang <api.dartlang.org/apidocs/channels/stable/dartdoc-viewer>`
* `lodash <search>`
* `qunit <api.qunitjs.com>`
* `fontello <fontello.com>`
* `bootsnipp <bootsnipp.com>`
* `cssflow <cssflow.com>`
* `codepen <codepen.io>`
* `unheap <www.unheap.com>`
* `bem <google.com/search?as_q=<search-term>&as_sitesearch=bem.info>`
* `smacss <google.com/search?as_q=<search-term>&as_sitesearch=smacss.com>`
* `angularjs <google.com/search?as_q=<search-term>&as_sitesearch=angularjs.org>`
* `reactjs <google.com/search?as_q=<search-term>&as_sitesearch=facebook.github.io/react>`
* `emberjs <emberjs.com>`
* `stackoverflow <stackoverflow.com>`


## Aliases ##

There are a few aliases presented as well:

* `jquery` A shorthand for `frontend jquery`
* `mdn` A shorthand for `frontend mdn`
* `compass` A shorthand for `frontend compass`
* `html5please` A shorthand for `frontend html5please`
* `caniuse` A shorthand for `frontend caniuse`
* `aurajs` A shorthand for `frontend aurajs`
* `dartlang` A shorthand for `frontend dartlang`
* `lodash` A shorthand for `frontend lodash`
* `qunit` A shorthand for `frontend qunit`
* `fontello` A shorthand for `frontend fontello`
* `bootsnipp` A shorthand for `frontend bootsnipp`
* `cssflow` A shorthand for `frontend cssflow`
* `codepen` A shorthand for `frontend codepen`
* `unheap` A shorthand for `frontend unheap`
* `bem` A shorthand for `frontend bem`
* `smacss` A shorthand for `frontend smacss`
* `angularjs` A shorthand for `frontend angularjs`
* `reactjs` A shorthand for `frontend reactjs`
* `emberjs` A shorthand for `frontend emberjs`
* `stackoverflow` A shorthand for `frontend stackoverflow`

=======
## Introduction

> Searches for your frontend web development made easier

## Installation

Open your `~/.zshrc` file and enable the `frontend-search` plugin:

```zsh

plugins=( ... frontend-search)

```

## Usage

You can use the frontend-search plugin in these two forms:

- `frontend <context> <term> [more terms if you want]`
- `<context> <term> [more terms if you want]`

For example, these two are equivalent:

```zsh
$ angular dependency injection
# Will turn into ...
$ frontend angular dependency injection
```

Available search contexts are:

| context       | URL                                                                         |
| ------------- | --------------------------------------------------------------------------- |
| angular       | `https://angular.io/?search=`                                               |
| angularjs     | `https://google.com/search?as_sitesearch=angularjs.org&as_q=`               |
| bem           | `https://google.com/search?as_sitesearch=bem.info&as_q=`                    |
| bootsnipp     | `https://bootsnipp.com/search?q=`                                           |
| bundlephobia  | `https://bundlephobia.com/result?p=`                                        |
| caniuse       | `https://caniuse.com/#search=`                                              |
| codepen       | `https://codepen.io/search?q=`                                              |
| compassdoc    | `http://compass-style.org/search?q=`                                        |
| cssflow       | `http://www.cssflow.com/search?q=`                                          |
| dartlang      | `https://api.dartlang.org/apidocs/channels/stable/dartdoc-viewer/dart:`     |
| emberjs       | `https://www.google.com/search?as_sitesearch=emberjs.com/&as_q=`            |
| flowtype      | `https://google.com/search?as_sitesearch=flow.org/en/docs/&as_q=`           |
| fontello      | `http://fontello.com/#search=`                                              |
| github        | `https://github.com/search?q=`                                              |
| html5please   | `https://html5please.com/#`                                                 |
| jestjs        | `https://www.google.com/search?as_sitesearch=jestjs.io&as_q=`               |
| jquery        | `https://api.jquery.com/?s=`                                                |
| lodash        | `https://devdocs.io/lodash/index#`                                          |
| mdn           | `https://developer.mozilla.org/search?q=`                                   |
| nodejs        | `https://www.google.com/search?as_sitesearch=nodejs.org/en/docs/&as_q=`     |
| npmjs         | `https://www.npmjs.com/search?q=`                                           |
| packagephobia | `https://packagephobia.now.sh/result?p=`                                    |
| qunit         | `https://api.qunitjs.com/?s=`                                               |
| reactjs       | `https://google.com/search?as_sitesearch=facebook.github.io/react&as_q=`    |
| smacss        | `https://google.com/search?as_sitesearch=smacss.com&as_q=`                  |
| stackoverflow | `https://stackoverflow.com/search?q=`                                       |
| typescript    | `https://google.com/search?as_sitesearch=www.typescriptlang.org/docs&as_q=` |
| unheap        | `http://www.unheap.com/?s=`                                                 |
| vuejs         | `https://www.google.com/search?as_sitesearch=vuejs.org&as_q=`               |

If you want to have another context, open an Issue and tell us!

## Fallback search behaviour

The plugin will use Google as a fallback if the docs site for a search context does not have a search function. You can set the fallback search engine to DuckDuckGo by setting  `FRONTEND_SEARCH_FALLBACK='duckduckgo'` in your `~/.zshrc` file before Oh My Zsh is sourced.
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b

## Author

**Wilson Mendes (willmendesneto)**
<<<<<<< HEAD
+ <https://plus.google.com/+WilsonMendes>
+ <https://twitter.com/willmendesneto>
+ <http://github.com/willmendesneto>

New features comming soon.
=======

- <https://twitter.com/willmendesneto>
- <https://github.com/willmendesneto>
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
