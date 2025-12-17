export 'liquid_glass_helper.dart';

import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:native_liquid_tab_bar/liquid_glass_helper.dart';

class NativeTabBarItem {
  final String label;
  final String symbol;

  const NativeTabBarItem({required this.label, required this.symbol});
}

class TabBarActionButton {
  final String symbol;
  final VoidCallback onTap;

  const TabBarActionButton({required this.symbol, required this.onTap});
}

class NativeLiquidTabBar extends StatefulWidget {
  final List<NativeTabBarItem> tabs;
  final TabBarActionButton? actionButton;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final Color? tintColor;
  final Widget? fallback;

  const NativeLiquidTabBar({
    super.key,
    required this.tabs,
    this.actionButton,
    required this.currentIndex,
    required this.onTap,
    this.tintColor,
    this.fallback,
  }) : assert(
         tabs.length <= (actionButton == null ? 5 : 4),
         actionButton == null
             ? 'NativeLiquidTabBar supports a maximum of 5 tabs.'
             : 'NativeLiquidTabBar with an action button supports a maximum of 4 tabs.',
       );

  @override
  State<NativeLiquidTabBar> createState() => _NativeLiquidTabBarState();
}

class _NativeLiquidTabBarState extends State<NativeLiquidTabBar> {
  MethodChannel? _channel;
  late Future<bool> _supportLiquidGlassFuture;

  void _updateNativeView() {
    if (_channel != null) {
      _channel!.invokeMethod('update', _createParams());
    }
  }

  Future<bool> checkLiquidGlassSupport() async {
    if (defaultTargetPlatform != TargetPlatform.iOS) {
      return false;
    }

    return await LiquidGlassHelper.isLiquidGlassSupported();
  }

  Map<String, dynamic> _createParams() {
    return {
      'labels': widget.tabs.map((e) => e.label).toList(),
      'symbols': widget.tabs.map((e) => e.symbol).toList(),
      'actionButtonSymbol': widget.actionButton?.symbol,
      'selectedIndex': widget.currentIndex,
      'isDark': Theme.of(context).brightness == Brightness.dark,
      'tintColor': widget.tintColor != null
          ? widget.tintColor!.toARGB32()
          : Theme.of(context).colorScheme.primary.toARGB32(),
    };
  }

  @override
  void initState() {
    super.initState();
    _supportLiquidGlassFuture = checkLiquidGlassSupport();
  }

  @override
  void didUpdateWidget(NativeLiquidTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateNativeView();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _supportLiquidGlassFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        }

        if (snapshot.data != true) {
          if (widget.fallback != null) {
            return widget.fallback!;
          }

          if (kDebugMode) {
            developer.log(
              'Liquid glass effect is not supported on this device. '
              'Falling back to an empty widget. Provide a `fallback` widget to handle this case.',
              name: 'NativeLiquidTabBar',
              level: 900,
            );
          }
          return const SizedBox.shrink();
        }

        final bottomPadding = MediaQuery.of(context).padding.bottom;
        // Standard tab bar height is 49. Add bottom padding for safe area.
        final height = 49.0 + bottomPadding;

        return SizedBox(
          height: height,
          child: UiKitView(
            viewType: 'NativeTabBar',
            creationParams: _createParams(),
            creationParamsCodec: const StandardMessageCodec(),
            onPlatformViewCreated: (id) {
              _channel = MethodChannel('NativeTabBar_$id');
              _channel!.setMethodCallHandler((call) async {
                if (call.method == 'valueChanged') {
                  final index = call.arguments['index'] as int;
                  widget.onTap(index);
                }

                if (call.method == 'actionButtonPressed') {
                  widget.actionButton?.onTap();
                }
              });
            },
          ),
        );
      },
    );
  }
}
