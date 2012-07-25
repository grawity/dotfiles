@echo off & setlocal
set srcdir=%~dp0\..
pushd "%srcdir%"
call git pull
popd

call :install windows\vimrc	"%USERPROFILE%\_vimrc"
call :install windows\gvimrc	"%USERPROFILE%\_gvimrc"

::call :install gitconfig		"%USERPROFILE%\.gitconfig"
::call :install gitignore		"%USERPROFILE%\.gitignore"
::call :install windows\gtkrc-2.0	"%USERPROFILE%\.gtkrc-2.0"

goto :eof

:install
	echo Installing '%~1'
	echo f | xcopy /m /e /c /i /h /r /k /y "%srcdir%\%~1" "%~2"
	goto :eof
