# Cake

This plugin provides completion for [CakePHP](https://cakephp.org/).

To use it add cake to the plugins array in your zshrc file.

```bash
plugins=(... cake)
```

## Note

This plugin generates a cache file of the cake tasks found, named `.cake_task_cache`, in the current working directory. 
It is regenerated when the Cakefile is newer than the cache file. It is advised that you add the cake file to your
`.gitignore` files.
