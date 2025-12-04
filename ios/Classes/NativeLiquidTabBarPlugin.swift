import Flutter
import UIKit

public class NativeLiquidTabBarPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let factory = NativeTabBarFactory(messenger: registrar.messenger())
    registrar.register(factory, withId: "NativeTabBar")
  }
}
