import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rickshaw_driver_app/features/history/ride_history.dart';
import 'package:rickshaw_driver_app/features/home/screens/home_screen.dart';
import 'package:rickshaw_driver_app/features/more/more_main_view.dart';
import 'package:rickshaw_driver_app/features/ride_requests/presentation/screens/incoming_rides_screen.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  const BottomNavigationBarScreen({super.key});

  @override
  State<BottomNavigationBarScreen> createState() => _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> {
  int selectIndex = 0;

  @override
  Widget build(BuildContext context) {
    Future<bool> onWillPop() async {
      if (selectIndex != 0) {
        setState(() {
          selectIndex = 0; // Navigate back to HomeScreen
        });
        return false; // Prevent popping the screen
      } else {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit Confirmation'),
            content: const Text('Are you sure you want to exit the app?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Exit'),
              ),
            ],
          ),
        ) ?? false;
      }
    }

    final List<Widget> _children = [
      const HomeScreen(),
      const IncomingRidesScreen(),
      const RideHistoryScreen(),
      const MoreOptionsScreen()
    ];

    return SafeArea(
      child: WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
          extendBody: true,
          bottomNavigationBar: NavigationBar(
            backgroundColor: Theme.of(context).primaryColor,
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            selectedIndex: selectIndex,
            onDestinationSelected: (index) {
              setState(() {
                selectIndex = index;
              });
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.request_page),
                label: 'Requests',
              ),
              NavigationDestination(
                icon: Icon(Icons.history),
                label: 'History',
              ),
              NavigationDestination(
                icon: Icon(Icons.more_vert),
                label: 'More',
              ),
            ],
          ),
          body: _children.elementAt(selectIndex),
        ),
      ),
    );
  }
}
