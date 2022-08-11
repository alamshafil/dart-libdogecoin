import 'dart:ffi';
import 'package:ffi/ffi.dart';

import '../libdogecoin_bindings.dart' as libdogecoin;

final rawLibdogecoin =
    libdogecoin.libdogecoin(DynamicLibrary.open("libdogecoin.so"));

class LibDogecoin {
  // Address API

  static Keypair generatePrivPubKeypair(bool isTestnet) {
    int testnet = isTestnet ? 1 : 0;
    Pointer<Char> privKey = malloc.allocate(53);
    Pointer<Char> pubKey = malloc.allocate(35);

    rawLibdogecoin.dogecoin_ecc_start();

    rawLibdogecoin.generatePrivPubKeypair(privKey, pubKey, testnet);

    rawLibdogecoin.dogecoin_ecc_stop();

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

    rawLibdogecoin.dogecoin_ecc_start();

    rawLibdogecoin.generateHDMasterPubKeypair(
        masterPrivKey, masterPubKey, testnet);

    rawLibdogecoin.dogecoin_ecc_stop();

    HDKeypair pair = HDKeypair(masterPrivKey.cast<Utf8>().toDartString(),
        masterPubKey.cast<Utf8>().toDartString(length: 34));

    malloc.free(masterPrivKey);
    malloc.free(masterPubKey);

    return pair;
  }

  static String generateDerivedHDPubkey(String masterPrivKey) {
    Pointer<Char> childPubKey = malloc.allocate(35);

    rawLibdogecoin.dogecoin_ecc_start();

    rawLibdogecoin.generateDerivedHDPubkey(
        masterPrivKey.toNativeUtf8().cast<Char>(), childPubKey);

    rawLibdogecoin.dogecoin_ecc_stop();

    String result = childPubKey.cast<Utf8>().toDartString();

    malloc.free(childPubKey);

    return result;
  }

  static bool verifyPrivPubKeypair(
      String privKey, String pubkey, bool isTestnet) {
    int testnet = isTestnet ? 1 : 0;

    rawLibdogecoin.dogecoin_ecc_start();

    int result = rawLibdogecoin.verifyPrivPubKeypair(
        privKey.toNativeUtf8().cast<Char>(),
        pubkey.toNativeUtf8().cast<Char>(),
        testnet);

    rawLibdogecoin.dogecoin_ecc_stop();

    return result == 0 ? false : true;
  }

  static bool verifyHDMasterPubKeypair(
      String privKeyMaster, String pubkeyMaster, bool isTestnet) {
    int testnet = isTestnet ? 1 : 0;

    rawLibdogecoin.dogecoin_ecc_start();

    int result = rawLibdogecoin.verifyHDMasterPubKeypair(
        privKeyMaster.toNativeUtf8().cast<Char>(),
        pubkeyMaster.toNativeUtf8().cast<Char>(),
        testnet);

    rawLibdogecoin.dogecoin_ecc_stop();

    return result == 0 ? false : true;
  }

  static bool verifyP2pkhAddress(String p2pkhPubkey) {
    int result = rawLibdogecoin.verifyP2pkhAddress(
        p2pkhPubkey.toNativeUtf8().cast<Char>(), p2pkhPubkey.length);

    return result == 0 ? false : true;
  }

  // Transaction API

  static int startTransaction() {
    int result = rawLibdogecoin.start_transaction();
    return result;
  }

  static void clearTransaction(int index) {
    rawLibdogecoin.clear_transaction(index);
  }

  static bool addUtxo(int txindex, String hexUtxo, int vout) {
    int result = rawLibdogecoin.add_utxo(
        txindex, hexUtxo.toNativeUtf8().cast<Char>(), vout);

    return result == 0 ? false : true;
  }

  static bool addOutput(int txindex, String destinationaddress, String amount) {
    int result = rawLibdogecoin.add_output(
        txindex,
        destinationaddress.toNativeUtf8().cast<Char>(),
        amount.toNativeUtf8().cast<Char>());

    return result == 0 ? false : true;
  }

  static String finalizeTransaction(
      int txindex,
      String destinationaddress,
      String subtractedfee,
      String outDogeamountForVerification,
      String changeaddress) {
    Pointer<Char> rawResult = rawLibdogecoin.finalize_transaction(
        txindex,
        destinationaddress.toNativeUtf8().cast<Char>(),
        subtractedfee.toNativeUtf8().cast<Char>(),
        outDogeamountForVerification.toNativeUtf8().cast<Char>(),
        changeaddress.toNativeUtf8().cast<Char>());

    String result = rawResult.cast<Utf8>().toDartString();
    return result;
  }

  static String getRawTransaction(int txindex) {
    Pointer<Char> rawResult = rawLibdogecoin.get_raw_transaction(txindex);

    String result = rawResult.cast<Utf8>().toDartString();
    return result;
  }

  // TODO: Fix signRawTransaction() returns random invalid two UTF-8 chars at end.
  static String signRawTransaction(int inputindex, String incomingrawtx,
      String scripthex, int sighashtype, String privkey) {
    rawLibdogecoin.dogecoin_ecc_start();

    Pointer<Char> pointerRawTx = malloc(1024 * 100);
    pointerRawTx = incomingrawtx.toNativeUtf8().cast<Char>();

    int result = rawLibdogecoin.sign_raw_transaction(
        inputindex,
        pointerRawTx,
        scripthex.toNativeUtf8().cast<Char>(),
        sighashtype,
        privkey.toNativeUtf8().cast<Char>());

    rawLibdogecoin.dogecoin_ecc_stop();

    String strResult = "";

    if (result == 0) {
      strResult = "";
    } else {
      strResult = pointerRawTx.cast<Utf8>().toDartString();
    }

    malloc.free(pointerRawTx);

    return strResult;
  }

  static bool signTransaction(
      int txindex, String scriptPubkey, String privkey) {
    rawLibdogecoin.dogecoin_ecc_start();

    int result = rawLibdogecoin.sign_transaction(
        txindex,
        scriptPubkey.toNativeUtf8().cast<Char>(),
        privkey.toNativeUtf8().cast<Char>());

    rawLibdogecoin.dogecoin_ecc_stop();

    return result == 0 ? false : true;
  }

  static int storeRawTransaction(String incomingrawtx) {
    int result = rawLibdogecoin
        .store_raw_transaction(incomingrawtx.toNativeUtf8().cast<Char>());

    return result;
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
