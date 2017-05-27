# node-modules-path

This plugin listens to pwd updates and searches for a node_modules directory in
current directory and upwards. For the first node_modules folder found (the
deepest one), we automatically add its .bin folder to PATH (node_modules/.bin).

## motivation

We try to keep project dependencies as isolated as possible and we avoid
installing them globally to our machines. One such dependency is
[Flow](https://flow.org/). Text editors with Flow extensions search for the `flow`
binary on path. Thus, before opening our editor, we must first remember to add
the project's node_module/.bin folder to path.

The reason we created this plugin was automate this step to safe little time
when doing our development.

## example

	➜  ~ tree ~/project
	/Users/hlysig/project
	├── node_modules
	│   └── flow
		 ...
	├── package.json
	├── src
	│   └── server
	│       └── index.js
	└── yarn.lock
	
	➜  ~ cd ~/project/src/server
	Found node_modules in /Users/hlysig/project, adding to path
	➜  server which flow
	/Users/hlysig/project/node_modules/.bin/flow

## requirements

This plugin uses Python and works with Python 2.6 and upwards.

## authors

- Hlynur Sigurthorsson ([hlysig@gmail.com](mailto:hlysig@gmail.com))
