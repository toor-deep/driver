import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rickshaw_driver_app/shared/app_images.dart';
import 'package:rickshaw_driver_app/shared/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _checkLoginState();
  }

  Future<void> _checkLoginState() async {
    await Future.delayed(const Duration(seconds: 2));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      Navigator.pushNamed(context, '/BottomBar');
    } else {
      Navigator.pushNamed(context, '/SignIn');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(image: AssetImage(AppImages.splash)),
            Spacing.hmed,
            // Text(kAppName,
            //     style: TextStyle(
            //       color: Theme.of(context).primaryColor,
            //       fontWeight: FontWeight.bold,
            //       fontSize: 40,
            //     )),
          ],
        ),
      ),
    );
  }
}
