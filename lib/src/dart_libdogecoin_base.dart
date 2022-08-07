import 'dart:ffi';
import 'package:ffi/ffi.dart';

import '../libdogecoin_bindings.dart' as libdoge;

final libdogecoin =
    libdoge.libdogecoin(DynamicLibrary.open("/usr/local/lib/libdogecoin.so"));

class LibDogecoin {
  static Keypair generatePrivPubKeypair() {
    Pointer<Char> privKey = malloc.allocate(53);
    Pointer<Char> pubKey = malloc.allocate(35);

    libdogecoin.dogecoin_ecc_start();

    libdogecoin.generatePrivPubKeypair(privKey, pubKey, 0);

    libdogecoin.dogecoin_ecc_stop();

    Keypair pair = Keypair(privKey.cast<Utf8>().toDartString(),
        pubKey.cast<Utf8>().toDartString());

    malloc.free(privKey);
    malloc.free(pubKey);

    return pair;
  }
}

class Keypair {
  late String privKey;
  late String pubKey;
  Keypair(this.privKey, this.pubKey);
}
