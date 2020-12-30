# runs an npm script via lerna for a the current module
alias lr='npx lerna run --stream --scope $(node -p "require(\"./package.json\").name")'

# runs "npm run build" (build + test) for the current module
alias lb='lr build'
alias lt='lr test'

# runs "npm run watch" for the current module (recommended to run in a separate terminal session)
alias lw='lr watch'
