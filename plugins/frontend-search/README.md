## Rationale ##

The idea for this script is to help searches in important doc contents from frontend.

## Instalation ##

I will send a Pull Request with this plugin for .oh-my-zsh official repository. If accept them, it's only add in plugins list that exists in ```.zshrc``` file.

For now, you can clone this repository and add in ```custom/plugins``` folder

```bash
$ git clone git://github.com/willmendesneto/frontend-search.git ~/.oh-my-zsh/custom/plugins/frontend-search
```

After this, restart your terminal and frontend-search plugin is configurated in you CLI.

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

## Author

**Wilson Mendes (willmendesneto)**
+ <https://twitter.com/willmendesneto>
+ <http://github.com/willmendesneto>

New features comming soon.
