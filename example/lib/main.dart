// ignore_for_file: avoid_print
import 'package:esim_check/esim_check.dart';

Future<void> main() async {
  // Returns true if the device has eSIM hardware, false otherwise.
  final supported = await EsimCheck.isSupported();
  print('eSIM supported: $supported');

  // Optional: correct the verdict for specific iOS model identifiers.
  final corrected = await EsimCheck.isSupported(
    includeIosModels: ['iPad19,3'], // cellular model the heuristic misses
    excludeIosModels: ['iPad18,4'], // WiFi-only model the heuristic matches
  );
  print('eSIM supported (corrected): $corrected');
}
