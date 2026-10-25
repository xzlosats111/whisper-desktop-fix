# 测试记录与发布说明

## 已完成的静态检查

- 日语语言代码固定为 `ja`（`0x616A`）。
- 输出格式固定为 `SubRip / .srt`。
- 选中视频/音频后，输出路径自动改为同目录同名 `.srt`。
- 文件选择器包括 `.avi`、`.mp4`、`.mkv`、`.mov`、`.webm`、`.flv`、`.wav`、`.mp3`、`.m4a` 等常见格式。
- 模型加载固定为 DirectCompute GPU 后端，并清除旧版注册表中的高级 GPU 设置影响。
- 对话框资源已改为简体中文的“选择模型 → 选择媒体 → 开始生成 SRT”流程。
- 源码修改已运行 `git diff --check`，未发现空白错误。

## 尚未完成的步骤

本工作区不是 Windows，且没有 Visual Studio、Windows SDK、Direct3D 编译器或可用的 Windows CI 授权。因此**没有在此处编译或实际运行 EXE**；不要把此源代码包误认为已测试的 Windows 成品。

仓库自带 GitHub Actions Windows 构建流程。将本项目推送到个人 GitHub 仓库的 `master` 分支后，Actions 完成时可下载 `WhisperDesktop-x64` 构建产物。也可以在本机按 `README_简体中文.md` 使用 Visual Studio 2022 构建。源码包附带 `发布到GitHub.cmd`，用户在自己的 Windows 电脑运行它即可使用浏览器授权推送；该脚本不会要求把令牌发送到聊天中。

## 最终 Windows 包应包含

```text
WhisperDesktop.exe
Whisper.dll
使用说明_简体中文.md
```

模型 `ggml-large-v3-q5_0.bin` 可以放在任意目录，首次启动时在界面中选择它，不必与 EXE 放在一起。
