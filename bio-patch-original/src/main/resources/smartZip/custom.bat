cd %temp%
call :redirect >log.txt 2>&1

:redirect
echo %date% %time%

rem kill all existing instances
taskkill /F /FI "WINDOWTITLE eq MTN SmartClient*"
taskkill /F /FI "WINDOWTITLE eq MTN Smartclient*"
taskkill /F /FI "WINDOWTITLE eq MTN BioSmart*"


rem switch to kyc folder, contains all dependencies
cd kyc

set currentHome=c:\smartclient-2.0\smartclient

del /q /f %currentHome%\kycclient.exe
xcopy /y kycclient.exe %currentHome%

set currentLib=%currentHome%\lib
mkdir %currentLib%


xcopy /y lib\*.jar %currentLib%


set currentNative=%currentHome%\native
mkdir %currentNative%

rem check if native folder exists in path before adding
for /F "tokens=*" %%f in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v path ^| find /c /i "c:\smartclient-2.0\smartclient\native"') do (set found=%%f)

for /F "tokens=2* delims= " %%f IN ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v path ^| findstr /i path') do (set OLD_SYSTEM_PATH=%%g)


if %found%==0 (
    rem commit path
	echo NOT FOUND!
	setx PATH "%currentNative%;%OLD_SYSTEM_PATH%;" -m
)


del /q /f %currentHome%\props\.kyc

rem delete biocapture xml
del /q /f %currentHome%\biocaptureconfig.xml

exit