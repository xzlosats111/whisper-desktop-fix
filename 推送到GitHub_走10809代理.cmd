@echo off
setlocal EnableExtensions
chcp 65001 >nul
cd /d "%~dp0"

echo.
echo ================================================================
echo  推送“日语字幕工具”到 GitHub（使用本地 HTTP 代理）
echo  仓库：xzlosats111/whisper-desktop-fix
echo  代理：http://127.0.0.1:10809
echo ================================================================
echo.

where git >nul 2>nul
if errorlevel 1 (
    echo [失败] 没有找到 Git。
    echo 请先安装 Git for Windows，然后重新运行本文件。
    pause
    exit /b 1
)

if not exist ".github\workflows\build.yml" (
    echo [失败] 请把本文件放进解压后的 WhisperDesktop-JapaneseSRT-Source 文件夹，再双击运行。
    pause
    exit /b 1
)

echo [1/4] 配置此项目使用本地代理和 HTTP/1.1…
git config http.proxy http://127.0.0.1:10809
git config http.version HTTP/1.1
git config http.postBuffer 524288000
git config http.lowSpeedLimit 0
git config http.lowSpeedTime 999999
if errorlevel 1 goto :failed

echo [2/4] 检查本地提交…
git rev-parse --verify HEAD >nul 2>nul
if errorlevel 1 (
    echo 未找到本地提交；现在创建首次提交…
    git add -A
    if errorlevel 1 goto :failed

    for /f "delims=" %%A in ('git config --get user.name 2^>nul') do set "GIT_NAME=%%A"
    if not defined GIT_NAME (
        set /p "GIT_NAME=请输入用于提交记录的名字："
        if not defined GIT_NAME goto :identity_failed
        git config user.name "%GIT_NAME%"
    )

    for /f "delims=" %%A in ('git config --get user.email 2^>nul') do set "GIT_EMAIL=%%A"
    if not defined GIT_EMAIL (
        set /p "GIT_EMAIL=请输入用于提交记录的邮箱："
        if not defined GIT_EMAIL goto :identity_failed
        git config user.email "%GIT_EMAIL%"
    )

    git commit -m "Chinese Japanese SRT desktop edition"
    if errorlevel 1 goto :failed
) else (
    echo 已找到本地提交，将直接推送。
)

echo [3/4] 配置 GitHub 远端…
git branch -M master
git remote remove origin >nul 2>nul
git remote add origin https://github.com/xzlosats111/whisper-desktop-fix.git
if errorlevel 1 goto :failed

echo [4/4] 正在经由 127.0.0.1:10809 推送到 GitHub…
echo 如弹出浏览器，请登录 GitHub 并授权 Git Credential Manager。
echo.
git push -u origin master
if errorlevel 1 goto :push_failed

echo.
echo ================================================================
echo  推送成功！
echo  请打开 GitHub 仓库的 Actions 页面，等待 Build Japanese SRT Tool 完成。
echo  构建完成后下载 WhisperDesktop-x64 artifact。
echo ================================================================
pause
exit /b 0

:identity_failed
echo [失败] 提交人名字或邮箱不能为空。
pause
exit /b 1

:push_failed
echo.
echo ================================================================
echo  推送失败。
echo  请确认代理程序正在运行，且 127.0.0.1:10809 是 HTTP 代理端口。
echo  请截图本窗口完整报错发来；不要发送 GitHub 密码或令牌。
echo ================================================================
pause
exit /b 1

:failed
echo.
echo [失败] Git 配置或本地提交没有完成。请截图本窗口报错信息。
pause
exit /b 1
