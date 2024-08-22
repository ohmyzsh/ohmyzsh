@echo off

:: Check if Chocolatey is installed
where choco >nul 2>nul
if %errorlevel% neq 0 (
    echo Installing Chocolatey...
    @"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "[System.Net.ServicePointManager]::SecurityProtocol = 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
)

:: Install Git if not already installed
where git >nul 2>nul
if %errorlevel% neq 0 (
    echo Installing Git...
    choco install git -y
)

:: Install Windows Subsystem for Linux (WSL) if not already installed
wsl --status >nul 2>nul
if %errorlevel% neq 0 (
    echo Installing WSL...
    wsl --install
)

:: Install Ubuntu on WSL (you can change this to another distribution if preferred)
wsl -d Ubuntu --exec echo "Ubuntu is installed" >nul 2>nul
if %errorlevel% neq 0 (
    echo Installing Ubuntu on WSL...
    wsl --install -d Ubuntu
)

:: Install Zsh and Oh My Zsh in WSL
echo Installing Zsh and Oh My Zsh...
wsl -d Ubuntu -e bash -c "sudo apt update && sudo apt install -y zsh curl && sh -c \"$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\""

:: Set Zsh as the default shell in WSL
echo Setting Zsh as the default shell...
wsl -d Ubuntu -e chsh -s $(which zsh)

echo Setup complete! Please restart your terminal and run 'wsl' to enter the Linux environment with Oh My Zsh.
pause
