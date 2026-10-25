@echo off
setlocal EnableExtensions
cd /d "%~dp0"
set "UPDATE_DIR=%CD%"
set "REPO_URL=https://github.com/xzlosats111/whisper-desktop-fix.git"
set "PROXY_URL=http://127.0.0.1:10809"
set "TARGET=%USERPROFILE%\Desktop\WhisperDesktop-JapaneseSRT-Source"

echo.
echo ================================================================
echo  Copy v2 update and push to GitHub
echo ================================================================
echo Update folder: %UPDATE_DIR%
echo Target folder: %TARGET%
echo.

where git >nul 2>nul
if errorlevel 1 goto :no_git
if not exist "%TARGET%\.git" goto :no_repo

echo [1/5] Copying v2 update files...
robocopy "%UPDATE_DIR%" "%TARGET%" /E /R:1 /W:1 /XD .git
set "COPY_EXIT=%ERRORLEVEL%"
echo.
echo Robocopy exit code: %COPY_EXIT%
if %COPY_EXIT% GEQ 8 goto :copy_failed

cd /d "%TARGET%"
echo [2/5] Configuring local Git proxy...
git config http.proxy "%PROXY_URL%"
git config http.version HTTP/1.1
git config http.postBuffer 524288000
git config http.lowSpeedLimit 0
git config http.lowSpeedTime 999999
if errorlevel 1 goto :failed

echo [3/5] Staging update...
git add -A
if errorlevel 1 goto :failed
git diff --cached --quiet
if errorlevel 1 goto :commit
echo No changed files were found. The update may already be applied.
goto :push

:commit
echo [4/5] Creating commit...
git commit -m "Restore full UI, fix Chinese text, add batch media transcription"
if errorlevel 1 goto :failed

:push
echo [5/5] Pushing to GitHub...
git branch -M master
git remote remove origin >nul 2>nul
git remote add origin "%REPO_URL%"
git push -u origin master
if errorlevel 1 goto :push_failed

echo.
echo SUCCESS. Open GitHub Actions and wait for Build Japanese SRT Tool.
pause
exit /b 0

:no_git
echo ERROR: Git for Windows was not found.
pause
exit /b 1

:no_repo
echo ERROR: Existing source repository was not found at:
echo %TARGET%
pause
exit /b 1

:copy_failed
echo COPY FAILED. Send a screenshot of the output above.
pause
exit /b 1

:push_failed
echo PUSH FAILED. Send a screenshot of the full error above.
pause
exit /b 1

:failed
echo UPDATE FAILED. Send a screenshot of the full error above.
pause
exit /b 1
