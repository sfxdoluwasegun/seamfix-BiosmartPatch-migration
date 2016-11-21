cd %temp%
call :redirect >log.txt 2>&1

:redirect
echo %date% %time%
cd kyc

set newhome=c:\smartclient-2.0\smartclient

del /q /f %newhome%\kycclient.exe
xcopy /y kycclient.exe %newhome%

set newlib=%newhome%\lib
mkdir %newlib%

del /q /f %newlib%\aware-wsq1000-2.1.0.5.jar
del /q /f %newlib%\jai-core-1.1.3-alpha.jar
del /q /f %newlib%\jnativehook-2.0.2.jar
del /q /f %newlib%\gson-1.6.jar
del /q /f %newlib%\JTattoo-1.6.11.jar
del /q /f %newlib%\rest-handler*.jar
del /q /f %newlib%\validationengine*.jar
del /q /f %newlib%\validation-engine*.jar
del /q /f %newlib%\webcam-capture*.jar
del /q /f %newlib%\seamfixfingerprintapi2*.jar

xcopy /y c:\smartclient-2.0\biosmart\lib\aware-*.jar %newlib%
xcopy /y c:\smartclient-2.0\biosmart\lib\dpuareu.jar %newlib%
xcopy /y c:\smartclient-2.0\biosmart\lib\slf4j-api-1.7.4.jar %newlib%
xcopy /y c:\smartclient-2.0\biosmart\lib\swingx-all-1.6.4.jar %newlib%

xcopy /y lib\*.jar %newlib%

set newnative=%newhome%\native
mkdir %newnative%

rem copy native
xcopy /y c:\smartclient-2.0\biosmart\native\*.* %newnative%

rem check if folder exists in path before adding 
for /F "tokens=*" %%f in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v path ^| find /c /i "c:\smartclient-2.0\smartclient\native"') do (set found=%%f) 

for /F "tokens=2* delims= " %%f IN ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v path ^| findstr /i path') do (set OLD_SYSTEM_PATH=%%g)


if %found%==0 (
	echo NOT FOUND!
	setx PATH "%newnative%;%OLD_SYSTEM_PATH%;" -m
)

rem copy dat files
set mypublic=%public%\ncc_data
mkdir %mypublic%
if not exist "%mypublic%\mtnCore.dat" (
	echo mtnCore not found, replace it
	xcopy /y dat\mtn* %mypublic%
)
xcopy /y dat\nt* %mypublic%

rem copy props
set newprops=%newhome%\props\.kyc
mkdir %newprops%
xcopy /y /s /O/X/E/H/K/I props\* %newprops%

rem delete biosmart folder
rmdir /Q /S c:\smartclient-2.0\biosmart

rem delete old smartclient jar
del /q /f %newhome%\smartclient.jar

rem delete biocapture xml
del /q /f %newhome%\biocaptureconfig.xml

rem change password and populate area
set version=9.2
if exist "%programfiles%\postgresql\%version%\bin\psql.exe" (
set peesql="%programfiles%\postgresql\%version%\bin\psql.exe"
) else (
if exist "%programfiles(x86)%\postgresql\%version%\bin\psql.exe" (
set peesql="%programfiles(x86)%\postgresql\%version%\bin\psql.exe"
)
)
set version=9.3
if exist "%programfiles%\postgresql\%version%\bin\psql.exe" (
set peesql="%programfiles%\postgresql\%version%\bin\psql.exe"
) else (
if exist "%programfiles(x86)%\postgresql\%version%\bin\psql.exe" (
set peesql="%programfiles(x86)%\postgresql\%version%\bin\psql.exe"
)
)
set version=9.4
if exist "%programfiles%\postgresql\%version%\bin\psql.exe" (
set peesql="%programfiles%\postgresql\%version%\bin\psql.exe"
) else (
if exist "%programfiles(x86)%\postgresql\%version%\bin\psql.exe" (
set peesql="%programfiles(x86)%\postgresql\%version%\bin\psql.exe"
)
)

echo %peesql%
echo off
set old_pass=5v2YM@LHq4
set new_pass_sm=3M@RTDBp@Z
set new_pass_pg=5v2YM@LHq4
set PGPASSWORD=%old_pass%
%peesql% -U postgres -d kyc_db -a -f Area.sql >> nul
%peesql% -U postgres -c "alter user seamfix password '%new_pass_sm%'"
%peesql% -U postgres -c "alter user postgres password '%new_pass_pg%'"

set old_pass=s3amf1x#
set new_pass_sm=3M@RTDBp@Z
set new_pass_pg=5v2YM@LHq4
set PGPASSWORD=%old_pass%
%peesql% -U postgres -d kyc_db -a -f Area.sql >> nul
%peesql% -U postgres -c "alter user seamfix password '%new_pass_sm%'"
%peesql% -U postgres -c "alter user postgres password '%new_pass_pg%'"

exit