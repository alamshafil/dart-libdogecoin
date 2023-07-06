import 'package:dart_libdogecoin/dart_libdogecoin.dart';
import 'package:test/test.dart';

void main() {
  group('Address tests', () {
    test('generatePrivPubKeypair() - mainnet', () {
      LibDogecoin.eccStart();
      final keypair = LibDogecoin.generatePrivPubKeypair(isTestnet: false);
      LibDogecoin.eccStop();
      expect(keypair, isNotNull);
    });

    test('generatePrivPubKeypair() - testnet', () {
      LibDogecoin.eccStart();
      final keypair = LibDogecoin.generatePrivPubKeypair(isTestnet: true);
      expect(keypair, isNotNull);
      LibDogecoin.eccStop();
    });

    test('generateHDMasterPubKeypair() - mainnet', () {
      LibDogecoin.eccStart();
      final keypair = LibDogecoin.generateHDMasterPubKeypair(isTestnet: false);
      expect(keypair, isNotNull);
      LibDogecoin.eccStop();
    });

    test('generateHDMasterPubKeypair() - testnet', () {
      LibDogecoin.eccStart();
      final keypair = LibDogecoin.generateHDMasterPubKeypair(isTestnet: true);
      expect(keypair, isNotNull);
      LibDogecoin.eccStop();
    });

    test('generateDerivedHDPubkey()', () {
      LibDogecoin.eccStart();
      final keypair = LibDogecoin.generateHDMasterPubKeypair(isTestnet: false);
      final childPubKey =
          LibDogecoin.generateDerivedHDPubkey(keypair.masterPrivKey);
      LibDogecoin.eccStop();
      expect(keypair, isNotNull);
      expect(childPubKey, isNotNull);
    });

    test('verifyPrivPubKeypair() - mainnet ', () {
      LibDogecoin.eccStart();
      final keypair = LibDogecoin.generatePrivPubKeypair(isTestnet: false);
      bool isValid = LibDogecoin.verifyPrivPubKeypair(
          keypair.privKey, keypair.pubKey,
          isTestnet: false);
      LibDogecoin.eccStop();
      expect(keypair, isNotNull);
      expect(isValid, isTrue);
    });

    test('verifyPrivPubKeypair() - testnet ', () {
      LibDogecoin.eccStart();
      final keypair = LibDogecoin.generatePrivPubKeypair(isTestnet: true);
      bool isValid = LibDogecoin.verifyPrivPubKeypair(
          keypair.privKey, keypair.pubKey,
          isTestnet: true);
      LibDogecoin.eccStop();
      expect(keypair, isNotNull);
      expect(isValid, isTrue);
    });

    test('verifyHDMasterPubKeypair() - mainnet ', () {
      LibDogecoin.eccStart();
      final keypair = LibDogecoin.generateHDMasterPubKeypair(isTestnet: false);
      bool isValid = LibDogecoin.verifyHDMasterPubKeypair(
          keypair.masterPrivKey, keypair.masterPubKey,
          isTestnet: false);
      LibDogecoin.eccStop();
      expect(keypair, isNotNull);
      expect(isValid, isTrue);
    });

    test('verifyHDMasterPubKeypair() - testnet ', () {
      LibDogecoin.eccStart();
      final keypair = LibDogecoin.generateHDMasterPubKeypair(isTestnet: true);
      bool isValid = LibDogecoin.verifyHDMasterPubKeypair(
          keypair.masterPrivKey, keypair.masterPubKey,
          isTestnet: true);
      LibDogecoin.eccStop();
      expect(keypair, isNotNull);
      expect(isValid, isTrue);
    });

    test('verifyP2pkhAddress() - mainnet ', () {
      LibDogecoin.eccStart();
      final keypair = LibDogecoin.generatePrivPubKeypair(isTestnet: true);
      LibDogecoin.eccStop();
      bool isValid = LibDogecoin.verifyP2pkhAddress(keypair.pubKey);
      expect(keypair, isNotNull);
      expect(isValid, isTrue);
    });

    test('verifyP2pkhAddress() - testnet ', () {
      LibDogecoin.eccStart();
      final keypair = LibDogecoin.generatePrivPubKeypair(isTestnet: false);
      LibDogecoin.eccStop();
      bool isValid = LibDogecoin.verifyP2pkhAddress(keypair.pubKey);
      expect(keypair, isNotNull);
      expect(isValid, isTrue);
    });

    test('getDerivedHDAddress()', () {
      LibDogecoin.eccStart();
      String masterkeyMainExt =
          "dgpv51eADS3spNJh8h13wso3DdDAw3EJRqWvftZyjTNCFEG7gqV6zsZmucmJR6xZfvgfmzUthVC6LNicBeNNDQdLiqjQJjPeZnxG8uW3Q3gCA3e";
      String res =
          LibDogecoin.getDerivedHDAddress(masterkeyMainExt, 0, false, 0, true);
      expect(res,
          "dgpv5BeiZXttUioRMzXUhD3s2uE9F23EhAwFu9meZeY9G99YS6hJCsQ9u6PRsAG3qfVwB1T7aQTVGLsmpxMiczV1dRDgzpbUxR7utpTRmN41iV7");
      res = LibDogecoin.getDerivedHDAddress(masterkeyMainExt, 0, true, 0, true);
      expect(res,
          "dgpv5B5FdsPKQH8hK3vUo5ZR9ZXktfUxv1PStiM2TfnwH9oct5nJwAUx28356eNXoUwcNwzvfVRSDVh85aV3CQdKpQo2Vm8MKyz7KsNAXTEMbeS");
      res =
          LibDogecoin.getDerivedHDAddress(masterkeyMainExt, 0, false, 0, false);
      expect(res,
          "dgub8vXjuDpn2sTkerBdjSfq9kmjhaQsXHxyBkYrikw84GCYz9ozcdwvYPo5SSDWqZUVT5d4jrG8CHiGsC1M7pdETPhoKiQa92znT2vG9YaytBH");
      res =
          LibDogecoin.getDerivedHDAddress(masterkeyMainExt, 0, true, 0, false);
      expect(res,
          "dgub8uxGyZKCxRo2buadqKBPGR5MMDrbk8RABK8EcnBv5GrdS8u1Lw2ifRSifsT3wuVRsK45b9kugWkd2cREzkJLiGvwbY5txG2dKfsY3bndC93");
      res =
          LibDogecoin.getDerivedHDAddress(masterkeyMainExt, 1, false, 1, true);
      expect(res,
          "dgpv5Ckgu5gakCr2g8NwFsi9aXXgBTXvzoFxwi8ybQHRmutQzYDoa8y4QD6w94EEYFtinVGD3ZzZG89t8pedriw9L8VgPYKeQsUHoZQaKcSEqwr");
      res = LibDogecoin.getDerivedHDAddress(masterkeyMainExt, 1, true, 1, true);
      expect(res,
          "dgpv5CnqDfc6af4vKYLZQfyGgYYVQcgkiGwqAm1qEirxruSwXwSQJoTLjSckPkbZDXRQs7X83esTtoBEmy4zr4UgJBHb8T1EMc6HYCsWgKk4JRh");
      res =
          LibDogecoin.getDerivedHDAddress(masterkeyMainExt, 1, false, 1, false);
      expect(res,
          "dgub8wdiEmcUJMWMxz36J7L7hP5Ge1uZpvHgEJvBkWgQa2wRYbLVyuWq3WWaiK3ZgYs893RqrgZN3QgRghPXkpRr7kdT44XVSaJuwMF1PTHi2mQ");
      res =
          LibDogecoin.getDerivedHDAddress(masterkeyMainExt, 1, true, 1, false);
      expect(res,
          "dgub8wfrZMXz8ojFcPziSubEoQ65sB4PYPyYTMo3PqFwf2Vx5zZ6ia17Nk2Py25c3dvq1e7ZnfBrurCS5wuagzRoBCXhJ2NeGU54NBytvuUuRyA");
      LibDogecoin.eccStop();
    });

    test('getDerivedHDAddressByPath()', () {
      LibDogecoin.eccStart();
      String masterkeyMainExt =
          "dgpv51eADS3spNJh8h13wso3DdDAw3EJRqWvftZyjTNCFEG7gqV6zsZmucmJR6xZfvgfmzUthVC6LNicBeNNDQdLiqjQJjPeZnxG8uW3Q3gCA3e";
      String res = LibDogecoin.getDerivedHDAddressByPath(
          masterkeyMainExt, "m/44'/3'/0'/0/0", true);
      expect(res,
          "dgpv5BeiZXttUioRMzXUhD3s2uE9F23EhAwFu9meZeY9G99YS6hJCsQ9u6PRsAG3qfVwB1T7aQTVGLsmpxMiczV1dRDgzpbUxR7utpTRmN41iV7");
      res = LibDogecoin.getDerivedHDAddressByPath(
          masterkeyMainExt, "m/44'/3'/0'/0/0", false);
      expect(res,
          "dgub8vXjuDpn2sTkerBdjSfq9kmjhaQsXHxyBkYrikw84GCYz9ozcdwvYPo5SSDWqZUVT5d4jrG8CHiGsC1M7pdETPhoKiQa92znT2vG9YaytBH");
      res = LibDogecoin.getDerivedHDAddressByPath(
          masterkeyMainExt, "m/44'/3'/0'/1/0", true);
      expect(res,
          "dgpv5B5FdsPKQH8hK3vUo5ZR9ZXktfUxv1PStiM2TfnwH9oct5nJwAUx28356eNXoUwcNwzvfVRSDVh85aV3CQdKpQo2Vm8MKyz7KsNAXTEMbeS");
      res = LibDogecoin.getDerivedHDAddressByPath(
          masterkeyMainExt, "m/44'/3'/0'/1/0", false);
      expect(res,
          "dgub8uxGyZKCxRo2buadqKBPGR5MMDrbk8RABK8EcnBv5GrdS8u1Lw2ifRSifsT3wuVRsK45b9kugWkd2cREzkJLiGvwbY5txG2dKfsY3bndC93");
      res = LibDogecoin.getDerivedHDAddressByPath(
          masterkeyMainExt, "m/44'/3'/1'/0/1", true);
      expect(res,
          "dgpv5Ckgu5gakCr2g8NwFsi9aXXgBTXvzoFxwi8ybQHRmutQzYDoa8y4QD6w94EEYFtinVGD3ZzZG89t8pedriw9L8VgPYKeQsUHoZQaKcSEqwr");
      res = LibDogecoin.getDerivedHDAddressByPath(
          masterkeyMainExt, "m/44'/3'/1'/0/1", false);
      expect(res,
          "dgub8wdiEmcUJMWMxz36J7L7hP5Ge1uZpvHgEJvBkWgQa2wRYbLVyuWq3WWaiK3ZgYs893RqrgZN3QgRghPXkpRr7kdT44XVSaJuwMF1PTHi2mQ");
      res = LibDogecoin.getDerivedHDAddressByPath(
          masterkeyMainExt, "m/44'/3'/1'/1/1", true);
      expect(res,
          "dgpv5CnqDfc6af4vKYLZQfyGgYYVQcgkiGwqAm1qEirxruSwXwSQJoTLjSckPkbZDXRQs7X83esTtoBEmy4zr4UgJBHb8T1EMc6HYCsWgKk4JRh");
      res = LibDogecoin.getDerivedHDAddressByPath(
          masterkeyMainExt, "m/44'/3'/1'/1/1", false);
      expect(res,
          "dgub8wfrZMXz8ojFcPziSubEoQ65sB4PYPyYTMo3PqFwf2Vx5zZ6ia17Nk2Py25c3dvq1e7ZnfBrurCS5wuagzRoBCXhJ2NeGU54NBytvuUuRyA");
      LibDogecoin.eccStop();
    });
  });

  group('BIP 39 tests', () {
    test('generateEnglishMnemonic() - Size 128', () {
      final mnemonic = LibDogecoin.generateEnglishMnemonic(
        "00000000000000000000000000000000",
        MnemonicSize.size_128,
      );
      expect(
        mnemonic,
        "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about",
      );
    });

    test('generateEnglishMnemonic() - Size 160', () {
      final mnemonic = LibDogecoin.generateEnglishMnemonic(
        "0000000000000000000000000000000000000000",
        MnemonicSize.size_160,
      );
      expect(
        mnemonic,
        "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon address",
      );
    });

    test('generateEnglishMnemonic() - Size 192', () {
      final mnemonic = LibDogecoin.generateEnglishMnemonic(
        "000000000000000000000000000000000000000000000000",
        MnemonicSize.size_192,
      );
      expect(
        mnemonic,
        "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon agent",
      );
    });

    test('generateEnglishMnemonic() - Size 224', () {
      final mnemonic = LibDogecoin.generateEnglishMnemonic(
        "00000000000000000000000000000000000000000000000000000000",
        MnemonicSize.size_224,
      );
      expect(
        mnemonic,
        "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon admit",
      );
    });

    test('generateEnglishMnemonic() - Size 256', () {
      final mnemonic = LibDogecoin.generateEnglishMnemonic(
        "0000000000000000000000000000000000000000000000000000000000000000",
        MnemonicSize.size_256,
      );
      expect(
        mnemonic,
        "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon art",
      );
    });

    test('generateRandomEnglishMnemonic() - Size 128', () {
      final mnemonic = LibDogecoin.generateRandomEnglishMnemonic(
        MnemonicSize.size_128,
      );
      expect(mnemonic, isNotNull);
    });

    test('generateRandomEnglishMnemonic() - Size 160', () {
      final mnemonic = LibDogecoin.generateRandomEnglishMnemonic(
        MnemonicSize.size_160,
      );
      expect(mnemonic, isNotNull);
    });

    test('generateRandomEnglishMnemonic() - Size 192', () {
      final mnemonic = LibDogecoin.generateRandomEnglishMnemonic(
        MnemonicSize.size_192,
      );
      expect(mnemonic, isNotNull);
    });

    test('generateRandomEnglishMnemonic() - Size 224', () {
      final mnemonic = LibDogecoin.generateRandomEnglishMnemonic(
        MnemonicSize.size_224,
      );
      expect(mnemonic, isNotNull);
    });

    test('generateRandomEnglishMnemonic() - Size 256', () {
      final mnemonic = LibDogecoin.generateRandomEnglishMnemonic(
        MnemonicSize.size_256,
      );
      expect(mnemonic, isNotNull);
    });

    test('dogecoinSeedFromMnemonic() - 1', () {
      final result = LibDogecoin.dogecoinSeedFromMnemonic(
        "chief prevent advice search broccoli dish pride grow evidence bicycle cushion lady",
        "TREZOR",
      );
      expect(
        result.toHexString(),
        "31113f96716b7d5b8d58a49c5e1f6d6300ff307b35eef3cecfdb97869e514ad330f0a7dcec4ed2feeebf8d2267ebfefeb149df84642ca091befd25ea15d36076",
      );
    });

    test('dogecoinSeedFromMnemonic() - 2', () {
      final result = LibDogecoin.dogecoinSeedFromMnemonic(
        "engine link summer museum gift sphere half void where long copper mandate push valve enhance",
        "TREZOR",
      );
      expect(
        result.toHexString(),
        "7de0820caafcfc0695724ed19c3f35531c1f290650a0b39c053e67175979ed05dfedc824dcf9ac38cbc014fa86a2836c5b5e3b9ab1b9f0f84a76c492a04665b0",
      );
    });

    test('getDerivedHDAddressFromMnemonic()', () {
      LibDogecoin.eccStart();
      final result = LibDogecoin.getDerivedHDAddressFromMnemonic(
        0,
        0,
        BIP32ChangeLevel.external,
        LibDogecoin.generateEnglishMnemonic(
          "00000000000000000000000000000000",
          MnemonicSize.size_128,
        ),
        "",
        isTestnet: true,
      );
      LibDogecoin.eccStop();

      expect(result, "nZVmfmUtKPmskB9Ds4P9GUJy9eYFqPKHqH");
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
        index,
        externalAddress,
        "5.0",
      ); // 5 dogecoin to be sent

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
        index,
        externalAddress,
        "0.00226",
        "12.0",
        myAddress,
      );

      LibDogecoin.clearTransaction(index);

      expect(index, isNotNull);
      expect(
        rawhex,
        "0100000002746007aed61e8531faba1af6610f10a5422c70a2a7eb6ffb51cb7a7b7b5e45b40100000000ffffffffe216461c60c629333ac6b40d29b5b0b6d0ce241aea5903cf4329fc65dc3b11420100000000ffffffff020065cd1d000000001976a9144da2f8202789567d402f7f717c01d98837e4325488ac30b4b529000000001976a914d8c43e6f68ca4ea1e9b93da2d1e3a95118fa4a7c88ac00000000",
      );
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
    //   LibDogecoin.eccStart();
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
    //    LibDogecoin.eccStop();
    //   expect(index, isNotNull);
    //   LibDogecoin.clearTransaction(index);
    // });

    test('signTransaction()', () {
      LibDogecoin.eccStart();
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
        index,
        externalAddress,
        "0.00226",
        "12.0",
        myAddress,
      );

      // sign both inputs of the current finalized transaction
      bool isValid =
          LibDogecoin.signTransaction(index, myScriptPubkey, myPrivkey);

      String finalHex = LibDogecoin.getRawTransaction(index);

      LibDogecoin.clearTransaction(index);

      LibDogecoin.eccStop();
      expect(index, isNotNull);
      expect(isValid, isTrue);
      expect(
        finalHex,
        "0100000002746007aed61e8531faba1af6610f10a5422c70a2a7eb6ffb51cb7a7b7b5e45b4010000006b48304502210090bddac300243d16dca5e38ab6c80d5848e0d710d77702223bacd6682654f6fe02201b5c2e8b1143d8a807d604dc18068b4278facce561c302b0c66a4f2a5a4aa66f0121031dc1e49cfa6ae15edd6fa871a91b1f768e6f6cab06bf7a87ac0d8beb9229075bffffffffe216461c60c629333ac6b40d29b5b0b6d0ce241aea5903cf4329fc65dc3b1142010000006a47304402200e19c2a66846109aaae4d29376040fc4f7af1a519156fe8da543dc6f03bb50a102203a27495aba9eead2f154e44c25b52ccbbedef084f0caf1deedaca87efd77e4e70121031dc1e49cfa6ae15edd6fa871a91b1f768e6f6cab06bf7a87ac0d8beb9229075bffffffff020065cd1d000000001976a9144da2f8202789567d402f7f717c01d98837e4325488ac30b4b529000000001976a914d8c43e6f68ca4ea1e9b93da2d1e3a95118fa4a7c88ac00000000",
      );
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

  group('QR Code tests', () {
    // TODO: Add test for qrgenP2pkhToQrBits once fixed
    test('qrgenP2pkhToQRString()', () {
      String stringQrCode = LibDogecoin.qrgenP2pkhToQrString(
        "nZVmfmUtKPmskB9Ds4P9GUJy9eYFqPKHqH",
      );
      expect(stringQrCode, isNotNull);
      expect(stringQrCode, isNotEmpty);
      expect(stringQrCode, isNot(0));
    });
  });

  group('Signing tests', () {
    test('Test #1', () {
      String msg = "Hello World!";
      String privkey = "QWCcckTzUBiY1g3GFixihAscwHAKXeXY76v7Gcxhp3HUEAcBv33i";
      String address = "D8mQ2sKYpLbFCQLhGeHCPBmkLJRi6kRoSg";
      LibDogecoin.eccStart();
      String sig = LibDogecoin.signMessage(privkey, msg);
      expect(LibDogecoin.verifyMessage(sig, msg, address), true);
      msg = "This is a new test message";
      expect(LibDogecoin.verifyMessage(sig, msg, address), false);
      msg = "Hello World!";
      expect(LibDogecoin.verifyMessage(sig, msg, address), true);
      LibDogecoin.eccStop();
    });
  });

  group('Moon test', () {
    test('moon()', () {
      String moon = LibDogecoin.moon();
      expect(moon, isNotNull);
      expect(moon, isNotEmpty);
      expect(moon, isNot(0));
    });
  });
}
