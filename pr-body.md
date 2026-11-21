## Problem

`encodefile64` passed its input file as a positional argument to `base64`, which fails on BSD and macOS. Unquoted arguments also broke filenames containing spaces, and failed encodes still printed a success message.

## Changes

- Read and write files through stdin and redirection so file encoding works with GNU and BSD `base64`.
- Quote string and file arguments, reject invalid file input, and publish output only after encoding succeeds.
- Use the shared `-d` decode flag and correct the file-encoding README example.
- Add tests for string encoding, decoding, filenames with spaces, invalid input, and failed encodes.

## Verification

- `zsh plugins/encode64/tests/encode64.test.zsh` (6 tests passed on Linux with GNU base64)
- `zsh -n plugins/encode64/encode64.plugin.zsh plugins/encode64/tests/encode64.test.zsh`
- `git diff --check`

AI-assisted contribution: ChatGPT assisted with implementation and test drafting; the changes and test results were reviewed locally.

Fixes #14218
