# dart-libdogecoin

libdogecoin bindings for Dart and Flutter

Supports Linux, Windows, macOS, Android and iOS. *(libdogecoin is required to be installed or linked)*

**Note: This project and README are a work in progress!**

# Linux

## Arch Linux
You can install libdogecoin from the AUR.

```bash
yay -S libdogecoin-git
```

## Other (Debian, Ubuntu, etc)
Compile and install libdogecoin from https://github.com/dogecoinfoundation/libdogecoin.

# Android

Compile libdogecoin for android or install from https://github.com/alamshafil/libdogecoin-mobile

For use in Flutter, copy `build/arm64-v8a` to `<flutter project>/android/app/src/main/jniLibs/arm64-v8a`

# iOS

Compile libdogecoin for iOS or install from https://github.com/alamshafil/libdogecoin-mobile

For use in Flutter, add `libdogecoin.framework` to your Xcode project.

# Usage

```dart
import 'package:dart_libdogecoin/dart_libdogecoin.dart';

void main() {
  final keypair = LibDogecoin.generateHDMasterPubKeypair(false); // false means use mainnet

  print("Public key: ${keypair.masterPubKey}");
  print("Private key: ${keypair.masterPrivKey}");
}
```