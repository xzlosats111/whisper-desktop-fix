@echo off
setlocal EnableExtensions
chcp 65001 >nul

echo.
echo ================================================================
echo  将“日语字幕工具”源码发布到 GitHub
echo  目标仓库：xzlosats111/whisper-desktop-fix
echo ================================================================
echo.

where git >nul 2>nul
if errorlevel 1 (
  echo [失败] 没有找到 Git。
  echo 请安装 Git for Windows（默认选项即可），然后重新运行本文件。
  pause
  exit /b 1
)

if not exist ".github\workflows\build.yml" (
  echo [失败] 请在解压后的 WhisperDesktop-JapaneseSRT-Source 文件夹内运行本文件。
  pause
  exit /b 1
)

for /f "delims=" %%A in ('git config --get user.name 2^>nul') do set "GIT_NAME=%%A"
if not defined GIT_NAME (
  set /p "GIT_NAME=请输入用于提交记录的名字（例如 Zhang San）："
  if not defined GIT_NAME (
    echo [失败] 名字不能为空。
    pause
    exit /b 1
  )
  git config user.name "%GIT_NAME%"
)

for /f "delims=" %%A in ('git config --get user.email 2^>nul') do set "GIT_EMAIL=%%A"
if not defined GIT_EMAIL (
  set /p "GIT_EMAIL=请输入用于提交记录的邮箱："
  if not defined GIT_EMAIL (
    echo [失败] 邮箱不能为空。
    pause
    exit /b 1
  )
  git config user.email "%GIT_EMAIL%"
)

echo.
echo 正在创建本地提交…
git init
if errorlevel 1 goto :failed
git add -A
if errorlevel 1 goto :failed
git commit -m "Chinese Japanese SRT desktop edition"
if errorlevel 1 goto :failed
git branch -M master
git remote remove origin >nul 2>nul
git remote add origin https://github.com/xzlosats111/whisper-desktop-fix.git

echo.
echo 正在推送。Git for Windows 可能会打开浏览器要求登录 GitHub；请按网页完成授权。
echo 如果命令行要求输入 Password，请不要输入 GitHub 登录密码；请在 GitHub 创建仅限此仓库、
echo Contents: Read and write 权限的 Fine-grained personal access token，并在本机粘贴它。
echo 令牌只在你的电脑上输入，不要发到聊天中。
echo.
git push -u origin master
if errorlevel 1 goto :push_failed

echo.
echo [完成] 已推送到 GitHub。
echo GitHub Actions 会自动开始名为 “Build Japanese SRT Tool” 的 Windows 构建。
echo 完成后打开仓库的 Actions 页面，下载 WhisperDesktop-x64 artifact。
pause
exit /b 0

:push_failed
echo.
echo [推送未完成] 常见原因：尚未在浏览器授权 Git、令牌没有 Contents 读写权限、或仓库不是空仓库。
echo 请完成授权后重新运行本文件；它可以安全地重复运行。
pause
exit /b 1

:failed
echo.
echo [失败] Git 本地提交没有完成。请截图本窗口的报错信息。
pause
exit /b 1
