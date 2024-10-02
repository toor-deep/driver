import 'package:flutter/material.dart';
import 'package:rickshaw_driver_app/features/history/ride_history.dart';
import 'package:rickshaw_driver_app/features/home/screens/home_screen.dart';
import 'package:rickshaw_driver_app/features/more/more_main_view.dart';
import 'package:rickshaw_driver_app/features/ride_requests/presentation/screens/incoming_rides_screen.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  const BottomNavigationBarScreen({super.key});

  @override
  State<BottomNavigationBarScreen> createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState
    extends State<BottomNavigationBarScreen> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    IncomingRidesScreen(),
    RideHistoryScreen(),
    MoreOptionsScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Requests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_vert),
            label: 'More',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        showUnselectedLabels: true,
        unselectedLabelStyle: const TextStyle(color: Colors.grey),
        selectedLabelStyle: const TextStyle(color: Colors.white),
        onTap: _onItemTapped,
      ),
    );
  }
}
