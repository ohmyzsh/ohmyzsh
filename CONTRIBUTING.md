# CONTRIBUTING GUIDELINES

Oh-My-Zsh is a community-driven project. Contribution is welcome, encouraged, and appreciated.
It is also essential for the development of the project.

First, please take a moment to review our [code of conduct](CODE_OF_CONDUCT.md).

These guidelines are an attempt at better addressing the huge amount of pending
issues and pull requests. Please read them closely.

Foremost, be so kind as to [search](#use-the-search-luke). This ensures any contribution
you would make is not already covered.

<!-- TOC updateonsave:true depthfrom:2 -->

- [Reporting Issues](#reporting-issues)
  - [You have a problem](#you-have-a-problem)
  - [You have a suggestion](#you-have-a-suggestion)
- [Submitting Pull Requests](#submitting-pull-requests)
  - [Getting started](#getting-started)
  - [You have a solution](#you-have-a-solution)
  - [You have an addition](#you-have-an-addition)
- [Use the Search, Luke](#use-the-search-luke)
- [Commit Guidelines](#commit-guidelines)
  - [Format](#format)
  - [Style](#style)
- [Volunteer](#volunteer)

<!-- /TOC -->

## Reporting Issues

### You have a problem

Please be so kind as to [search](#use-the-search-luke) for any open issue already covering
your problem.

If you find one, comment on it, so we know more people are experiencing it.

If not, look at the [Troubleshooting](https://github.com/ohmyzsh/ohmyzsh/wiki/Troubleshooting)
page for instructions on how to gather data to better debug your problem.

Then, you can go ahead and create an issue with as much detail as you can provide.
It should include the data gathered as indicated above, along with the following:

1. How to reproduce the problem
2. What the correct behavior should be
3. What the actual behavior is

Please copy to anyone relevant (e.g. plugin maintainers) by mentioning their GitHub handle
(starting with `@`) in your message.

We will do our very best to help you.

### You have a suggestion

Please be so kind as to [search](#use-the-search-luke) for any open issue already covering
your suggestion.

If you find one, comment on it, so we know more people are supporting it.

If not, you can go ahead and create an issue. Please copy to anyone relevant (e.g. plugin
maintainers) by mentioning their GitHub handle (starting with `@`) in your message.

## Submitting Pull Requests

### Getting started

You should be familiar with the basics of
[contributing on GitHub](https://help.github.com/articles/using-pull-requests) and have a fork
[properly set up](https://github.com/ohmyzsh/ohmyzsh/wiki/Contribution-Technical-Practices).

You MUST always create PRs with _a dedicated branch_ based on the latest upstream tree.

If you create your own PR, please make sure you do it right. Also be so kind as to reference
any issue that would be solved in the PR description body,
[for instance](https://help.github.com/articles/closing-issues-via-commit-messages/)
_"Fixes #XXXX"_ for issue number XXXX.

### You have a solution

Please be so kind as to [search](#use-the-search-luke) for any open issue already covering
your [problem](#you-have-a-problem), and any pending/merged/rejected PR covering your solution.

If the solution is already reported, try it out and +1 the pull request if the
solution works ok. On the other hand, if you think your solution is better, post
it with reference to the other one so we can have both solutions to compare.

If not, then go ahead and submit a PR. Please copy to anyone relevant (e.g. plugin
maintainers) by mentioning their GitHub handle (starting with `@`) in your message.

### You have an addition

Please [do not](https://github.com/ohmyzsh/ohmyzsh/wiki/Themes#dont-send-us-your-theme-for-now)
send themes for now.

Please be so kind as to [search](#use-the-search-luke) for any pending, merged or rejected Pull Requests
covering or related to what you want to add.

If you find one, try it out and work with the author on a common solution.

If not, then go ahead and submit a PR. Please copy to anyone relevant (e.g. plugin
maintainers) by mentioning their GitHub handle (starting with `@`) in your message.

For any extensive change, such as a new plugin, you will have to find testers to +1 your PR.

### New plugin aliases

We acknowledge that aliases are a core part of Oh My Zsh. There are plugins that have +100 aliases!

This has become an issue for two opposing reasons:

- Some users want to have their personal aliases in Oh My Zsh.
- Some users don't want any aliases at all and feel that there are too many.

Because of this, from now on, we require that new aliases follow these conditions:

1. They will be used by many people, not just a few.
2. The aliases will be used many times and for common tasks.
3. Prefer one generic alias over many specific ones.
4. When justifying the need for an alias, talk about workflows where you'll use it,
   preferably in combination with other aliases.
5. If a command with the same name exists, look for a different alias name.

This list is not exhaustive! Please remember that your alias will be in the machines of many people,
so it should be justified why they should have it.

----

## Use the Search, Luke

_May the Force (of past experiences) be with you_

GitHub offers [many search features](https://help.github.com/articles/searching-github/)
to help you check whether a similar contribution to yours already exists. Please search
before making any contribution, it avoids duplicates and eases maintenance. Trust me,
that works 90% of the time.

You can also take a look at the [FAQ](https://github.com/ohmyzsh/ohmyzsh/wiki/FAQ)
to be sure your contribution has not already come up.

If all fails, your thing has probably not been reported yet, so you can go ahead
and [create an issue](#reporting-issues) or [submit a PR](#submitting-pull-requests).

----

## Commit Guidelines

Oh My Zsh uses the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/)
specification. The automatic changelog tool uses these to automatically generate
a changelog based on the commit messages. Here's a guide to writing a commit message
to allow this:

### Format

```
type(scope)!: subject
```

- `type`: the type of the commit is one of the following:

  - `feat`: new features.
  - `fix`: bug fixes.
  - `docs`: documentation changes.
  - `refactor`: refactor of a particular code section without introducing
    new features or bug fixes.
  - `style`: code style improvements.
  - `perf`: performance improvements.
  - `test`: changes to the test suite.
  - `ci`: changes to the CI system.
  - `build`: changes to the build system (we don't yet have one so this shouldn't apply).
  - `chore`: for other changes that don't match previous types. This doesn't appear
    in the changelog.

- `scope`: section of the codebase that the commit makes changes to. If it makes changes to
  many sections, or if no section in particular is modified, leave blank without the parentheses.
  Examples:

  - Commit that changes the `git` plugin:
  ```
  feat(git): add alias for `git commit`
  ```

  - Commit that changes many plugins:
  ```
  style: fix inline declaration of arrays
  ```

  For changes to plugins or themes, the scope should be the plugin or theme name:

  - ✅ `fix(agnoster): commit subject`
  - ❌ `fix(theme/agnoster): commit subject`

- `!`: this goes after the `scope` (or the `type` if scope is empty), to indicate that the commit
  introduces breaking changes.

  Optionally, you can specify a message that the changelog tool will display to the user to indicate
  what's changed and what they can do to deal with it. You can use multiple lines to type this message;
  the changelog parser will keep reading until the end of the commit message or until it finds an empty
  line.

  Example (made up):

  ```
  style(agnoster)!: change dirty git repo glyph

  BREAKING CHANGE: the glyph to indicate when a git repository is dirty has
  changed from a Powerline character to a standard UTF-8 emoji. You can
  change it back by setting `ZSH_THEME_DIRTY_GLYPH`.

  Fixes #420

  Co-authored-by: Username <email>
  ```

- `subject`: a brief description of the changes. This will be displayed in the changelog. If you need
  to specify other details, you can use the commit body, but it won't be visible.

  Formatting tricks: the commit subject may contain:

  - Links to related issues or PRs by writing `#issue`. This will be highlighted by the changelog tool:
    ```
    feat(archlinux): add support for aura AUR helper (#9467)
    ```

  - Formatted inline code by using backticks: the text between backticks will also be highlighted by
    the changelog tool:
    ```
    feat(shell-proxy): enable unexported `DEFAULT_PROXY` setting (#9774)
    ```

### Style

Try to keep the first commit line short. It's harder to do using this commit style but try to be
concise, and if you need more space, you can use the commit body. Try to make sure that the commit
subject is clear and precise enough that users will know what changed by just looking at the changelog.

----

## Volunteer

Very nice!! :)

Please have a look at the [Volunteer](https://github.com/ohmyzsh/ohmyzsh/wiki/Volunteers)
page for instructions on where to start and more.
