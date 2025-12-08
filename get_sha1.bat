@echo off
set "KEYTOOL="
if exist "C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe" set "KEYTOOL=C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe"
if exist "C:\Program Files\Android\Android Studio\jre\bin\keytool.exe" set "KEYTOOL=C:\Program Files\Android\Android Studio\jre\bin\keytool.exe"
if not defined KEYTOOL (
    for /d %%i in ("C:\Program Files\Java\jdk*") do (
        if exist "%%i\bin\keytool.exe" set "KEYTOOL=%%i\bin\keytool.exe"
    )
)

if defined KEYTOOL (
    "%KEYTOOL%" -list -v -keystore "%USERPROFILE%\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
) else (
    echo Keytool not found
)
