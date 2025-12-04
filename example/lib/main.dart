import 'package:flutter/material.dart';
import 'package:native_liquid_tab_bar/native_liquid_tab_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: MediaQuery.of(context).platformBrightness,
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('Native Liquid Tab Bar Example')),
        body: Center(child: Text('Selected Index: $_currentIndex')),
        bottomNavigationBar: NativeLiquidTabBar(
          tabs: const [
            NativeTabBarItem(label: 'Home', symbol: 'heart.fill'),
            NativeTabBarItem(label: 'Search', symbol: 'magnifyingglass'),
            NativeTabBarItem(label: 'Settings', symbol: 'gear'),
          ],
          actionButton: TabBarActionButton(
            symbol: 'plus',
            onTap: () {
              print('Action button tapped');
            },
          ),
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          tintColor: Colors.blue,
        ),
      ),
    );
  }
}
