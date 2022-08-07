import 'package:dart_libdogecoin/dart_libdogecoin.dart';

void main() {
  final keypair = LibDogecoin.generateHDMasterPubKeypair(false);

  print("Public key: ${keypair.masterPubKey}");
  print("Private key: ${keypair.masterPrivKey}");
}
