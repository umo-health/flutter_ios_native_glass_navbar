import 'dart:io';
import 'package:flutter/services.dart';

class LiquidGlassHelper {
  static const MethodChannel _channel = MethodChannel('native_liquid_tab_bar');

  static Future<bool> isLiquidGlassSupported() async {
    if (!Platform.isIOS) return false;
    try {
      final bool supported = await _channel.invokeMethod('isLiquidGlassSupported');
      return supported;
    } on PlatformException {
      return false;
    }
  }
}
