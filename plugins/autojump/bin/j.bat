@echo off
setlocal EnableDelayedExpansion

echo %*|>nul findstr /rx \-.*
if ERRORLEVEL 1 (
  for /f "delims=" %%i in ('python "%~dp0\autojump" %*') do set new_path=%%i
  if exist !new_path!\nul (
    echo !new_path!
    pushd !new_path!
    REM endlocal is necessary so that we can change directory for outside of this script
    REM but will automatically popd. We mush pushd twice to work around this.
    pushd !new_path!
    endlocal
    popd
  ) else (
    echo autojump: directory %* not found
    echo try `autojump --help` for more information
  )
) else (
  python "%~dp0\autojump" %*
)
