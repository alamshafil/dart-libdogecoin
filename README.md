# dart-libdogecoin

libdogecoin bindings for Dart and Flutter

Supports Linux, Windows, macOS, Android and iOS. *(libdogecoin is required to be installed or linked)*

**Note: This project and README is a work in progress!**

# Usage

```dart
import 'package:dart_libdogecoin/dart_libdogecoin.dart';

void main() {
  final keypair = LibDogecoin.generateHDMasterPubKeypair(false); // false means use mainnet

  print("Public key: ${keypair.masterPubKey}");
  print("Private key: ${keypair.masterPrivKey}");
}
```
