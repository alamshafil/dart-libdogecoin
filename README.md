# dart-libdogecoin

libdogecoin bindings for Dart and Flutter

Only supports Linux, Windows, macOS as of now. *(libdogecoin is required to be installed)*

**Note: This is project and README is a work in progress!**

# Binding progress
- [x] Address
- [x] Transactions

# Usage

```dart
import 'package:dart_libdogecoin/dart_libdogecoin.dart';

void main() {
  final keypair = LibDogecoin.generateHDMasterPubKeypair(false); // false means use mainnet

  print("Public key: ${keypair.masterPubKey}");
  print("Private key: ${keypair.masterPrivKey}");
}
```
