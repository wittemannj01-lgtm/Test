@echo off
where gradle >nul 2>nul
if %errorlevel%==0 (
  gradle %*
  exit /b %errorlevel%
)
echo Gradle is not installed. Open the project in Android Studio or generate a wrapper with Gradle 9.6.0.
exit /b 1
