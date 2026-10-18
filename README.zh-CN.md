<p align="center"><img src="https://ohmyzsh.s3.amazonaws.com/omz-ansi-github.png" alt="Oh My Zsh"></p>

<p align="center"><a href="./README.md"><b>English</b></a> | <b>简体中文</b></p>

Oh My Zsh 是一个开源、社区驱动的框架，用于管理你的 [zsh](https://www.zsh.org/) 配置。

听起来很无聊？那我们换个说法。

**Oh My Zsh 不会让你变成 10 倍效率的开发者……但你可能自我感觉像一个。**

一旦安装，你的终端 shell 就会成为全城话题——_不满意包退！_ 在命令提示符下每一次敲键，你都能受益于数百个强大的插件和精美的主题。咖啡馆里的陌生人会凑上来问你：_“太棒了！你是什么天才吗？”_

终于，你会开始收获你一直觉得受之无愧的关注。……或者，你也可以把省下来的时间用来更经常地使用牙线。😬

想了解更多，请访问 [ohmyz.sh](https://ohmyz.sh)，在 X（原 Twitter）上关注 [@ohmyzsh](https://x.com/ohmyzsh)，并加入我们的 [Discord](https://discord.gg/ohmyzsh)。

[![CI](https://github.com/ohmyzsh/ohmyzsh/workflows/CI/badge.svg)](https://github.com/ohmyzsh/ohmyzsh/actions?query=workflow%3ACI)
[![OpenSSF 最佳实践](https://www.bestpractices.dev/projects/10713/badge)](https://www.bestpractices.dev/projects/10713)
[![关注 X（原 Twitter）](https://img.shields.io/twitter/follow/ohmyzsh?label=%40ohmyzsh&logo=x&style=flat)](https://twitter.com/intent/follow?screen_name=ohmyzsh)
[![关注 Mastodon](https://img.shields.io/mastodon/follow/111169632522566717?label=%40ohmyzsh&domain=https%3A%2F%2Fmstdn.social&logo=mastodon&style=flat)](https://mstdn.social/@ohmyzsh)
[![Discord 服务器](https://img.shields.io/discord/642496866407284746)](https://discord.gg/ohmyzsh)

<a href="https://commitgoods.com/collections/oh-my-zsh?utm_source=github">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://cdn.shopify.com/s/files/1/0101/8752/files/commitgoods-badge-stacked-navy-dark.svg">
    <img src="https://cdn.shopify.com/s/files/1/0101/8752/files/commitgoods-badge-stacked-navy.svg" height="28" alt="commitgoods.com 官方周边">
  </picture>
</a>


<details>
<summary>目录</summary>

- [入门](#入门)
  - [操作系统兼容性](#操作系统兼容性)
  - [前置条件](#前置条件)
  - [基本安装](#基本安装)
    - [手动检查](#手动检查)
- [使用 Oh My Zsh](#使用-oh-my-zsh)
  - [插件](#插件)
    - [启用插件](#启用插件)
    - [使用插件](#使用插件)
  - [主题](#主题)
    - [选择主题](#选择主题)
  - [终端屏保](#终端屏保)
  - [常见问题](#常见问题)
- [高级话题](#高级话题)
  - [高级安装](#高级安装)
    - [自定义目录](#自定义目录)
    - [无人值守安装](#无人值守安装)
    - [从 Fork 的仓库安装](#从-fork-的仓库安装)
    - [手动安装](#手动安装)
  - [安装问题](#安装问题)
  - [自定义插件与主题](#自定义插件与主题)
  - [在 macOS 和 FreeBSD 系统中启用 GNU ls](#在-macos-和-freebsd-系统中启用-gnu-ls)
  - [跳过别名](#跳过别名)
  - [异步 git 提示符](#异步-git-提示符)
- [获取更新](#获取更新)
  - [更新详细程度](#更新详细程度)
  - [手动更新](#手动更新)
- [卸载 Oh My Zsh](#卸载-oh-my-zsh)
- [如何为 Oh My Zsh 做贡献？](#如何为-oh-my-zsh-做贡献)
  - [请勿发送主题](#请勿发送主题)
- [贡献者](#贡献者)
- [关注我们](#关注我们)
- [周边商品](#周边商品)
- [许可证](#许可证)
- [关于 Planet Argon](#关于-planet-argon)

</details>

## 入门

### 操作系统兼容性

| 操作系统       | 状态 |
| :------------- | :--: |
| Android        |  ✅  |
| FreeBSD        |  ✅  |
| LCARS          |  🛸  |
| Linux          |  ✅  |
| macOS          |  ✅  |
| OS/2 Warp      |  ❌  |
| Windows (WSL2) |  ✅  |

### 前置条件

- 需要安装 [Zsh](https://www.zsh.org)（v4.3.9 或更高版本即可，但我们推荐 5.0.8 及以上）。如果尚未预装（可运行 `zsh --version` 确认），请参阅以下 wiki 指南：[安装 ZSH](https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH)
- 需要安装 `curl` 或 `wget`
- 需要安装 `git`（推荐 v2.4.11 或更高版本）

### 基本安装

在终端中运行以下命令之一即可安装 Oh My Zsh。你可以通过命令行使用 `curl`、`wget` 或其他类似工具进行安装。

| 方式     | 命令                                                                                           |
| :------- | :-------------------------------------------------------------------------------------------- |
| **curl** | `sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"` |
| **wget** | `sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`   |
| **fetch** | `sh -c "$(fetch -o - https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"` |

此外，安装脚本在 GitHub 之外也有镜像。如果你所在的国家或地区（例如中国或印度的某些 ISP）屏蔽了 `raw.githubusercontent.com`，可能需要改用此 URL：

| 方式     | 命令                                           |
| :------- | :--------------------------------------------- |
| **curl** | `sh -c "$(curl -fsSL https://install.ohmyz.sh/)"` |
| **wget** | `sh -c "$(wget -O- https://install.ohmyz.sh/)"`   |
| **fetch** | `sh -c "$(fetch -o - https://install.ohmyz.sh/)"` |

_注意：任何已有的 `.zshrc` 都会被重命名为 `.zshrc.pre-oh-my-zsh`。安装完成后，你可以把想保留的配置迁移到新的 `.zshrc` 中。_

#### 手动检查

对于尚不了解的项目，先检查安装脚本是个好习惯。你可以先下载安装脚本，通读一遍确认没有问题，再运行：

```sh
wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
sh install.sh
```

如果上面的 URL 超时或因其他原因失败，你可能需要把 URL 换成 `https://install.ohmyz.sh` 才能获取脚本。

## 使用 Oh My Zsh

### 插件

Oh My Zsh 自带一大堆插件供你使用。你可以在 [plugins](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins) 目录和/或 [wiki](https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins) 中查看当前可用的插件。

#### 启用插件

一旦你发现想要使用的插件（一个或多个），就需要在 `.zshrc` 文件中启用它们。zshrc 文件位于你的 `$HOME` 目录下。用你喜欢的文本编辑器打开它，你会看到一个列出所有想加载的插件的地方。

```sh
vi ~/.zshrc
```

例如，它可能会变成这样：

```sh
plugins=(
  git
  bundler
  dotenv
  macos
  rake
  rbenv
  ruby
)
```

_注意：插件之间用空白字符（空格、制表符、换行……）分隔。**不要**使用逗号，否则会出错。_

#### 使用插件

每个内置插件都带有一个 **README** 来说明它。README 中会列出该插件添加的别名（如果有）以及其他附赠功能。

### 主题

我们承认：在 Oh My Zsh 的早期，我们可能有点“主题狂热”。目前内置的主题已超过一百五十款。它们中的大多数在 wiki 上都有[截图](https://github.com/ohmyzsh/ohmyzsh/wiki/Themes)（我们正在更新！）。快去看看吧！

#### 选择主题

_Robby 主题是默认主题。它不是最花哨的，也不是最简洁的，只是对他来说刚刚好。_

找到想用的主题后，你需要编辑 `~/.zshrc` 文件。你会看到一个全大写的环境变量，类似这样：

```sh
ZSH_THEME="robbyrussell"
```

想用其他主题，只需把值改成你想要的主题名称。例如：

```sh
ZSH_THEME="agnoster" # (this is one of the fancy ones)
# see https://github.com/ohmyzsh/ohmyzsh/wiki/Themes#agnoster
```

<!-- prettier-ignore-start -->
> [!NOTE]
> 你可能会多次遇到这种情况：看到某个 zsh 主题的截图，试用后却发现显示效果不一样。
>
> 这是因为许多主题需要安装 [Powerline 字体](https://github.com/powerline/fonts) 或 [Nerd 字体](https://github.com/ryanoasis/nerd-fonts) 才能正常渲染。没有这些字体，主题会显示出奇怪的提示符符号。更多信息请查看[常见问题](https://github.com/ohmyzsh/ohmyzsh/wiki/FAQ#i-have-a-weird-character-in-my-prompt)。
>
> 还要注意，主题只控制提示符（prompt）的外观，也就是光标前后你输入命令时看到的那段文字。主题不控制终端窗口的颜色（即_配色方案_）或终端字体，这些可以在终端模拟器中自行设置。更多信息请参阅[什么是 zsh 主题](https://github.com/ohmyzsh/ohmyzsh/wiki/FAQ#what-is-a-zsh-theme)。
<!-- prettier-ignore-end -->

打开一个新的终端窗口，你的提示符应该会变成类似这样：

![Agnoster 主题](https://cloud.githubusercontent.com/assets/2618447/6316862/70f58fb6-ba03-11e4-82c9-c083bf9a6574.png)

如果没找到适合你的主题，可以到 wiki 上看看[更多主题](https://github.com/ohmyzsh/ohmyzsh/wiki/External-themes)。

如果你想来点刺激的，可以让电脑每次打开新终端窗口时随机选一个主题。

```sh
ZSH_THEME="random" # (...please let it be pie... please be some pie..)
```

如果你想从收藏的主题列表中随机挑选：

```sh
ZSH_THEME_RANDOM_CANDIDATES=(
  "robbyrussell"
  "agnoster"
)
```

如果你只知道不喜欢哪些主题，也可以用类似的方式设置排除列表：

```sh
ZSH_THEME_RANDOM_IGNORED=(pygmalion tjkirch_mod)
```

### 终端屏保

用 `omz shellsaver` 给你的终端放个小假——这是我们给终端屏保起的俏皮名字。水族箱是默认场景，换个场景就能换种心情：

```zsh
omz shellsaver                 # A quiet aquarium full of sea shells
omz shellsaver logo            # The updater's rainbow logo, bouncing around
omz shellsaver hermit          # A slightly lost hermit crab
omz shellsaver party           # A rainbow stage and a dancing crowd
```

按任意键或 Ctrl-C 即可返回 shell。屏保只在被调用时运行，退出时会恢复终端原状，无需安装插件或修改配置。可以使用 `omz help` 了解该命令，并用 Tab 键补全场景名称和选项。

```zsh
omz shellsaver aquarium --seconds 30  # Stop automatically after 30 seconds
omz shellsaver logo --mono            # Use the terminal's foreground color
omz shellsaver --list                 # List scenes (aquarium is the default)
omz shellsaver --help                 # Show all scenes and options
```

需要 Zsh 5.8 或更高版本、`stty`，以及支持备用屏幕（alternate screen）的 xterm 兼容终端。无需额外的动画包，并会遵守 `NO_COLOR` 环境变量的设置。建议窗口至少 49 列 × 18 行。

### 常见问题

如果有其他问题或疑问，也许能在我们的[常见问题](https://github.com/ohmyzsh/ohmyzsh/wiki/FAQ)中找到答案。

## 高级话题

如果你是喜欢亲自动手折腾的人，这些章节可能会适合你。

### 高级安装

有些用户可能想手动安装 Oh My Zsh，或修改默认路径等安装脚本支持的参数（这些参数在安装脚本顶部也有说明）。

#### 自定义目录

默认安装位置是 `~/.oh-my-zsh`（位于你的主目录下，是隐藏目录，可通过 `cd ~/.oh-my-zsh` 进入）

如果想修改安装目录，可以在安装前运行 `export ZSH=/your/path`，或像下面这样在安装命令中设置 `ZSH` 环境变量：

```sh
ZSH="$HOME/.dotfiles/oh-my-zsh" sh install.sh
```

#### 无人值守安装

如果在自动化安装流程中运行 Oh My Zsh 安装脚本，可以给 `install.sh` 加上 `--unattended` 参数。这样它就不会尝试修改默认 shell，安装结束后也不会运行 `zsh`。

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
```

如果你在中国、印度或其他屏蔽 `raw.githubusercontent.com` 的国家/地区，可能需要将 URL 替换为 `https://install.ohmyz.sh` 才能安装。

#### 从 Fork 的仓库安装

安装脚本还支持以下变量，用于从其他仓库安装：

- `REPO`（默认值：`ohmyzsh/ohmyzsh`）：格式为 `owner/repository`。设置该变量后，安装脚本会从 `https://github.com/{owner}/{repository}` 查找仓库。

- `REMOTE`（默认值：`https://github.com/${REPO}.git`）：git 仓库克隆的完整 URL。如果想从非 GitHub 的 fork 安装（GitLab、Bitbucket……），或想用 SSH 而非 HTTPS 克隆（`git@github.com:user/project.git`），可以使用此设置。

  _注意：此设置与 `REPO` 变量不兼容，且优先级更高。_

- `BRANCH`（默认值：`master`）：用于修改克隆仓库时检出的默认分支。在测试 Pull Request 或想使用 `master` 以外的分支时很有用。

例如：

```sh
REPO=apjanke/oh-my-zsh BRANCH=edge sh install.sh
```

#### 手动安装

##### 1. 克隆仓库 <!-- omit in toc -->

```sh
git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
```

##### 2. _可选_，备份你现有的 `~/.zshrc` 文件 <!-- omit in toc -->

```sh
cp ~/.zshrc ~/.zshrc.orig
```

##### 3. 创建新的 zsh 配置文件 <!-- omit in toc -->

你可以通过复制我们提供的模板来创建新的 zsh 配置文件。

```sh
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
```

##### 4. 修改默认 shell <!-- omit in toc -->

```sh
chsh -s $(which zsh)
```

你需要注销并重新登录用户会话才能看到此更改。

##### 5. 初始化新的 zsh 配置 <!-- omit in toc -->

打开新的终端窗口后，它会自动加载 Oh My Zsh 的配置。

### 安装问题

如果安装过程中遇到问题，可以尝试以下几种常见的修复方法。

- 如果切换到 `oh-my-zsh` 后找不到某些命令，你可能需要修改 `~/.zshrc` 中的 `PATH`。
- 如果你是手动安装或修改过安装位置，请检查 `~/.zshrc` 中的 `ZSH` 环境变量。

### 自定义插件与主题

如果想覆盖任何默认行为，只需在 `custom/` 目录中添加一个新文件（以 `.zsh` 结尾）。

如果有很多相关的函数，可以把它们放到 `custom/plugins/` 目录下的 `XYZ.plugin.zsh` 文件中，然后启用该插件。

如果想覆盖 Oh My Zsh 内置插件的功能，可以在 `custom/plugins/` 目录中创建同名插件，它会取代 `plugins/` 目录中的版本被加载。

### 在 macOS 和 FreeBSD 系统中启用 GNU ls

<a name="enable-gnu-ls"></a>

Oh My Zsh 在 macOS 和 FreeBSD 系统中默认使用 BSD `ls`。如果安装了 GNU `ls`（即 `gls` 命令），可以选择改用它。方法是在 source `oh-my-zsh.sh` 之前使用基于 zstyle 的配置：

```zsh
zstyle ':omz:lib:theme-and-appearance' gnu-ls yes
```

_注意：此设置与 `DISABLE_LS_COLORS=true` 不兼容_

### 跳过别名

<a name="remove-directories-aliases"></a>

如果想跳过 Oh My Zsh 的默认别名（定义在 `lib/*` 文件中）或插件别名，可以在 `~/.zshrc` 中使用以下设置，且必须在 **Oh My Zsh 加载之前**。请注意，根据需求不同，跳过别名的方式有很多种。

```sh
# Skip all aliases, in lib files and enabled plugins
zstyle ':omz:*' aliases no

# Skip all aliases in lib files
zstyle ':omz:lib:*' aliases no
# Skip only aliases defined in the directories.zsh lib file
zstyle ':omz:lib:directories' aliases no

# Skip all plugin aliases
zstyle ':omz:plugins:*' aliases no
# Skip only the aliases from the git plugin
zstyle ':omz:plugins:git' aliases no
```

你可以根据需要组合使用这些设置，规则是更具体的作用域优先级更高：

```sh
# Skip all plugin aliases, except for the git plugin
zstyle ':omz:plugins:*' aliases no
zstyle ':omz:plugins:git' aliases yes
```

该功能的旧版本使用如下设置，现已移除：

```sh
zstyle ':omz:directories' aliases no
```

现在请改用以下设置：

```sh
zstyle ':omz:lib:directories' aliases no
```

#### 注意事项 <!-- omit in toc -->

> 该功能目前处于测试阶段，未来可能会调整。它目前还不兼容 zpm、zinit 等插件管理器，因为这些管理器不会 source 实现了该功能的初始化脚本（`oh-my-zsh.sh`）。

> 它目前也无法识别以函数形式定义的“别名”，例如 git 插件中的 `gccd`、`ggf`、`ggl` 函数。

### 异步 git 提示符

异步提示符函数是一项实验性功能（于 2024 年 4 月 3 日加入），允许 Oh My Zsh 异步渲染提示符信息。这可以提升提示符的渲染性能，但在某些环境下可能无法正常工作。如果该功能遇到了问题，你可以在 .zshrc 中（Oh My Zsh 加载之前）进行如下设置将其关闭：

```sh
zstyle ':omz:alpha:lib:git' async-prompt no
```

如果遇到的问题是 git 提示符突然不显示了，可以尝试在 `oh-my-zsh.sh` 加载之前进行如下设置来强制启用。如果仍然无效，请提交 issue 并说明你的情况。

```sh
zstyle ':omz:alpha:lib:git' async-prompt force
```

## 获取更新

默认情况下，Oh My Zsh 每 2 周会提示检查更新。你可以在 `~/.zshrc` 中添加一行配置（必须在 **Oh My Zsh 加载之前**）来选择其他更新模式：

1. 自动更新，无需确认：

   ```sh
   zstyle ':omz:update' mode auto
   ```

2. 有更新时每隔几天提醒一次：

   ```sh
   zstyle ':omz:update' mode reminder
   ```

3. 完全禁用自动更新：

   ```sh
   zstyle ':omz:update' mode disabled
   ```

注意：你还可以通过以下设置控制检查更新的频率：

```sh
# This will check for updates every 7 days
zstyle ':omz:update' frequency 7
# This will check for updates every time you open the terminal (not recommended)
zstyle ':omz:update' frequency 0
```

默认情况下，更新总是拉取最新更改。如果你想让别人先试试水，再让更新到达你的机器，可以设置一个冷却期（单位：天）。你最终仍会获得所有更新——只是稍晚一点：

```sh
# Only apply updates that are at least 10 days old
zstyle ':omz:update' cooldown 10
```

`omz update` 会遵循此设置。如果直接调用 `upgrade.sh`，请用 `-c` 传入相同的值，因为该脚本不读取你的 `.zshrc`：

```sh
$ZSH/tools/upgrade.sh -c 10
```

### 更新详细程度

你还可以通过以下设置限制更新时的输出详细程度：

```sh
zstyle ':omz:update' verbose default # default update prompt

zstyle ':omz:update' verbose minimal # only few lines

zstyle ':omz:update' verbose silent # only errors
```

### 手动更新

想随时更新（比如有人刚发布了新插件，你不想等一周），只需运行：

```sh
omz update
```

> [!NOTE]
> 如果想在脚本中自动化此过程，应直接调用 `upgrade` 脚本，如下所示：
>
> ```sh
> $ZSH/tools/upgrade.sh
> ```
>
> 更多选项请参阅[常见问题：如何更新 Oh My Zsh？](https://github.com/ohmyzsh/ohmyzsh/wiki/FAQ#how-do-i-update-oh-my-zsh)。
>
> **`omz update --unattended` 用法已被移除，因为它有副作用**。

神奇！🎉

## 卸载 Oh My Zsh

Oh My Zsh 并不适合所有人。我们会想你的，但也希望这次“分手”能好聚好散。

想卸载 `oh-my-zsh`，只需在命令行运行 `uninstall_oh_my_zsh`。它会自行删除，并恢复你之前的 `bash` 或 `zsh` 配置。

## 如何为 Oh My Zsh 做贡献？

在加入我们愉快的社区之前，请先阅读[行为准则](CODE_OF_CONDUCT.md)。

我远算不上 [Zsh](https://www.zsh.org/) 专家，相信还有很大的改进空间——如果你有让配置更易维护（也更快）的想法，别犹豫，fork 并发起 pull request 吧！

我们也需要人来测试 pull request。欢迎浏览[开放的 issue](https://github.com/ohmyzsh/ohmyzsh/issues)，尽力提供帮助。

更多详情请参阅[贡献指南](CONTRIBUTING.md)。

### 请勿发送主题

目前我们的主题已经（绰绰）有余。请把你的主题添加到 wiki 的[外部主题](https://github.com/ohmyzsh/ohmyzsh/wiki/External-themes)页面。

## 贡献者

Oh My Zsh 拥有充满活力的社区、快乐的用户和出色的贡献者。没有贡献者们投入的时间和帮助，就不会有如此了不起的 Oh My Zsh。

非常感谢！

<a href="https://github.com/ohmyzsh/ohmyzsh/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=ohmyzsh/ohmyzsh" width="100%"/>
</a>

## 关注我们

我们在社交媒体上：

- 在 X（原 Twitter）上关注 [@ohmyzsh](https://x.com/ohmyzsh)，你应该关注他。
- 在 [Facebook](https://www.facebook.com/Oh-My-Zsh-296616263819290/) 上戳我们。
- 在 [Instagram](https://www.instagram.com/_ohmyzsh/) 发帖展示 Oh My Zsh 时记得 @我们！
- 来 [Discord](https://discord.gg/ohmyzsh) 找我们聊天！

## 周边商品

我们有[贴纸、T 恤和咖啡杯](https://commitgoods.com/collections/oh-my-zsh?utm_source=github)供你选购，用来炫耀你对 Oh My Zsh 的热爱。再说一次，你会成为全城话题的！

## 许可证

Oh My Zsh 基于 [MIT 许可证](LICENSE.txt) 发布。

## 关于 Planet Argon

![Planet Argon](https://pa-github-assets.s3.amazonaws.com/PARGON_logo_digital_COL-small.jpg)

Oh My Zsh 由 [Planet Argon](https://www.planetargon.com/?utm_source=github) 团队发起，这是一家 [Ruby on Rails 开发公司](https://www.planetargon.com/services/ruby-on-rails-development?utm_source=github)。欢迎查看我们的[其他开源项目](https://www.planetargon.com/open-source?utm_source=github)。
