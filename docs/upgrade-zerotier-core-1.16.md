# ZeroTier 核心升级至 1.16.2 执行计划

## 目标与范围

将 ZerotierFix 使用的 ZeroTier 核心从当前 1.12 系列升级至官方 `1.16.2`，保留现有 Moon、自定义 Planet、Peer 列表等功能，并确认升级后的 APK 在出现问题的小米手机上仍能访问目标网络中的 Peer。

本次先升级核心及其必要的 Android 集成代码。界面重写和无关依赖升级不纳入同一批改动；如新核心要求调整构建工具，则单独记录原因和影响。

## 已知基线

- 工作分支：`master`，开始制定计划时工作区干净；远端 `origin` 为 `hengliang8/ZerotierFix`。
- 应用仓库源自 `kaaass/ZerotierFix`。当前 `externals/core` 子模块固定在 `d028a24795e4348615783f8f8b95207035595f56`，其 URL 为 `kaaass/ZeroTierOne`。
- `core/build.gradle` 通过 `externals/core/java/CMakeLists.txt` 编译 JNI；`app` 依赖 `:core`。
- 原项目 1.0.10 发布说明标注 ZeroTier 核心为 `1.12.2`。仍需核对当前子模块提交实际对应的版本和补丁。
- 官方 `zerotier/ZeroTierOne` 已发布 `1.16.2` 标签。实施时记录标签对应的完整提交 ID，并固定到该提交。
- 核心子模块现已初始化，可直接检查当前源码。开始核查时它尚未初始化；初始化未改变主仓库记录的提交。

## 执行步骤

### 1. 固定现有基线

- [x] 初始化子模块，核对 `d028a247…` 的版本、构建文件及修改历史。
- [ ] 对比本 fork 与 `kaaass/ZerotierFix`，记录应用层额外改动；核对当前 Release 的源码提交和 APK 签名信息。
- [ ] 保存现有 APK 在目标小米手机上的可复现结果：机型、MIUI/HyperOS 与 Android 版本、网络 ID（公开记录中脱敏）、目标 Peer、IPv4/IPv6 地址、连接方式、成功与失败现象。
- [ ] 记录当前构建环境和支持的 ABI，以便升级前后比较。

**完成条件：**能明确指出现有 APK、应用提交、核心提交和目标设备现象之间的对应关系。

### 2. 盘点核心 fork 补丁

- [ ] 找到 `kaaass/ZeroTierOne` 相对官方 `1.12.2` 的分叉点，列出 fork 独有提交与受影响文件。
- [ ] 按 JNI/API、Android 构建、自定义 Planet/Moon、网络收发、其他类别标注每项改动。
- [ ] 对照官方 `1.16.2`，逐项判断补丁是否已被上游吸收、仍需移植、或应删除，并记录依据。
- [ ] 梳理 `app` 对 `com.zerotier.sdk` 的调用，确认新版 Java 类、回调和 native 方法是否兼容。

**完成条件：**形成补丁清单，每项都有处理决定；尤其明确当前小米可访问目标 Peer 所依赖的行为，不能仅凭名称推测某项 MIUI 提示修复解决了网络问题。

### 3. 升级核心与 Android 集成

- [x] 在独立工作分支实施；以官方 `1.16.2` 固定提交为基础，移植第 2 步确认仍需保留的补丁。
- [x] 更新子模块来源或维护可追踪的核心 fork，并在文档中记录最终提交及补丁来源。应用仓库中的子模块指针须指向可获取的提交。
- [x] 适配 `externals/core/java/CMakeLists.txt`、JNI 代码、Java SDK 与 `core`/`app` 构建配置；处理新旧 API 差异。
- [x] 检查应用版本展示与发布版本号，确保明确区分 APP 版本和核心版本。

**完成条件：**所有目标 ABI 均可构建 APK，启动、加入网络和基本收发可用；构建产物能核对所含核心版本及提交。

### 4. 功能与设备验收

- [ ] 在普通 Android 设备和目标小米设备上检查首次授权、启动 VPN、加入/退出网络、断线重连和后台恢复。
- [ ] 检查自定义 Planet 文件及 URL、Moon 导入/入轨、Peer 列表和路径展示。（Moon 文件导入与目标 Peer 访问已由用户验证，其余项待验收。）
- [ ] 对原先有问题的 Peer，分别验证 IPv4/IPv6（网络实际启用时）、双向访问、Wi-Fi 与移动网络切换、冷启动与重连；记录连接路径、延迟及失败日志。
- [ ] 与旧版 Release 在相同手机、网络和目标 Peer 上对比。若失败，先定位 VPN 路由、DNS、ARP/ND、组播、核心 Peer 路径或 Android 后台限制中的具体环节，再决定修复位置。

**完成条件：**原目标 Peer 的访问结果不退化，关键功能可用；未覆盖的设备或网络场景明确写入发布说明。

### 5. 发布准备

- [ ] 审查最终差异、子模块提交可获取性、许可证及构建产物来源。
- [ ] 更新版本号和更新日志，写明核心版本、保留补丁、设备验证结果和已知限制。
- [ ] 生成并核对签名 APK、ABI、安装与覆盖安装结果；发布动作在验收完成后进行。

**完成条件：**其他人可以从记录的提交复现构建，并能判断该 APK 是否覆盖自己的手机与网络场景。

## 主要风险与处理原则

| 风险 | 处理 |
| --- | --- |
| 核心 fork 的关键补丁在 1.16.2 中缺失 | 先逐项比对，再移植；每项补丁保留上游来源与用途。 |
| 1.16.2 JNI/Java 接口或 CMake 结构变化 | 同步检查 `core` 与 `app` 调用，按编译错误和运行日志逐层适配。 |
| APK 可连接网络但无法访问部分 Peer | 以目标小米手机和具体 Peer 作为验收基准，记录 IP、路径与收发证据。 |
| 子模块指向私人或不存在的提交 | 固定公开可获取的提交，并在文档中记录来源。 |
| 构建成功却因签名或版本号无法覆盖安装 | 发布前检查 applicationId、versionCode 与签名连续性。 |

## 核查记录（2026-09-28）

### 当前源码

- `externals/core` 的 `d028a247…` 位于 `kaaass/ZeroTierOne` 的 `jni/1.12.2` 分支，`version.h` 为 1.12.2；它从官方 `327eb901…`（1.12.2）增加了 3 个提交。
- 本地应用 HEAD 为 `0373a58…`，在 1.0.10 发布提交 `9f74751…` 之后还包含组播实现修复、旧 Android 的 NIO 兼容、ICMPv6 NS 崩溃修复和 CI 修复。后续比较及验收以当前 HEAD 为基线。
- 官方 `1.16.2` 标签对应完整提交 `fc5c3ec22090b5b2a0f274e863651fe9ca489bf4`。

### 核心 fork 补丁清单与初判

| 提交 | 内容 | 1.16.2 初判 |
| --- | --- | --- |
| `9fdad66a…` | 修改 `java/CMakeLists.txt`：动态纳入 `node/*.cpp`，加入 `ext`/Prometheus 头文件和 Android `log` 链接。 | **需要重新适配。**官方 1.16.2 的 JNI CMake 文件仍采用旧的显式源码清单，其中列有已删除的 `C25519.cpp`，且缺少新增的 `ECC.cpp`、`PacketMultiplexer.cpp` 等文件。不能直接将子模块指针改到官方标签。 |
| `be6c71e6…` | 补充同一 CMake 文件的两个 Prometheus 头文件目录。 | **随 CMake 适配复核。**核对 1.16.2 实际头文件布局及编译引用后决定保留路径。 |
| `d028a247…` | 修改 `java/jni/ZT_jniutils.h`，使 JNI 回调在未附着的线程上自动附着并在退出时分离，修复 ICMPv6 NS 触发的崩溃。 | **需要审慎移植。**官方 1.16.2 在 `com_zerotierone_sdk_Node.cpp` 对虚拟网络帧回调加入了线程附着处理，但其他回调仍使用原 `GETENV` 宏；需逐个确认调用线程，再决定是否保留覆盖所有回调的 guard。 |

官方 1.12.2 到 1.16.2 的 `java` 目录仅有 JNI CMake、`ZT_jniutils.h` 和 `com_zerotierone_sdk_Node.cpp` 发生文件级变化，Java SDK 源文件未显示差异。这降低了应用层 API 迁移范围，但不代表运行行为兼容已获验证。

### 下一步判定

1. 精确比对 1.16.2 的新旧核心源码依赖，确定 Android JNI 所需的源文件、头文件、链接库与 NDK 版本。
2. 对 JNI 线程附着补丁做回调级审查，形成最小移植补丁并记录上游已经覆盖的部分。
3. 补齐现有 Release 的 APK 签名与目标小米手机上的可复现访问记录；这两项依赖发布产物和设备，源码本身无法推断。

### 实施记录（进行中）

- 已在 `codex/zerotier-core-1.16.2` 工作分支将子模块固定到官方 `1.16.2`，并将原 fork 的 3 个提交移植为 `patches/zerotier-core-1.16.2.patch`。构建前由 `scripts/prepare-core.ps1` 或 `scripts/prepare-core.sh` 应用；CI 也执行同一准备步骤。
- 应用侧 `core/build.gradle` 直接引用子模块的 Java SDK 源码。原 `core/src/main/java` 是 Git 符号链接，在当前 Windows 检出中表现为普通文本文件，无法作为 Java 源码目录使用。
- Windows 准备脚本已确认首次应用成功、再次运行保持不变，核心差异检查无空白错误。
- 子模块自身固定为官方公开提交 `fc5c3ec…`；补丁由准备脚本应用于工作树，因此构建时子模块显示为修改状态是预期现象。它不应被当成新的子模块提交指针提交。
- 本地使用 JDK 11、Android SDK 33、NDK 23.1.7779620、CMake 3.22.1 和仓库的 Gradle Wrapper 7.5，首次 `:app:assembleDebug` 构建成功。APK 包含 arm64-v8a、armeabi-v7a、x86、x86_64 的 `libZeroTierOneJNI.so`。此时手机尚未连接，未进行设备验收。
- 当前 Android Studio 自带 JDK 25；旧 Gradle 7.5 不支持用它运行构建。先固定 Gradle JDK 11 完成核心迁移；工具链升级可在设备验收后独立进行，以便定位问题。
- 应用户要求，已移除调试构建的 `.dev` 应用 ID 后缀和独立应用标签。调试与正式构建都使用 `net.kaaass.zerotierfix`，版本均为 `1.0.11`（versionCode 15）。只有使用旧版同一密钥签名的正式 APK 才能覆盖安装；调试签名 APK 无法覆盖旧 Release。
- Moon 文件导入路径已补齐目标目录创建和失败返回，避免文件移动失败时仍保存 Moon 记录并显示成功。修改后调试 APK 重新构建成功；文件导入与入轨的运行结果仍需在设备上验收。
- 用户已分别在旧 Release 与升级后的调试 APK 上验证关键场景：在小米 15（HyperOS 3.0、Android 16）上，导入其 Moon 文件后，可以通过 IPv4 访问此前无法访问的目标 Peers；不导入时只能访问其中一部分。这是用户报告的设备实测结果，确认了升级版保留原 ZerotierFix Moon 导入流程后的关键网络行为。其他功能及 IPv6 场景仍待验收。
- `:app:assembleDebug :app:assembleRelease` 在移除 `.dev` 后均再次构建成功。正式构建产物 `app/build/outputs/apk/release/app-release-unsigned.apk` 尚未签名。
- CI 已调整为使用仓库的 Gradle Wrapper 构建调试版与正式版；push 总是上传未签名 APK，只有配置签名 Secret 时才签名并上传正式 APK。当前 fork 没有配置签名 Secret，也没有现有 Release。此工作流尚未在 GitHub Actions 上运行验证。

## 参考资料

- 应用上游：https://github.com/kaaass/ZerotierFix
- 核心 fork：https://github.com/kaaass/ZeroTierOne
- 官方核心及标签：https://github.com/zerotier/ZeroTierOne/tags
- 原项目 Release：https://github.com/kaaass/ZerotierFix/releases
