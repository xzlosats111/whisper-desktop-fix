@echo off
setlocal EnableExtensions
chcp 65001 >nul
cd /d "%~dp0"
echo 正在继续推送已有的本地提交…
git branch -M master
git remote remove origin >nul 2>nul
git remote add origin https://github.com/xzlosats111/whisper-desktop-fix.git
git push -u origin master
if errorlevel 1 (
  echo.
  echo 推送失败。请保留窗口内容并截图；不要把 GitHub 令牌发到聊天中。
) else (
  echo.
  echo 推送完成。请到 GitHub Actions 下载 WhisperDesktop-x64。
)
pause
