<h1 align="center">
  <img src="https://github.com/kaaass/ZerotierFix/blob/master/app/src/main/ic_launcher-playstore.png?raw=true" alt="Zerotier Fix" width="200">
  <br>Zerotier Fix<br>
</h1>

<p align="center">简体中文 | <a href="README.en.md">English</a></p>

<h4 align="center">基于 ZerotierFix 的非官方 ZeroTier Android 客户端</h4>

<p align="center">
  <img src="screenshots/main.png" alt="主界面" width="150"/>
  <img src="screenshots/peers.png" alt="Peer 列表" width="150"/>
  <img src="screenshots/moons.png" alt="Moon 列表" width="150"/>
</p>

<p align="center">
    <a href="https://github.com/hengliang8/ZerotierFix/actions/workflows/build-app.yml">
        <img src="https://github.com/hengliang8/ZerotierFix/actions/workflows/build-app.yml/badge.svg" alt="构建状态"/>
    </a>
</p>

## 功能

- 支持自建 Moon，并可导入 Moon 文件
- 支持通过文件或 URL 添加自定义 Planet 配置
- 查看 Peer 列表
- 中文界面

本 fork 使用官方 ZeroTier One **1.16.2** 核心，保留 ZerotierFix 原有的 Moon 文件导入方式。用户在小米 15、HyperOS 3.0、Android 16 上验证：导入 Moon 文件后，可以通过 IPv4 访问此前无法访问的目标 Peer。

## 下载与安装

从 [Releases 页面](https://github.com/hengliang8/ZerotierFix/releases)下载已签名的 APK。

本 fork 使用自己的签名密钥。如果手机安装的是原项目 `kaaass/ZerotierFix` 发布的 APK，必须先卸载旧版，再安装本 fork 的 APK。两者签名不同，Android 无法直接覆盖安装。**卸载会清除应用本地配置和 ZeroTier 身份**；安装后需要重新加入网络，必要时重新授权新节点，并再次导入 Moon 文件。以后使用同一密钥签名的本 fork 新版本可以直接覆盖本次发布的版本。

[GitHub Actions](https://github.com/hengliang8/ZerotierFix/actions/workflows/build-app.yml) 中的拉取请求构建使用调试签名，不能覆盖正式发布的 APK。

## 从源码构建

`externals/core` 子模块固定在官方 ZeroTier One 1.16.2。Android JNI 适配保存在 `patches/zerotier-core-1.16.2.patch`。用 Android Studio 打开项目前，先初始化子模块并应用补丁：

```powershell
git submodule sync --recursive
git submodule update --init --recursive
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/prepare-core.ps1
```

Linux 或 macOS 上将最后一行换成 `bash scripts/prepare-core.sh`。准备脚本可以重复执行。应用补丁后，子模块在本地显示为已修改，这是预期现象；CI 构建也会应用同一补丁。

当前构建使用 Android SDK Platform 33、NDK 23.1.7779620、CMake 3.22.1，Gradle 使用 JDK 11。Android Studio 本身可以使用内置 JDK，但项目的 **Gradle JDK** 应设为 JDK 11。仓库已包含 Gradle Wrapper 7.5，无需单独安装 Gradle。

升级过程和设备验证状态见 [ZeroTier 核心升级文档](docs/upgrade-zerotier-core-1.16.md)。

## 来源与致谢

本仓库基于 [kaaass/ZerotierFix](https://github.com/kaaass/ZerotierFix)。ZeroTier 核心来自 [zerotier/ZeroTierOne](https://github.com/zerotier/ZeroTierOne)，贡献者信息见其 [AUTHORS.md](https://github.com/zerotier/ZeroTierOne/blob/master/AUTHORS.md#primary-authors)。原 Android 客户端作者为 Grant Limberg。应用标志属于 ZeroTier, Inc. 的商标。

## 后续计划

- [x] 持久化 Moon 配置并支持文件导入
- [x] 查看 Peer 列表
- [x] 自定义 Planet 配置
- [x] 从源码构建 JNI 库
- [x] 更新 Material Design 界面
- [ ] 在 v2 中重写应用