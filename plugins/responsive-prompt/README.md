# Responsive Prompt

`Responsive Prompt` is a `OhMyZSH` plugin, which makes your prompt
responsive to your terminal's column size. It does so, by watching
`$COLUMNS` environment variables. When it changes, this plugin reloads
your ZSH prompt.

## Different Prompts

You can define several prompts for your terminal via functions named
like `_prompt_60`, which defines the prompt to be used when `$COLUMNS`
is greater than `60`. Note that, you must set `$PROMPT_BREAKPOINTS`
variable, appropriately, for this to work. Example:

    PROMPT_BREAKPOINTS=(100 50 0)
    _prompt_100(){ PROMPT="<prompt1>"; }  # prompt when $COLUMNS > 100
    _prompt_50() { PROMPT="<prompt2>"; }  # prompt when 100 >= $COLUMNS > 50
    _prompt_0()  { PROMPT="<prompt3>"; }  # prompt when  50 >= $COLUMNS > 0

You can, even, define different prompts using conditional statements in
your `$PROMPT_FILE`. In this case, your `$PROMPT_FILE` will be sourced,
whenever the value of `$COLUMNS` change, to reload your prompt. Example:

    if [[ $COLUMNS -gt 100 ]]; then
      PROMPT="<prompt1>"
    elif [[ $COLUMNS -gt 50 ]]; then
      PROMPT="<prompt2>"
    else
      PROMPT="<prompt3>"
    fi

## Variables

- **`PROMPT_FILE`**: File which will be sourced (in order to reload the
  `PROMPT`), if no appropriate prompt-setting functions were found.
  Since, most ZSH users will have prompt defined somewhere inside their
  `~/.zshrc` file, it is the default. However, if you have a dedicated
  file for your prompt, you can specify it with this option, which will
  speed up prompt rendering.

- **`PROMPT_BREAKPOINTS`**: If you use prompt-setting functions, you can
  use this variable to define the various `$COLUMNS` values, when the
  plugin should reload your prompt. Note that, you must define this
  variable in a decreasing array format. Default value: `(120 90 60 0)`,
  which means that when `$COLUMNS` is greater than `120`, `_prompt_120`
  function will be called, and so on. If the plugin is unable to find
  a function by these names, your `$PROMPT_FILE` will be sourced to
  reload the prompt.


- **`PROMPT_NEWLINE_AFTER`**: If you prefer to break your prompt into
  a multi-line prompt when it exceeds a given display length, you can
  use this variable to specify such length. Once the prompt exceeds this
  length, a newline character will be inserted in the variable
  `$prompt_newline`, which you can use inside your prompt definition.
  Otherwise, this variable will remain empty.
