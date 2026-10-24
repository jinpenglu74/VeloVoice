# VeloVoice 1.3.5 离线安装器工程

此工程用于构建真正离线的 Windows x64 安装器。安装器将完整的 VeloVoice 1.3.5 程序目录（含随包 Java 运行环境）封装进 EXE；安装时不下载 GitHub 文件，不要求目标电脑预装 Java。

## 工程内容

- VeloVoice-1.3.5-Offline.iss：Inno Setup 安装器定义，包含自选安装路径、开始菜单/可选桌面快捷方式和卸载入口。
- build_offline.ps1：验证官方运行包大小与 SHA-256、解压并构建离线安装器。
- ChineseSimplified.isl：简体中文安装向导消息文件；来源与归属见 INNO_LANGUAGE_NOTICE.txt。
- payload/VeloVoice-1.3.5-exe-with-jre.zip：官方 1.3.5 Windows x64 运行包，供离线重新构建使用。
- upstream-source/VeloVoice-1.3.5-source.zip：官方上游源码归档。
- LICENSE-GPL-3.0.txt：上游许可证副本。

## 构建

需要 Windows x64、PowerShell、Inno Setup 6。解压整个源码包后，在 PowerShell 中运行：

    .\build_offline.ps1

脚本不会联网下载文件；如果缺少内置 payload，会明确失败。输出位于 dist\VeloVoice-1.3.5-Offline-Setup-x64.exe。

## 离线性

安装器编译完成后，所有程序文件和 Java 运行环境均已嵌入安装器。目标电脑安装时不访问 GitHub，不下载额外运行时。VeloVoice 的部分 TTS 引擎本身仍可能需要网络或用户另行配置服务，这是应用引擎的要求，与安装器离线无关。

## 官方来源与校验

- 上游仓库：https://github.com/Mai-Onsyn/VeloVoice
- 固定版本：1.3.5
- 官方运行包：VeloVoice-1.3.5-exe-with-jre.zip
- 期望大小：46019358 字节
- SHA-256：f88524ada6c8d17c0421d98814c2e72967e0cd09ec881a92fa59580c6e612657

上游项目使用 GPL-3.0。若分发修改版，须遵守 GPL-3.0 的源码、版权与许可证要求。此安装器为非官方社区打包，未获上游作者背书。