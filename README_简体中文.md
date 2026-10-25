# 日语字幕工具（Windows / DirectCompute）

这是基于 `const-me/whisper` 的简化改版，基础代码采用已加入 `large-v3`、`large-v3-turbo` 与 q4/q5/q8 GPU 量化支持的 fork。

## 这个版本做什么

- 固定为 **日语音视频 → 日语 SRT**；
- 固定使用显卡 GPU 后端，适合 GTX 1080 Ti；
- 固定输出为源视频同目录、同名的 `.srt`；
- 所有主要操作显示简体中文；
- 适配官方 `ggml-large-v3-q5_0.bin`。

## 使用方式

1. 下载并放好模型：`ggml-large-v3-q5_0.bin`。
2. 启动 `WhisperDesktop.exe`，首次选择模型。
3. 点击“浏览…”选择日语视频或音频。
4. 点击“开始生成 SRT”。
5. 完成后字幕与视频保存在同一目录，例如：`episode.avi` → `episode.srt`。

> Whisper 的内置翻译只能翻成英语。本工具先生成日语 SRT；要中文字幕，请用大模型翻译 SRT，保持时间码不变。


## 一键发布到你的 GitHub 仓库

本源码包已预设目标仓库 `https://github.com/xzlosats111/whisper-desktop-fix`。解压后双击 `发布到GitHub.cmd`：

1. 脚本会用 Git for Windows 创建本地提交并推送到该仓库；
2. 首次推送时，Git Credential Manager 通常会打开浏览器，请登录 GitHub 并授权；
3. 推送完成后，仓库的 **Actions** 会自动构建 Windows 版本；完成时下载 artifact **WhisperDesktop-x64**。

若电脑没有 Git，请先安装 [Git for Windows](https://git-scm.com/download/win)，使用默认安装选项。不要把 GitHub 密钥或令牌发到聊天中。

## 模型校验

官方 `large-v3-q5_0` 文件 SHA1：

```text
e6e2ed78495d403bef4b7cff42ef4aaadcfea8de
```

Windows 校验命令：

```bat
certutil -hashfile ggml-large-v3-q5_0.bin SHA1
```

## 构建 Windows 版本

需要 Windows 10/11、Visual Studio 2022 Community（勾选“使用 C++ 的桌面开发”）和 .NET SDK。

```bat
build_windows.cmd
```

输出文件在：`x64\Release\WhisperDesktop.exe` 与 `x64\Release\Whisper.dll`。两者必须放在同一个文件夹。

## 上游许可

- 原项目：const-me/whisper（MPL-2.0）
- 量化与 large-v3 扩展：sffxzzp/WhisperDesktop
