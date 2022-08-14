import 'dart:io';
import 'dart:ffi';
import 'package:ffi/ffi.dart';

import '../libdogecoin_bindings.dart' as libdogecoin;

DynamicLibrary getLibrary() {
  if (Platform.isIOS) return DynamicLibrary.process();
  if (Platform.isAndroid) return DynamicLibrary.open("libdogecoin.so");
  if (Platform.isLinux) return DynamicLibrary.open("libdogecoin.so");
  if (Platform.isMacOS) return DynamicLibrary.open("libdogecoin.dylib");
  if (Platform.isWindows) return DynamicLibrary.open("libdogecoin.dll");
  return DynamicLibrary.process(); // Fall back
}

/// Low-level libdogecoin bindings.
final rawLibdogecoin = libdogecoin.libdogecoin(getLibrary());

/// High-level libdogecoin bindings.
class LibDogecoin {
  // Address API

  /// Generates a private and public keypair (a wallet import format private key and a p2pkh ready-to-use corresponding dogecoin address)
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

  /// Generates a hybrid deterministic WIF master key and p2pkh ready-to-use corresponding dogecoin address.
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

  /// Generates a new dogecoin address from a HD master key.
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

  /// Verify that a private key and dogecoin address match.
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

  /// Verify that a HD Master key and a dogecoin address matches.
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

  /// Verify that a dogecoin address is valid.
  static bool verifyP2pkhAddress(String p2pkhPubkey) {
    int result = rawLibdogecoin.verifyP2pkhAddress(
        p2pkhPubkey.toNativeUtf8().cast<Char>(), p2pkhPubkey.length);

    return result == 0 ? false : true;
  }

  // Transaction API

  /// Create a new dogecoin transaction
  ///
  /// Returns the [txindex] in memory of the transaction being worked on.
  static int startTransaction() {
    int result = rawLibdogecoin.start_transaction();
    return result;
  }

  /// Clear the transaction at (txindex) in memory.
  static void clearTransaction(int txindex) {
    rawLibdogecoin.clear_transaction(txindex);
  }

  /// Add a utxo to the transaction being worked on at [txindex] specifying the utxo's txid and vout.
  ///
  /// Returns true if successful.
  static bool addUtxo(int txindex, String hexUtxo, int vout) {
    int result = rawLibdogecoin.add_utxo(
        txindex, hexUtxo.toNativeUtf8().cast<Char>(), vout);

    return result == 0 ? false : true;
  }

  /// Add an output to the transaction being worked on at [txindex] of amount [vout] in dogecoins.
  ///
  /// Returns true if successful.
  static bool addOutput(int txindex, String destinationaddress, String amount) {
    int result = rawLibdogecoin.add_output(
        txindex,
        destinationaddress.toNativeUtf8().cast<Char>(),
        amount.toNativeUtf8().cast<Char>());

    return result == 0 ? false : true;
  }

  /// Finalize the transaction being worked on at [txindex], with the [destinationaddress] paying a fee of [subtractedfee],
  /// re-specify the amount in dogecoin for verification, and change address for change. If not specified, change will go to the first utxo's address.
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

  /// Retrieve the raw transaction at [txindex] as a hex string.
  static String getRawTransaction(int txindex) {
    Pointer<Char> rawResult = rawLibdogecoin.get_raw_transaction(txindex);

    String result = rawResult.cast<Utf8>().toDartString();
    return result;
  }

  /// **DO NOT USE** Sign a raw transaction hexadecimal string using inputindex, scripthex, sighashtype and privkey.
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

  /// Sign a raw transaction in memory at [txindex], sign [inputindex] with [scripthex] of [sighashtype], with [privkey].
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

  /// Store a raw transaction that's already formed, and give it a txindex in memory. (txindex) is returned as int.
  static int storeRawTransaction(String incomingrawtx) {
    int result = rawLibdogecoin
        .store_raw_transaction(incomingrawtx.toNativeUtf8().cast<Char>());

    return result;
  }
}

/// A class to hold a private key [privKey] and public key [pubKey].
class Keypair {
  /// Private key
  late String privKey;

  /// Public key
  late String pubKey;

  Keypair(this.privKey, this.pubKey);
}

/// A class to hold a HD master private key [masterPrivKey] and HD master public key [masterPubKey].
class HDKeypair {
  /// HD master private key
  late String masterPrivKey;

  // HD master public key
  late String masterPubKey;

  HDKeypair(this.masterPrivKey, this.masterPubKey);
}
