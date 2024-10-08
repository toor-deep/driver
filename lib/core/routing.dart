
import 'package:flutter/material.dart';
import 'package:rickshaw_driver_app/features/bottom_navigation_bar.dart';
import 'package:rickshaw_driver_app/features/more/screens/privacy_policy.dart';
import 'package:rickshaw_driver_app/features/more/screens/terms_and_conditions.dart';

import '../features/auth/presentation/screens/sign_in_screen.dart';
import '../features/auth/presentation/screens/sign_up_screen.dart';
import '../features/history/ride_history.dart';
import '../features/more/screens/my_wallet.dart';
import '../features/more/screens/profile_screen.dart';
import '../features/more/screens/settings/change_password.dart';
import '../features/more/screens/settings/settings.dart';
import '../features/ride_requests/presentation/screens/distance_tracking_screen.dart';
import '../main.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(
        builder: (context) => const MyApp(),
      );
    case '/BottomBar':
      return MaterialPageRoute(
          builder: (context) => const BottomNavigationBarScreen());
    case '/SignIn':
      return MaterialPageRoute(
        builder: (context) => const SignInScreen(),
      );
    case '/SignUp':
      return MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      );
    case '/MyProfile':
      return MaterialPageRoute(
        builder: (context) => const MyProfile(),
      );

    case '/Settings':
      return MaterialPageRoute(
        builder: (context) => const Settings(),
      );

    case '/ChangePassword':
      return MaterialPageRoute(
        builder: (context) => const ChangePasswordScreen(),
      );

    case '/MyWallet':
      return MaterialPageRoute(
        builder: (context) => const WalletScreen(),
      );
    case '/Privacy':
      return MaterialPageRoute(
        builder: (context) => const PrivacyPolicyScreen(),
      );
    case '/Terms':
      return MaterialPageRoute(
        builder: (context) => const TermsOfServiceScreen(),
      );
    case '/RideHistory':
      return MaterialPageRoute(
        builder: (context) => const RideHistoryScreen(),
      );
    case '/DistanceTracking':
      return MaterialPageRoute(
        builder: (context) => const DistanceTrackingScreen(requestId: '',),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: Center(
            child: Text('Page not found'),
          ),
        ),
      );
  }
}
