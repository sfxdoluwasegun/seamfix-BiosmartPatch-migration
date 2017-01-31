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

rename %currentLib%\aware-preface-6.1.1.jar Preface-6.1.1.jar
rename %currentLib%\aware-wsq1000-2.1.0.6.jar Wsq1000-2.1.0.6.jar
rename %currentLib%\aware-accusequence-3.9.9.jar Accusequence-3.9.9.jar
rename %currentLib%\aware-ls-3.13.65.jar Ls-3.13.65.jar
rename %currentLib%\aware-nistpack-5.16.jar Nistpack-5.16.jar
rename %currentLib%\lombok.jar lombok-1.16.6.jar

del /q /f %currentLib%\apache-commons-net.jar
del /q /f %currentLib%\asm-1.5.3.jar
del /q /f %currentLib%\biocapture-common-1.0-SNAPSHOT.jar
del /q /f %currentLib%\biocapture-core-1.0-SNAPSHOT.jar
del /q /f %currentLib%\bridj-0.6.2.jar
del /q /f %currentLib%\c3p0-0.9.1.2.jar
del /q /f %currentLib%\cglib-2.1_3.jar
del /q /f %currentLib%\com.ibm.icu_3.4.4.1.jar
del /q /f %currentLib%\comm.jar
del /q /f %currentLib%\commons-logging-1.1.1.jar
del /q /f %currentLib%\commons-validator.jar
del /q /f %currentLib%\converter-gson-2.0.0-beta4.jar
del /q /f %currentLib%\dpuareu.jar
del /q /f %currentLib%\ehcache-1.2.3.jar
del /q /f %currentLib%\grfingerjava.jar
del /q /f %currentLib%\GriauleAfisWSQJava.jar
del /q /f %currentLib%\gson-2.4.jar
del /q /f %currentLib%\hibernate-3.2.6.ga.jar
del /q /f %currentLib%\hibernate3.jar
del /q /f %currentLib%\httpclient-4.1.jar
del /q /f %currentLib%\httpclient-cache-4.1.jar
del /q /f %currentLib%\httpcore-4.1.jar
del /q /f %currentLib%\httpmime-4.1.jar
del /q /f %currentLib%\imgscalr-lib-4.2.jar
del /q /f %currentLib%\jai_codec.jar
del /q /f %currentLib%\jai_core.jar
del /q /f %currentLib%\jakarta-oro-2.0.8.jar
del /q /f %currentLib%\javaee.jar
del /q /f %currentLib%\JFindMe.jar
del /q /f %currentLib%\jgoodies-validation-2.3.2.jar
del /q /f %currentLib%\JJILCore.jar
del /q /f %currentLib%\JJIL-J2SE.jar
del /q /f %currentLib%\jnativehook-2.0.3.jar
del /q /f %currentLib%\jsch-0.1.52.jar
del /q /f %currentLib%\JTattoo.jar
del /q /f %currentLib%\jxl.jar
del /q /f %currentLib%\kycclient-model*.jar
del /q /f %currentLib%\log4j.jar
del /q /f %currentLib%\lti-civil.jar
del /q /f %currentLib%\lti-civil-noutils.jar
del /q /f %currentLib%\miglayout-4.0.jar
del /q /f %currentLib%\miglayout15-swing.jar
del /q /f %currentLib%\miglayout-src.zip
del /q /f %currentLib%\neurotec-biometrics-tools.jar
del /q /f %currentLib%\okhttp-3.1.2.jar
del /q /f %currentLib%\okio-1.6.0.jar
del /q /f %currentLib%\OpenNMEA.jar
del /q /f %currentLib%\postgresql.jar
del /q /f %currentLib%\rest-handler-1.4.8.jar
del /q /f %currentLib%\retrofit-2.0.0-beta4.jar
del /q /f %currentLib%\sc-griaule.jar
del /q /f %currentLib%\sc-neurotec.jar
del /q /f %currentLib%\SeamfixFingerprintApi2.jar
del /q /f %currentLib%\SeamfixSmsLib.jar
del /q /f %currentLib%\sigar.jar
del /q /f %currentLib%\slf4j-api-1.7.4.jar
del /q /f %currentLib%\sun-jai_codec.jar
del /q /f %currentLib%\swt.jar
del /q /f %currentLib%\validation-engine-3.2.18.jar
del /q /f %currentLib%\webcam-capture-0.3.12-20160507.091613-2.jar
del /q /f %currentLib%\webcam-capture-0.3.12*.jar

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

rem copy dat files
set mypublic=%public%\ncc_data
mkdir %mypublic%
if not exist "%mypublic%\mtnCore.dat" (
	echo mtnCore not found, replace it
	xcopy /y dat\mtn* %mypublic%
)
xcopy /y dat\nt* %mypublic%

del /q /f %currentHome%\props\.kyc

rem delete biocapture xml
del /q /f %currentHome%\biocaptureconfig.xml

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
%peesql% -U postgres -d kyc_db -a -f country_updates.sql >> nul
%peesql% -U postgres -c "alter user seamfix password '%new_pass_sm%'"
%peesql% -U postgres -c "alter user postgres password '%new_pass_pg%'"
%peesql% -U postgres -d kyc_db -c "alter table public.enrollment_client_audit_trail drop constraint enrollment_client_audit_trail_unique_activity_code_key"

set old_pass=s3amf1x#
set new_pass_sm=3M@RTDBp@Z
set new_pass_pg=5v2YM@LHq4
set PGPASSWORD=%old_pass%
%peesql% -U postgres -d kyc_db -a -f Area.sql >> nul
%peesql% -U postgres -d kyc_db -a -f country_updates.sql >> nul
%peesql% -U postgres -c "alter user seamfix password '%new_pass_sm%'"
%peesql% -U postgres -c "alter user postgres password '%new_pass_pg%'"
%peesql% -U postgres -d kyc_db -c "alter table public.enrollment_client_audit_trail drop constraint enrollment_client_audit_trail_unique_activity_code_key"

exit