cd C:\Windows\Temp
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

set currentLib=%currentHome%\lib
mkdir %currentLib%


rem rename %currentLib%\aware-preface-6.1.1.jar Preface-6.1.1.jar
rem rename %currentLib%\aware-wsq1000-2.1.0.6.jar Wsq1000-2.1.0.6.jar
rem rename %currentLib%\aware-accusequence-3.9.9.jar Accusequence-3.9.9.jar
rem rename %currentLib%\aware-ls-3.13.65.jar Ls-3.13.65.jar
rem rename %currentLib%\aware-nistpack-5.16.jar Nistpack-5.16.jar
rem rename %currentLib%\lombok.jar lombok-1.16.6.jar

del /q /f %currentLib%\rest-handler-*.jar
del /q /f %currentLib%\converter-gson*.jar
del /q /f %currentLib%\common-logic-*.jar
del /q /f %currentLib%\kycclient-model*.jar
del /q /f %currentLib%\IBScanCommon-*.jar
del /q /f %currentLib%\IBScanUltimate-*.jar
del /q /f %currentLib%\webcam-capture-driver-gstreamer-0.3.*.jar
del /q /f %currentLib%\demographics-validation-engine-*.jar
del /q /f %currentLib%\validation-engine-*.jar
del /q /f %currentLib%\SeamfixFingerprintApi2-1.0.jar
del /q /f %currentLib%\okio-*.jar
del /q /f %currentLib%\okhttp-*.jar
del /q /f %currentLib%\retrofit-*.jar
del /q /f %currentLib%\slf4j-api-*.jar
del /q /f %currentHome%\kycclient.exe

xcopy /y /r lib\*.jar %currentLib%
xcopy /y /r lib\*.dll %currentLib%

xcopy /y /r KYCClient.exe %currentHome%

del /q /f %currentHome%\props\.kyc

rem delete biocapture xml
del /q /f %currentHome%\biocaptureconfig.xml

set currentNative=%currentHome%\native
mkdir %currentNative%

del /q /f %currentNative%\*
xcopy /y /r native\*.dll %currentNative%

rem check if native folder exists in path before adding
echo %PATH% | find /c /i "C:\smartclient-2.0\smartclient\native" > nul
if not errorlevel 1 goto jump
set pathkey="HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment"
for /F "usebackq skip=2 tokens=2*" %%A IN (`reg query %pathkey% /v Path`) do (reg add %pathkey% /f /v Path /t REG_SZ /d "%%B;C:\smartclient-2.0\smartclient\native")
powershell -command "& {$md=\"[DllImport(`\"user32.dll\"\",SetLastError=true,CharSet=CharSet.Auto)]public static extern IntPtr SendMessageTimeout(IntPtr hWnd,uint Msg,UIntPtr wParam,string lParam,uint fuFlags,uint uTimeout,out UIntPtr lpdwResult);\"; $sm=Add-Type -MemberDefinition $md -Name NativeMethods -Namespace Win32 -PassThru;$result=[uintptr]::zero;$sm::SendMessageTimeout(0xffff,0x001A,[uintptr]::Zero,\"Environment\",2,5000,[ref]$result)}"
:jump

rem change password
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

set version=9.5
if exist "%programfiles%\postgresql\%version%\bin\psql.exe" (
	set peesql="%programfiles%\postgresql\%version%\bin\psql.exe"
) else (
	if exist "%programfiles(x86)%\postgresql\%version%\bin\psql.exe" (
		set peesql="%programfiles(x86)%\postgresql\%version%\bin\psql.exe"
	)
)

echo %peesql%
echo off
set "old_pass=5v2YM@LHq4"
set PGPASSWORD=%old_pass%
%peesql% -U postgres -d kyc_db -c "ALTER TABLE enrollment_client_audit_trail DROP CONSTRAINT enrollment_client_audit_trail_unique_activity_code_key;"

set "old_pass=s3amf1x#"
set PGPASSWORD=%old_pass%
%peesql% -U postgres -d kyc_db -c "ALTER TABLE enrollment_client_audit_trail DROP CONSTRAINT enrollment_client_audit_trail_unique_activity_code_key;"

set currentResources=%currentHome%\resources
set /p javaPath=<%currentResources%\javapath.txt

setx /m JAVA_HOME "%javaPath%"

exit