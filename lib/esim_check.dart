import 'package:flutter/services.dart';

class EsimCheck {
  static const _channel = MethodChannel('esim_check');

  static Future<bool> isSupported() async {
    return await _channel.invokeMethod<bool>('isSupported') ?? false;
  }
}
