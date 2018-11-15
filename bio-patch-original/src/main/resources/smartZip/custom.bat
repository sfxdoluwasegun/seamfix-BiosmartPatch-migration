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

set system32=C:\Windows\System32
set syswow64=C:\Windows\SysWOW64


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



