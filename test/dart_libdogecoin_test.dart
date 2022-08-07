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
}
