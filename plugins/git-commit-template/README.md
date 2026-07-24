# git-commit-template plugin

To better write git commit messages, we can use template to specify the desired description and type of message.

To use it, add `git-commit-template` to the plugins array in your zshrc file:

```bash
plugins=(... git-commit-template)
```

## Learn This Articles

- #### [How to Write Better Git Commit Messages](https://www.freecodecamp.org/news/how-to-write-better-git-commit-messages/)

- #### [Epower Git Template](https://github.com/epowerng/git-template)

## Usage

All you have to do is call the `gct` command and fill in the items that 
are not optional at each step to prepare the message format.

![gct](https://raw.githubusercontent.com/ghasemdev/git-commit-template/master/images/1.png)

![result](https://raw.githubusercontent.com/ghasemdev/git-commit-template/master/images/2.png)

With the `git log` command, we can see the message that we committed.

![git log](https://raw.githubusercontent.com/ghasemdev/git-commit-template/master/images/3.png)

### signature

You can use `-s` or `sign` to add a signature to the gct.

```bash
➜  gct -s
➜  gct sign
```

## Tanks For Supporting 📌 [Source](https://github.com/ghasemdev/git-commit-template)
