import 'package:dart_libdogecoin/dart_libdogecoin.dart';
import 'package:test/test.dart';

void main() {
  group('Address tests', () {
    test('generatePrivPubKeypair() - mainnet', () {
      final keypair = LibDogecoin.generatePrivPubKeypair(false);
      expect(keypair, isNotNull);
    });
    test('generatePrivPubKeypair() - testnet', () {
      final keypair = LibDogecoin.generatePrivPubKeypair(true);
      expect(keypair, isNotNull);
    });
    test('generateHDMasterPubKeypair() - mainnet', () {
      final keypair = LibDogecoin.generateHDMasterPubKeypair(false);
      expect(keypair, isNotNull);
    });
    test('generateHDMasterPubKeypair() - testnet', () {
      final keypair = LibDogecoin.generateHDMasterPubKeypair(true);
      expect(keypair, isNotNull);
    });
    test('generateDerivedHDPubkey()', () {
      final keypair = LibDogecoin.generateHDMasterPubKeypair(false);
      final childPubKey =
          LibDogecoin.generateDerivedHDPubkey(keypair.masterPrivKey);
      expect(keypair, isNotNull);
      expect(childPubKey, isNotNull);
    });
    test('verifyPrivPubKeypair() - mainnet ', () {
      final keypair = LibDogecoin.generatePrivPubKeypair(false);
      bool isValid = LibDogecoin.verifyPrivPubKeypair(
          keypair.privKey, keypair.pubKey, false);
      expect(keypair, isNotNull);
      expect(isValid, isTrue);
    });
    test('verifyPrivPubKeypair() - testnet ', () {
      final keypair = LibDogecoin.generatePrivPubKeypair(true);
      bool isValid = LibDogecoin.verifyPrivPubKeypair(
          keypair.privKey, keypair.pubKey, true);
      expect(keypair, isNotNull);
      expect(isValid, isTrue);
    });
    test('verifyHDMasterPubKeypair() - mainnet ', () {
      final keypair = LibDogecoin.generateHDMasterPubKeypair(false);
      bool isValid = LibDogecoin.verifyHDMasterPubKeypair(
          keypair.masterPrivKey, keypair.masterPubKey, false);
      expect(keypair, isNotNull);
      expect(isValid, isTrue);
    });
    test('verifyHDMasterPubKeypair() - testnet ', () {
      final keypair = LibDogecoin.generateHDMasterPubKeypair(true);
      bool isValid = LibDogecoin.verifyHDMasterPubKeypair(
          keypair.masterPrivKey, keypair.masterPubKey, true);
      expect(keypair, isNotNull);
      expect(isValid, isTrue);
    });
    test('verifyP2pkhAddress() - mainnet ', () {
      final keypair = LibDogecoin.generatePrivPubKeypair(true);
      bool isValid = LibDogecoin.verifyP2pkhAddress(keypair.pubKey);
      expect(keypair, isNotNull);
      expect(isValid, isTrue);
    });
    test('verifyP2pkhAddress() - testnet ', () {
      final keypair = LibDogecoin.generatePrivPubKeypair(false);
      bool isValid = LibDogecoin.verifyP2pkhAddress(keypair.pubKey);
      expect(keypair, isNotNull);
      expect(isValid, isTrue);
    });
  });

  group('Transaction tests', () {
    test('startTransaction()', () {
      final index = LibDogecoin.startTransaction();
      LibDogecoin.clearTransaction(index);
      expect(index, isNotNull);
    });
    test('addUtxo()', () {
      final index = LibDogecoin.startTransaction();

      String prevOutputTxid =
          "b4455e7b7b7acb51fb6feba7a2702c42a5100f61f61abafa31851ed6ae076074"; // worth 2 dogecoin
      int prevOuputN = 1;

      bool isValid = LibDogecoin.addUtxo(index, prevOutputTxid, prevOuputN);

      LibDogecoin.clearTransaction(index);

      expect(index, isNotNull);
      expect(isValid, isTrue);
    });
    test('addOutput()', () {
      final index = LibDogecoin.startTransaction();

      String prevOutputTxid =
          "42113bdc65fc2943cf0359ea1a24ced0b6b0b5290db4c63a3329c6601c4616e2"; // worth 10 dogecoin

      int prevOuputN = 1;
      String externalAddress = "nbGfXLskPh7eM1iG5zz5EfDkkNTo9TRmde";

      bool isValidUtxo = LibDogecoin.addUtxo(index, prevOutputTxid, prevOuputN);
      bool isValidAdd = LibDogecoin.addOutput(
          index, externalAddress, "5.0"); // 5 dogecoin to be sent

      LibDogecoin.clearTransaction(index);

      expect(index, isNotNull);
      expect(isValidUtxo, isTrue);
      expect(isValidAdd, isTrue);
    });
    test('finalizeTranscation()', () {
      final index = LibDogecoin.startTransaction();

      String prevOutputTxid2 =
          "b4455e7b7b7acb51fb6feba7a2702c42a5100f61f61abafa31851ed6ae076074"; // worth 2 dogecoin
      String prevOutputTxid10 =
          "42113bdc65fc2943cf0359ea1a24ced0b6b0b5290db4c63a3329c6601c4616e2"; // worth 10 dogecoin

      int prevOutputN2 = 1;
      int prevOutputN10 = 1;

      String externalAddress = "nbGfXLskPh7eM1iG5zz5EfDkkNTo9TRmde";
      String myAddress = "noxKJyGPugPRN4wqvrwsrtYXuQCk7yQEsy";

      LibDogecoin.addUtxo(index, prevOutputTxid2, prevOutputN2);
      LibDogecoin.addUtxo(index, prevOutputTxid10, prevOutputN10);
      LibDogecoin.addOutput(index, externalAddress, "5.0");

      // finalize transaction with min fee of 0.00226 doge on the input total of 12 dogecoin
      String rawhex = LibDogecoin.finalizeTransaction(
          index, externalAddress, "0.00226", "12.0", myAddress);

      LibDogecoin.clearTransaction(index);

      expect(index, isNotNull);
      expect(rawhex,
          "0100000002746007aed61e8531faba1af6610f10a5422c70a2a7eb6ffb51cb7a7b7b5e45b40100000000ffffffffe216461c60c629333ac6b40d29b5b0b6d0ce241aea5903cf4329fc65dc3b11420100000000ffffffff020065cd1d000000001976a9144da2f8202789567d402f7f717c01d98837e4325488ac30b4b529000000001976a914d8c43e6f68ca4ea1e9b93da2d1e3a95118fa4a7c88ac00000000");
    });
    test('getRawTransaction()', () {
      final index = LibDogecoin.startTransaction();
      String rawhex = LibDogecoin.getRawTransaction(index);
      expect(index, isNotNull);
      expect(rawhex, isNotNull);
      LibDogecoin.clearTransaction(index);
    });
    // TODO: Fix signRawTransaction()
    // test('signRawTransaction()', () {
    //   String prevOutputTxid2 =
    //       "b4455e7b7b7acb51fb6feba7a2702c42a5100f61f61abafa31851ed6ae076074"; // worth 2 dogecoin
    //   String prevOutputTxid10 =
    //       "42113bdc65fc2943cf0359ea1a24ced0b6b0b5290db4c63a3329c6601c4616e2"; // worth 10 dogecoin
    //   int prevOutputN2 = 1;
    //   int prevOutputN10 = 1;
    //   String externalAddress = "nbGfXLskPh7eM1iG5zz5EfDkkNTo9TRmde";
    //   String myAddress = "noxKJyGPugPRN4wqvrwsrtYXuQCk7yQEsy";
    //   String myScriptPubkey =
    //       "76a914d8c43e6f68ca4ea1e9b93da2d1e3a95118fa4a7c88ac";
    //   String myPrivkey = "ci5prbqz7jXyFPVWKkHhPq4a9N8Dag3TpeRfuqqC2Nfr7gSqx1fy";

    //   int index = LibDogecoin.startTransaction();
    //   LibDogecoin.addUtxo(index, prevOutputTxid2, prevOutputN2);
    //   LibDogecoin.addUtxo(index, prevOutputTxid10, prevOutputN10);
    //   LibDogecoin.addOutput(index, externalAddress, "5.0");
    //   LibDogecoin.finalizeTransaction(
    //       index, externalAddress, "0.00226", "12.0", myAddress);

    //   // sign both inputs of the current finalized transaction
    //   String rawhex = LibDogecoin.getRawTransaction(index);
    //   String halfSignedHex = LibDogecoin.signRawTransaction(
    //       0, rawhex, myScriptPubkey, 1, myPrivkey);
    //   String fullSignedHex = LibDogecoin.signRawTransaction(
    //       1, halfSignedHex, myScriptPubkey, 1, myPrivkey);

    //   print("The final signed transaction hex is: $fullSignedHex ");

    //   expect(index, isNotNull);
    //   LibDogecoin.clearTransaction(index);
    // });
    test('signTransaction()', () {
      String prevOutputTxid2 =
          "b4455e7b7b7acb51fb6feba7a2702c42a5100f61f61abafa31851ed6ae076074"; // worth 2 dogecoin
      String prevOutputTxid10 =
          "42113bdc65fc2943cf0359ea1a24ced0b6b0b5290db4c63a3329c6601c4616e2"; // worth 10 dogecoin
      int prevOutputN2 = 1;
      int prevOutputN10 = 1;
      String externalAddress = "nbGfXLskPh7eM1iG5zz5EfDkkNTo9TRmde";
      String myAddress = "noxKJyGPugPRN4wqvrwsrtYXuQCk7yQEsy";
      String myScriptPubkey =
          "76a914d8c43e6f68ca4ea1e9b93da2d1e3a95118fa4a7c88ac";
      String myPrivkey = "ci5prbqz7jXyFPVWKkHhPq4a9N8Dag3TpeRfuqqC2Nfr7gSqx1fy";

      int index = LibDogecoin.startTransaction();
      LibDogecoin.addUtxo(index, prevOutputTxid2, prevOutputN2);
      LibDogecoin.addUtxo(index, prevOutputTxid10, prevOutputN10);
      LibDogecoin.addOutput(index, externalAddress, "5.0");
      LibDogecoin.finalizeTransaction(
          index, externalAddress, "0.00226", "12.0", myAddress);

      // sign both inputs of the current finalized transaction
      bool isValid =
          LibDogecoin.signTransaction(index, myScriptPubkey, myPrivkey);

      String finalHex = LibDogecoin.getRawTransaction(index);

      LibDogecoin.clearTransaction(index);

      expect(index, isNotNull);
      expect(isValid, isTrue);
      expect(finalHex,
          "0100000002746007aed61e8531faba1af6610f10a5422c70a2a7eb6ffb51cb7a7b7b5e45b4010000006b48304502210090bddac300243d16dca5e38ab6c80d5848e0d710d77702223bacd6682654f6fe02201b5c2e8b1143d8a807d604dc18068b4278facce561c302b0c66a4f2a5a4aa66f0121031dc1e49cfa6ae15edd6fa871a91b1f768e6f6cab06bf7a87ac0d8beb9229075bffffffffe216461c60c629333ac6b40d29b5b0b6d0ce241aea5903cf4329fc65dc3b1142010000006a47304402200e19c2a66846109aaae4d29376040fc4f7af1a519156fe8da543dc6f03bb50a102203a27495aba9eead2f154e44c25b52ccbbedef084f0caf1deedaca87efd77e4e70121031dc1e49cfa6ae15edd6fa871a91b1f768e6f6cab06bf7a87ac0d8beb9229075bffffffff020065cd1d000000001976a9144da2f8202789567d402f7f717c01d98837e4325488ac30b4b529000000001976a914d8c43e6f68ca4ea1e9b93da2d1e3a95118fa4a7c88ac00000000");
    });
    test('storeRawTransaction()', () {
      String hexToStore =
          "0100000001746007aed61e8531faba1af6610f10a5422c70a2a7eb6ffb51cb7a7b7b5e45b40100000000ffffffff0000000000";
      int index = LibDogecoin.storeRawTransaction(hexToStore);
      expect(index, isNotNull);
      expect(LibDogecoin.getRawTransaction(index), hexToStore);
      LibDogecoin.clearTransaction(index);
    });
  });
}
