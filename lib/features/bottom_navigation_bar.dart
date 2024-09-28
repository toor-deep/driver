import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
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
  final _controller = NotchBottomBarController(index: 0);
  int maxCount = 4;
  bool isDrawerOpen = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  final List<Widget> bottomBarPages = [
    const HomeScreen(),
    // MapSample(),
    const IncomingRidesScreen(),
    const RideHistoryScreen(),
    const MoreOptionsScreen()
  ];

  Future<bool> _onWillPop() async {
    if (_pageController.page != 0) {
      _pageController.jumpToPage(0);
      setState(() {
        _controller.index = 0;
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
          children: List.generate(
            bottomBarPages.length,
            (index) => bottomBarPages[index],
          ),
        ),
        extendBody: true,
        bottomNavigationBar: (bottomBarPages.length <= maxCount)
            ? AnimatedNotchBottomBar(
                notchBottomBarController: _controller,
                color: Theme.of(context).primaryColor,
                showLabel: true,
                itemLabelStyle:
                    const TextStyle(color: Colors.white, fontSize: 12),
                notchColor: Theme.of(context).primaryColor,
                removeMargins: false,
                bottomBarWidth: 500,
                durationInMilliSeconds: 300,
                bottomBarItems: const [
                  BottomBarItem(
                    inActiveItem: Icon(
                      Icons.home,
                      color: Colors.white,
                    ),
                    activeItem: Icon(
                      Icons.home,
                      color: Colors.white,
                    ),
                    itemLabel: 'Home',
                  ),
                  BottomBarItem(
                    inActiveItem:
                        Icon(Icons.type_specimen, color: Colors.white),
                    activeItem: Icon(
                      Icons.type_specimen,
                      color: Colors.white,
                    ),
                    itemLabel: 'Requests',
                  ),
                  BottomBarItem(
                    inActiveItem:
                        Icon(Icons.question_answer, color: Colors.white),
                    activeItem: Icon(
                      Icons.question_answer,
                      color: Colors.white,
                    ),
                    itemLabel: 'History',
                  ),
                  BottomBarItem(
                    inActiveItem: Icon(Icons.person, color: Colors.white),
                    activeItem: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    itemLabel: 'More',
                  ),
                ],
                onTap: (index) {
                  _pageController.jumpToPage(index);
                },
                kIconSize: 24,
                // Adjust the icon size
                kBottomRadius: 16.0, // Adjust the bottom radius
              )
            : null,
      ),
    );
  }
}
