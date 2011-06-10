@echo off & setlocal
set srcdir=%USERPROFILE%\lib\dotfiles

pushd "%srcdir%"
call git pull
popd

call :install gitconfig		"%USERPROFILE%\.gitconfig"
call :install gitignore		"%USERPROFILE%\.gitignore"
call :install windows\gtkrc-2.0	"%USERPROFILE%\.gtkrc-2.0"
call :install vimrc		"%USERPROFILE%\.vimrc"
call :install vim		"%USERPROFILE%\vimfiles"
goto :eof

:install
	echo Installing '%~1'
	echo f | xcopy /m /e /c /i /h /r /k /y "%srcdir%\%~1" "%~2"
	goto :eof
