import 'package:flutter/material.dart';
import 'package:native_liquid_tab_bar/native_liquid_tab_bar.dart';

void main() {
  runApp(const MaterialApp(home: BasicTwoTabsApp()));
}

class BasicTwoTabsApp extends StatefulWidget {
  const BasicTwoTabsApp({super.key});

  @override
  State<BasicTwoTabsApp> createState() => _BasicTwoTabsAppState();
}

class _BasicTwoTabsAppState extends State<BasicTwoTabsApp> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        useMaterial3: true,
        brightness: Theme.of(context).brightness,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Theme.of(context).brightness,
        ),
      ),
      child: Scaffold(
        extendBody: true, // NOTE - Enable to allow elements to be drawn behind the tab bar
        appBar: AppBar(title: const Text('Basic 2 Tabs Example')),
        body: Center(
          child: Text(
            'Selected Index: $_currentIndex',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        bottomNavigationBar: NativeLiquidTabBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          tabs: const [
            NativeTabBarItem(label: 'Home', symbol: 'house.fill'),
            NativeTabBarItem(label: 'Settings', symbol: 'gear'),
          ],
        ),
      ),
    );
  }
}
