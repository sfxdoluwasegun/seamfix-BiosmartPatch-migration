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

set system32=C:\Windows\System32
set syswow64=C:\Windows\SysWOW64

del /q /f %currentLib%\IBScanCommon-*.jar
del /q /f %currentLib%\kycclient-model-*.jar
del /q /f %currentLib%\rest-handler-*.jar
del /q /f %currentLib%\IBScanUltimate-*.jar
rem del /q /f %currentLib%\Preface-6.*.jar
del /q /f %currentLib%\validation-engine*.jar
del /q /f %currentLib%\common-logic-*.jar
del /q /f %currentLib%\webcam-capture-driver-gstreamer-*.jar
del /q /f %currentLib%\finger-442capture-*.jar
del /q /f %currentLib%\webcam-capture-*.jar
del /q /f %currentLib%\titanic-sdk-win-*.jar
del /q /f %currentLib%\finger-capture-*.jar
del /q /f %currentHome%\kycclient.exe

rem delete dlls from System32 folder
del /q /f %system32%\aw_preface.dll
del /q /f %system32%\aw_preface_jni.dll
del /q /f %system32%\Aware.Preface.dll
del /q /f %system32%\awj2k.dll
del /q /f %system32%\awsequence.dll
del /q /f %system32%\awsequencejni.dll
del /q /f %system32%\dpfj.dll
del /q /f %system32%\dpfpdd.dll
del /q /f %system32%\dpfj.lib
del /q /f %system32%\dpfpdd.lib
del /q /f %system32%\dpuareu_jni.dll
del /q /f %system32%\ftrJavaScanAPI.dll
del /q /f %system32%\ftrScanAPI.dll
del /q /f %system32%\IBScanUltimate.dll
del /q /f %system32%\IBScanUltimateJNI.dll
del /q /f %system32%\wsq1000.dll
del /q /f %system32%\wsq1000JNI.dll

rem delete dlls from SysWow64 folder
del /q /f %syswow64%\aw_preface.dll
del /q /f %syswow64%\aw_preface_jni.dll
del /q /f %syswow64%\Aware.Preface.dll
del /q /f %syswow64%\awj2k.dll
del /q /f %syswow64%\awsequence.dll
del /q /f %syswow64%\awsequencejni.dll
del /q /f %syswow64%\dpfj.dll
del /q /f %syswow64%\dpfpdd.dll
del /q /f %syswow64%\dpfj.lib
del /q /f %syswow64%\dpfpdd.lib
del /q /f %syswow64%\dpuareu_jni.dll
del /q /f %syswow64%\ftrJavaScanAPI.dll
del /q /f %syswow64%\ftrScanAPI.dll
del /q /f %syswow64%\IBScanUltimate.dll
del /q /f %syswow64%\IBScanUltimateJNI.dll
del /q /f %syswow64%\wsq1000.dll
del /q /f %syswow64%\wsq1000JNI.dll

xcopy /y /r lib\*.jar %currentLib%
rem xcopy /y /r lib\*.dll %currentLib%

xcopy /y /r KYCClient.exe %currentHome%

del /q /f %currentHome%\props\.kyc

rem delete biocapture xml
del /q /f %currentHome%\biocaptureconfig.xml

set currentNative=%currentHome%\native
mkdir %currentNative%

del /q /f %currentNative%\ftr*.dll
del /q /f %currentNative%\IBScan*.dll
xcopy /y /r native\*.dll %currentNative%
rem xcopy /y /r native\*.lib %currentNative%

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

set version=9.6
if exist "%programfiles%\postgresql\%version%\bin\psql.exe" (
	set peesql="%programfiles%\postgresql\%version%\bin\psql.exe"
) else (
	if exist "%programfiles(x86)%\postgresql\%version%\bin\psql.exe" (
		set peesql="%programfiles(x86)%\postgresql\%version%\bin\psql.exe"
	)
)

rem echo %peesql%
rem echo off
rem set PGPASSWORD=5v2YM@LHq4
rem %peesql% -h localhost -p 5432 -U postgres -d kyc_db -f pword.sql
rem %peesql% -h localhost -p 5432 -U postgres -d kyc_db -f  "ALTER USER seamfix with password 'SM@RTDBp@ZPh@z4';"
rem %peesql% -h localhost -p 5432 -U postgres -d kyc_db -f  "ALTER USER postgres with password 'Ph@z45V2YM$LHq4';"

rem set currentResources=%currentHome%\resources
rem set /p javaPath=<%currentResources%\javapath.txt

exit


