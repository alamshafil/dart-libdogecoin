import 'package:dart_libdogecoin/dart_libdogecoin.dart';

void main() {
  final keypair = LibDogecoin.generatePrivPubKeypair();

  print("Public key: ${keypair.pubKey}");
  print("Private key: ${keypair.privKey}");
}
