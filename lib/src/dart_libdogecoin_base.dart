import 'dart:ffi';
import 'package:ffi/ffi.dart';

import '../libdogecoin_bindings.dart' as libdoge;

final libdogecoin = libdoge.libdogecoin(DynamicLibrary.open("libdogecoin.so"));

class LibDogecoin {
  // Address API

  static Keypair generatePrivPubKeypair(bool isTestnet) {
    int testnet = isTestnet ? 1 : 0;
    Pointer<Char> privKey = malloc.allocate(53);
    Pointer<Char> pubKey = malloc.allocate(35);

    libdogecoin.dogecoin_ecc_start();

    libdogecoin.generatePrivPubKeypair(privKey, pubKey, testnet);

    libdogecoin.dogecoin_ecc_stop();

    Keypair pair = Keypair(privKey.cast<Utf8>().toDartString(),
        pubKey.cast<Utf8>().toDartString());

    malloc.free(privKey);
    malloc.free(pubKey);

    return pair;
  }

  static HDKeypair generateHDMasterPubKeypair(bool isTestnet) {
    int testnet = isTestnet ? 1 : 0;
    Pointer<Char> masterPrivKey = malloc.allocate(200);
    Pointer<Char> masterPubKey = malloc.allocate(35);

    libdogecoin.dogecoin_ecc_start();

    libdogecoin.generateHDMasterPubKeypair(
        masterPrivKey, masterPubKey, testnet);

    libdogecoin.dogecoin_ecc_stop();

    HDKeypair pair = HDKeypair(masterPrivKey.cast<Utf8>().toDartString(),
        masterPubKey.cast<Utf8>().toDartString(length: 34));

    malloc.free(masterPrivKey);
    malloc.free(masterPubKey);

    return pair;
  }

  static String generateDerivedHDPubkey(String masterPrivKey) {
    Pointer<Char> childPubKey = malloc.allocate(35);

    libdogecoin.dogecoin_ecc_start();

    libdogecoin.generateDerivedHDPubkey(
        masterPrivKey.toNativeUtf8().cast<Char>(), childPubKey);

    libdogecoin.dogecoin_ecc_stop();

    String result = childPubKey.cast<Utf8>().toDartString();

    malloc.free(childPubKey);

    return result;
  }

  static bool verifyPrivPubKeypair(
      String privKey, String pubkey, bool isTestnet) {
    int testnet = isTestnet ? 1 : 0;

    libdogecoin.dogecoin_ecc_start();

    int result = libdogecoin.verifyPrivPubKeypair(
        privKey.toNativeUtf8().cast<Char>(),
        pubkey.toNativeUtf8().cast<Char>(),
        testnet);

    libdogecoin.dogecoin_ecc_stop();

    return result == 0 ? false : true;
  }

  static bool verifyHDMasterPubKeypair(
      String privKeyMaster, String pubkeyMaster, bool isTestnet) {
    int testnet = isTestnet ? 1 : 0;

    libdogecoin.dogecoin_ecc_start();

    int result = libdogecoin.verifyHDMasterPubKeypair(
        privKeyMaster.toNativeUtf8().cast<Char>(),
        pubkeyMaster.toNativeUtf8().cast<Char>(),
        testnet);

    libdogecoin.dogecoin_ecc_stop();

    return result == 0 ? false : true;
  }

  static bool verifyP2pkhAddress(String p2pkhPubkey) {
    int result = libdogecoin.verifyP2pkhAddress(
        p2pkhPubkey.toNativeUtf8().cast<Char>(), p2pkhPubkey.length);

    return result == 0 ? false : true;
  }
}

class Keypair {
  late String privKey;
  late String pubKey;
  Keypair(this.privKey, this.pubKey);
}

class HDKeypair {
  late String masterPrivKey;
  late String masterPubKey;
  HDKeypair(this.masterPrivKey, this.masterPubKey);
}
