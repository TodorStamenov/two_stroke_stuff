import 'package:flutter/material.dart';
import 'package:two_stroke_stuff/pages/calculation_history.dart';
import 'package:two_stroke_stuff/pages/compression_ratio.dart';
import 'package:two_stroke_stuff/pages/port_timing.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedIndex = 0;
  static const List<Widget> widgetOptions = [
    PortTiming(),
    CompressionRatio(),
    CalculationHistory(),
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widgetOptions.elementAt(selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: 'Port',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card_sharp),
            label: 'Compression',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.deepPurple,
        onTap: onItemTapped,
      ),
    );
  }
}
