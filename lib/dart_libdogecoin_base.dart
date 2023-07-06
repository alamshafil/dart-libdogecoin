import 'dart:io';
import 'dart:ffi';
import 'package:ffi/ffi.dart';

import 'dart_libdogecoin_raw.dart' as libdogecoin;

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
// TODO: Improve error handling.
class LibDogecoin {
  // ECC

  /// Init static ecc context
  static void eccStart() => rawLibdogecoin.dogecoin_ecc_start();

  /// Destroys the static ecc context
  static void eccStop() => rawLibdogecoin.dogecoin_ecc_stop();

  // Address API

  /// Generates a private and public keypair (a wallet import format private key and a p2pkh ready-to-use corresponding dogecoin address)
  static Keypair generatePrivPubKeypair({bool isTestnet = false}) {
    int testnet = isTestnet ? 1 : 0;
    Pointer<Char> privKey = malloc.allocate(53);
    Pointer<Char> pubKey = malloc.allocate(35);

    rawLibdogecoin.generatePrivPubKeypair(privKey, pubKey, testnet);

    Keypair pair = Keypair(
      privKey.cast<Utf8>().toDartString(),
      pubKey.cast<Utf8>().toDartString(),
    );

    malloc.free(privKey);
    malloc.free(pubKey);

    return pair;
  }

  /// Generates a hybrid deterministic WIF master key and p2pkh ready-to-use corresponding dogecoin address.
  static HDKeypair generateHDMasterPubKeypair({bool isTestnet = false}) {
    int testnet = isTestnet ? 1 : 0;
    Pointer<Char> masterPrivKey = malloc.allocate(200);
    Pointer<Char> masterPubKey = malloc.allocate(35);

    rawLibdogecoin.generateHDMasterPubKeypair(
      masterPrivKey,
      masterPubKey,
      testnet,
    );

    HDKeypair pair = HDKeypair(
      masterPrivKey.cast<Utf8>().toDartString(),
      masterPubKey.cast<Utf8>().toDartString(length: 34),
    );

    malloc.free(masterPrivKey);
    malloc.free(masterPubKey);

    return pair;
  }

  /// Generates a new dogecoin address from a HD master key.
  static String generateDerivedHDPubkey(String masterPrivKey) {
    Pointer<Char> childPubKey = malloc.allocate(35);

    rawLibdogecoin.generateDerivedHDPubkey(
      masterPrivKey.toNativeUtf8().cast<Char>(),
      childPubKey,
    );

    String result = childPubKey.cast<Utf8>().toDartString();

    malloc.free(childPubKey);

    return result;
  }

  /// Verify that a private key and dogecoin address match.
  static bool verifyPrivPubKeypair(String privKey, String pubkey,
      {bool isTestnet = false}) {
    int testnet = isTestnet ? 1 : 0;

    int result = rawLibdogecoin.verifyPrivPubKeypair(
      privKey.toNativeUtf8().cast<Char>(),
      pubkey.toNativeUtf8().cast<Char>(),
      testnet,
    );

    return result == 0 ? false : true;
  }

  /// Verify that a HD Master key and a dogecoin address matches.
  static bool verifyHDMasterPubKeypair(
      String privKeyMaster, String pubkeyMaster,
      {bool isTestnet = false}) {
    int testnet = isTestnet ? 1 : 0;

    int result = rawLibdogecoin.verifyHDMasterPubKeypair(
      privKeyMaster.toNativeUtf8().cast<Char>(),
      pubkeyMaster.toNativeUtf8().cast<Char>(),
      testnet,
    );

    return result == 0 ? false : true;
  }

  /// Verify that a dogecoin address is valid.
  static bool verifyP2pkhAddress(String p2pkhPubkey) {
    int result = rawLibdogecoin.verifyP2pkhAddress(
      p2pkhPubkey.toNativeUtf8().cast<Char>(),
      p2pkhPubkey.length,
    );

    return result == 0 ? false : true;
  }

  /// Get derived hd address
  static String getDerivedHDAddress(String masterkey, int account,
      bool ischange, int addressindex, bool outprivkey) {
    Pointer<Char> outaddress = malloc.allocate(200);

    rawLibdogecoin.getDerivedHDAddress(
      masterkey.toNativeUtf8().cast<Char>(),
      account,
      (ischange == true) ? 1 : 0,
      addressindex,
      outaddress,
      (outprivkey == true) ? 1 : 0,
    );
    String result = outaddress.cast<Utf8>().toDartString();

    malloc.free(outaddress);

    return result;
  }

  /// Get derived hd address by custom path
  static String getDerivedHDAddressByPath(
      String masterkey, String derivedPath, bool outprivkey) {
    Pointer<Char> outaddress = malloc.allocate(200);

    rawLibdogecoin.getDerivedHDAddressByPath(
      masterkey.toNativeUtf8().cast<Char>(),
      derivedPath.toNativeUtf8().cast<Char>(),
      outaddress,
      (outprivkey == true) ? 1 : 0,
    );
    String result = outaddress.cast<Utf8>().toDartString();

    malloc.free(outaddress);

    return result;
  }

  // BIP 39 API

  /// Generates an English mnemonic phrase from given hex entropy
  static String generateEnglishMnemonic(String entropy, MnemonicSize size) {
    Pointer<Char> mnemonic = malloc.allocate(libdogecoin.MAX_MNEMONIC_SIZE);

    rawLibdogecoin.generateEnglishMnemonic(
      entropy.toNativeUtf8().cast<Char>(),
      size.value.toNativeUtf8().cast<Char>(),
      mnemonic,
    );
    String result = mnemonic.cast<Utf8>().toDartString();

    malloc.free(mnemonic);

    return result;
  }

  /// Generates a random (e.g. "128" or "256") English mnemonic phrase
  static String generateRandomEnglishMnemonic(MnemonicSize size) {
    Pointer<Char> mnemonic = malloc.allocate(libdogecoin.MAX_MNEMONIC_SIZE);

    rawLibdogecoin.generateRandomEnglishMnemonic(
      size.value.toNativeUtf8().cast<Char>(),
      mnemonic,
    );
    String result = mnemonic.cast<Utf8>().toDartString();

    malloc.free(mnemonic);

    return result;
  }

  /// Generates a seed from an mnemonic seedphrase
  static BIP32Seed dogecoinSeedFromMnemonic(String mnemonic, String pass) {
    Pointer<Uint8> seed = malloc.allocate(libdogecoin.MAX_SEED_SIZE);

    rawLibdogecoin.dogecoin_seed_from_mnemonic(
      mnemonic.toNativeUtf8().cast<Char>(),
      pass.toNativeUtf8().cast<Char>(),
      seed,
    );

    // Copy uint8_t array to dart int list
    List<int> seedList = [];
    for (int num in seed.asTypedList(libdogecoin.MAX_SEED_SIZE)) {
      seedList.add(num);
    }

    BIP32Seed result = BIP32Seed(seedList);

    malloc.free(seed);

    return result;
  }

  /// Generates a HD master key and p2pkh ready-to-use corresponding dogecoin address from a mnemonic
  static String getDerivedHDAddressFromMnemonic(int account, int index,
      BIP32ChangeLevel changeLevel, String mnemonic, String pass,
      {bool isTestnet = false}) {
    int testnet = isTestnet ? 1 : 0;
    Pointer<Char> p2pkhPubkey = malloc.allocate(35);

    rawLibdogecoin.getDerivedHDAddressFromMnemonic(
      account,
      index,
      changeLevel.value.toNativeUtf8().cast<Char>(),
      mnemonic.toNativeUtf8().cast<Char>(),
      pass.toNativeUtf8().cast<Char>(),
      p2pkhPubkey,
      testnet,
    );
    String result = p2pkhPubkey.cast<Utf8>().toDartString();

    malloc.free(p2pkhPubkey);

    return result;
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
    Pointer<Char> pointerRawTx = malloc(1024 * 100);
    pointerRawTx = incomingrawtx.toNativeUtf8().cast<Char>();

    int result = rawLibdogecoin.sign_raw_transaction(
        inputindex,
        pointerRawTx,
        scripthex.toNativeUtf8().cast<Char>(),
        sighashtype,
        privkey.toNativeUtf8().cast<Char>());

    String strResult = "";

    strResult = (result == 0)
        ? strResult = ""
        : strResult = pointerRawTx.cast<Utf8>().toDartString();

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
    int result = rawLibdogecoin.store_raw_transaction(
      incomingrawtx.toNativeUtf8().cast<Char>(),
    );
    return result;
  }

  // QR Code API

  /// **DO NOT USE** Populate an array of bits that represent qrcode pixels
  // TODO: Fix the failed assertion in qr.c
  static List<int> qrgenP2pkhToQrBits(String inP2pkh) {
    Pointer<Uint8> outBits = malloc.allocate(
      libdogecoin.qrcodegen_BUFFER_LEN_MAX * 4,
    );

    rawLibdogecoin.qrgen_p2pkh_to_qrbits(
      inP2pkh.toNativeUtf8().cast<Char>(),
      outBits.cast<Int>(),
    );

    // Copy uint8_t array to dart int list
    List<int> bitList = [];
    for (int num
        in outBits.asTypedList(libdogecoin.qrcodegen_BUFFER_LEN_MAX * 4)) {
      bitList.add(num);
    }

    malloc.free(outBits);

    return bitList;
  }

  /// Create a QR text formatted string (with line breaks) from an incoming p2pkh
  static String qrgenP2pkhToQrString(String inP2pkh) {
    Pointer<Char> outString = malloc.allocate(
      libdogecoin.qrcodegen_BUFFER_LEN_MAX * 4,
    );

    rawLibdogecoin.qrgen_p2pkh_to_qr_string(
      inP2pkh.toNativeUtf8().cast<Char>(),
      outString,
    );

    String result = outString.cast<Utf8>().toDartString();

    malloc.free(outString);

    return result;
  }

  /// Prints the given p2pkh addr as QR Code to the console.
  static void qrgenP2pkhConsolePrintToQr(String inP2pkh) {
    rawLibdogecoin.qrgen_p2pkh_consoleprint_to_qr(
      inP2pkh.toNativeUtf8().cast<Char>(),
    );
  }

  /// Creates a .png file with the filename outFilename, from string inString, w. size factor of SizeMultiplier.
  static bool qrgenStringToQrPngfile(
      String outFilename, String inString, int sizeMultiplier) {
    int result = rawLibdogecoin.qrgen_string_to_qr_pngfile(
      outFilename.toNativeUtf8().cast<Char>(),
      inString.toNativeUtf8().cast<Char>(),
      sizeMultiplier,
    );

    return result == 0 ? false : true;
  }

  /// Creates a .jpg file with the filename outFilename, from string inString, w. size factor of SizeMultiplier.
  static bool qrgenStringToQrJpgfile(
      String outFilename, String inString, int sizeMultiplier) {
    int result = rawLibdogecoin.qrgen_string_to_qr_jpgfile(
      outFilename.toNativeUtf8().cast<Char>(),
      inString.toNativeUtf8().cast<Char>(),
      sizeMultiplier,
    );

    return result == 0 ? false : true;
  }

  // Extra APIs

  /// Sign a message with a private key
  static String signMessage(String privkey, String msg) {
    Pointer<Int> result = rawLibdogecoin.sign_message(
      privkey.toNativeUtf8().cast<Char>(),
      msg.toNativeUtf8().cast<Char>(),
    );

    String sig = result.cast<Utf8>().toDartString();
    return sig;
  }

  /// Verify a message with a address
  static bool verifyMessage(String sig, String msg, String address) {
    int result = rawLibdogecoin.verify_message(
      sig.toNativeUtf8().cast<Char>(),
      msg.toNativeUtf8().cast<Char>(),
      address.toNativeUtf8().cast<Char>(),
    );
    return result == 0 ? false : true;
  }

  /// Get the moon
  static String moon() {
    Pointer<Char> result = rawLibdogecoin.moon();
    String moon = result.cast<Utf8>().toDartString();
    return moon;
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

/// Enum of possible mnemonic sizes: 128, 160, 192, 224, and 256
enum MnemonicSize {
  size_128("128"),
  size_160("160"),
  size_192("192"),
  size_224("224"),
  size_256("256");

  const MnemonicSize(this.value);
  final String value;
}

/// Enum of possible change levels: external (0), internal (1)
enum BIP32ChangeLevel {
  external("0"),
  internal("1");

  const BIP32ChangeLevel(this.value);
  final String value;
}

/// A class that handles a BIP 32 seed
class BIP32Seed {
  /// Raw uint8_t array
  late List<int> rawSeed;

  /// Convert raw seed to hex string
  String toHexString() {
    String hexSeed = "";
    for (int num in rawSeed) {
      hexSeed += num.toRadixString(16).padLeft(2, '0');
    }
    return hexSeed;
  }

  BIP32Seed(this.rawSeed);
}
