@ECHO OFF

set _versionQuerry=curl.exe -s https://api.github.com/repos/odin-lang/Odin/releases/latest

set "_downloadUrl=notFound"


for /f "tokens=1-2" %%i in ('curl.exe -s https://api.github.com/repos/odin-lang/Odin/releases/latest') do (
	if "%%i"==""browser_download_url":" (		
		call :FindWindowsRelease %%j _downloadUrl
	)
)



if "%_downloadUrl%"=="notFound" (
	goto :eof
)
echo.
echo == Dowloading lattest version of Odin compiler ==
curl.exe -LO %_downloadUrl%
echo == Finished dowloading ==	
echo.

set _filename=
for %%F in ("%_downloadUrl%") do set _filename=%%~nF.zip


set _destinationDir=C:\odin\

if not exist %_destinationDir% mkdir %_destinationDir%

del /f/s/q %_destinationDir%* > nul

echo == Extracting to %_destinationDir% ==
tar -xf %_filename% -C %_destinationDir%
echo == Cleaning up ==
del /q %_filename% > nul

echo.
echo ====== DONE ======

:FindWindowsRelease
	setlocal   
	set _curUrl=%1
	if "%_curUrl%"=="" (	
		endlocal
		goto :eof
	)	
	endlocal & if not x%_curUrl:odin-windows-amd64=%==x%_curUrl% set "%2=%_curUrl%"
	goto :eof
:End