import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dropdown_alert/dropdown_alert.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:rickshaw_driver_app/features/google_map/bloc/location_cubit.dart';
import 'package:rickshaw_driver_app/features/ride_requests/presentation/bloc/ride_request_bloc.dart';
import 'package:rickshaw_driver_app/shared/constants.dart';
import 'package:rickshaw_driver_app/shared/state/app-theme/app_theme_cubit.dart';
import 'package:rickshaw_driver_app/splash_screen.dart';
import 'config/injections/dependencies.dart';
import 'core/routing.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth/auth_cubit.dart';
import 'features/auth/presentation/bloc/sign_in/sign_in_cubit.dart';
import 'features/auth/presentation/bloc/sign_up/sign_up_cubit.dart';
import 'features/current_user/presentation/bloc/user_cubit.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  injectDependencies();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<SignInCubit>()),
        BlocProvider(create: (context) => getIt<SignUpCubit>()),
        BlocProvider(create: (_) => getIt<ThemeCubit>()),
        BlocProvider(
          create: (context) => getIt<AuthCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<UserCubit>(),
        ),
        BlocProvider(
          create: (context) => LocationCubit(),
        ),
        BlocProvider(
          create: (context) => getIt<RideCubit>(),
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) => StyledToast(
        locale: const Locale('en', 'US'),
        textStyle: const TextStyle(fontSize: 16.0, color: Colors.white),
        // backgroundColor: const Color(0x99000000),
        borderRadius: BorderRadius.circular(5.0),
        textPadding:
            const EdgeInsets.symmetric(horizontal: 17.0, vertical: 10.0),
        toastPositions: StyledToastPosition.top,
        toastAnimation: StyledToastAnimation.slideFromTopFade,
        reverseAnimation: StyledToastAnimation.slideToTopFade,
        curve: Curves.easeIn,
        reverseCurve: Curves.easeOut,
        duration: const Duration(seconds: 3),
        animDuration: const Duration(milliseconds: 200),
        dismissOtherOnShow: true,
        fullWidth: false,
        isHideKeyboard: true,
        isIgnoring: true,
        child: BlocProvider(
          create: (context) => ThemeCubit(),
          child: BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              return MaterialApp(
                  navigatorKey: appNavigationKey,
                  title: kAppName,
                  debugShowCheckedModeBanner: false,
                  themeMode: ThemeMode.light,
                  debugShowMaterialGrid: false,
                  theme: AppTheme.data(state.isDarkMode),
                  builder: (context, child) => Stack(
                        children: [
                          child ?? const SizedBox(),
                          const DropdownAlert(
                            position: AlertPosition.TOP,
                          )
                        ],
                      ),
                  onGenerateRoute: generateRoute,
                  home: const SplashView());
            },
          ),
        ),
      ),
    );
  }
}
