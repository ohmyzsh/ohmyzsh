# web-search plugin

This plugin adds aliases for searching with Google, Wiki, Bing, YouTube and other popular services.

Open your `~/.zshrc` file and enable the `web-search` plugin:

```zsh
plugins=( ... web-search)
```

## Usage

You can use the `web-search` plugin in these two forms:

* `web_search <context> <term> [more terms if you want]`
* `<context> <term> [more terms if you want]`

For example, these two are equivalent:

```zsh
$ web_search google oh-my-zsh
$ google oh-my-zsh
```

Available search contexts are:

| Context               | URL                                      |
|-----------------------|------------------------------------------|
| `bing`                | `https://www.bing.com/search?q=`         |
| `google`              | `https://www.google.com/search?q=`       |
| `yahoo`               | `https://search.yahoo.com/search?p=`     |
| `ddg` or `duckduckgo` | `https://www.duckduckgo.com/?q=`         |
| `sp` or `startpage`   | `https://www.startpage.com/do/search?q=` |
| `yandex`              | `https://yandex.ru/yandsearch?text=`     |
| `github`              | `https://github.com/search?q=`           |
| `baidu`               | `https://www.baidu.com/s?wd=`            |
| `ecosia`              | `https://www.ecosia.org/search?q=`       |
| `goodreads`           | `https://www.goodreads.com/search?q=`    |
| `qwant`               | `https://www.qwant.com/?q=`              |
| `givero`              | `https://www.givero.com/search?q=`       |
| `stackoverflow`       | `https://stackoverflow.com/search?q=`    |
| `wolframalpha`        | `https://wolframalpha.com/input?i=`      |

Also there are aliases for bang-searching DuckDuckGo:

| Context   | Bang  |
|-----------|-------|
| `wiki`    | `!w`  |
| `news`    | `!n`  |
| `youtube` | `!yt` |
| `map`     | `!m`  |
| `image`   | `!i`  |
| `ducky`   | `!`   |
