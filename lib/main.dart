import 'package:druglog2/pages/DrugPage.dart';
import 'package:druglog2/pages/LogsPage.dart';
import 'package:druglog2/pages/TestPage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() async {
  runApp(const Main());
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    LogPage(),
    DrugPage(),
    TestPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.light),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'DrugLog 2',
          ),
        ),
        body: Scaffold(
          body: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Logs',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business),
              label: 'Drugs',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bed),
              label: 'Test Page',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
