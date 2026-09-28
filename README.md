<h1 align="center">
  <img src="https://github.com/kaaass/ZerotierFix/blob/master/app/src/main/ic_launcher-playstore.png?raw=true" alt="Zerotier Fix" width="200">
  <br>Zerotier Fix<br>
</h1>

<h4 align="center">An unofficial Zerotier Android client patched from official client.</h4>

<p align="center">
  <img src="screenshots/main.png" alt="main" width="150"/>
  <img src="screenshots/peers.png" alt="peers" width="150"/>
  <img src="screenshots/moons.png" alt="moons" width="150"/>
</p>

<p align="center">
    <a href="https://github.com/hengliang8/ZerotierFix/actions/workflows/build-app.yml">
        <img src="https://github.com/hengliang8/ZerotierFix/actions/workflows/build-app.yml/badge.svg" alt="Build APP"/>
    </a>
</p>

## Features

- Self-hosted Moon Support
- Add custom planet config via file and URL
- View peers list
- Chinese translation

This fork uses ZeroTier One core 1.16.2 and retains ZerotierFix's Moon file import.
On the tested Xiaomi 15 (HyperOS 3.0, Android 16), importing the user's Moon file
allowed IPv4 access to peers that were unreachable without it.

## Download

Check [Releases page](https://github.com/hengliang8/ZerotierFix/releases) for the signed APK.
This fork uses its own signing key. If the installed APK came from the original
`kaaass/ZerotierFix` release, uninstall it before installing this fork's release.
Android cannot install the new APK over the original because their signatures differ.
Uninstalling clears the app's local configuration and ZeroTier identity; rejoin your
networks, authorize the new member if required, and import your Moon file again.
Future releases from this fork can update this fork's signed release in place.

Pull request builds are available from [GitHub Actions](https://github.com/hengliang8/ZerotierFix/actions/workflows/build-app.yml).
These are debug-signed APKs and cannot update a release signed with a different key.

## Build from source

The core submodule is pinned to official ZeroTier One 1.16.2. This repository keeps its
Android JNI changes in `patches/zerotier-core-1.16.2.patch`. Prepare the submodule before
opening the project in Android Studio:

```powershell
git submodule sync --recursive
git submodule update --init --recursive
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/prepare-core.ps1
```

On Linux or macOS, run `bash scripts/prepare-core.sh` in place of the PowerShell command.
The preparation script is safe to run again. The submodule will appear modified locally
after applying the patch; this is expected. The build workflow applies the same patch.

The current build uses Android SDK Platform 33, NDK 23.1.7779620, CMake 3.22.1,
and JDK 11 for Gradle. Android Studio can run on its bundled JDK while the project's
**Gradle JDK** setting points to JDK 11. The repository includes Gradle Wrapper 7.5,
so a separate Gradle installation is not needed.

See [the core upgrade plan](docs/upgrade-zerotier-core-1.16.md) for the migration and
device verification status.

## Copyright

The code for this repository is based on the reverse engineering of the official Android client. The
original author is Grant Limberg (glimberg@gmail.com). See [AUTHORS.md](https://github.com/zerotier/ZeroTierOne/blob/master/AUTHORS.md#primary-authors) for more details.

- Zerotier JNI Sdk is located in git submodule `externals/core`
- Original Android client code is located in `net.kaaass.zerotierfix` (renamed from `com.zerotier.one`)
- App logo is a trademark of `ZeroTier, Inc.` and made by myself. 


## Roadmap

- [X] Add moon config persistent & file config
- [x] Add peer list view
- [x] Support planet config
- [x] Replace pre-built JNI library
- [x] Rewrite & update UI to fit Material Design
- [ ] *WIP* Rewrite whole APP in v2
