import 'package:flutter/material.dart';
import 'package:rickshaw_driver_app/features/google_map/map_screen.dart';
import 'package:rickshaw_driver_app/features/history/ride_history.dart';
import 'package:rickshaw_driver_app/features/home/screens/home_screen.dart';
import 'package:rickshaw_driver_app/features/ride_requests/incoming_rides_screen.dart';
import 'more/more_main_view.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  const BottomNavigationBarScreen({super.key});

  @override
  _BottomNavigationBarScreenState createState() =>
      _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> {
  final _pageController = PageController(initialPage: 0);
  int _selectedIndex = 0;

  final List<Widget> _bottomBarPages = [
    const HomeScreen(),
    const IncomingRidesScreen(),
    const RideHistoryScreen(),
    const MoreOptionsScreen(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  Future<bool> _onWillPop() async {
    if (_pageController.page != 0) {
      _pageController.jumpToPage(0);
      setState(() {
        _selectedIndex = 0;
      });
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: _bottomBarPages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Colors.white,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.type_specimen,
                color: Colors.white,
              ),
              label: 'Requests',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.question_answer,
                color: Colors.white,
              ),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              label: 'More',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          unselectedIconTheme: const IconThemeData(color: Colors.grey),
          selectedLabelStyle: const TextStyle(color: Colors.white),
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}
