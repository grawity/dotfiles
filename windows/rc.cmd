@echo off

:: "HKEY_CURRENT_USER\Software\Microsoft\Command Processor" /v Autorun

set ACCDB=Q:\private\accounts.db.txt

::if not "%SSH_CONNECTION%"=="" (
::	color 07
::)

::for %%f in ("%UserProfile%\.dotfiles\windows\doskey\*.txt") do (
::	doskey /exename=%%~nf /macrofile="%%~f"
::)

doskey /macrofile="%UserProfile%\.dotfiles\windows\doskey\cmd.exe.txt"
