import 'package:dart_libdogecoin/dart_libdogecoin.dart';

void main() {
  LibDogecoin.eccStart();
  final keypair = LibDogecoin.generateHDMasterPubKeypair(false);
  LibDogecoin.eccStop();

  print("Public key: ${keypair.masterPubKey}");
  print("Private key: ${keypair.masterPrivKey}");
}
