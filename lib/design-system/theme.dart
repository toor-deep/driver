import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

ThemeData get lightTheme => ThemeData(
      fontFamily: 'Nunito',
      colorScheme: const ColorScheme.light(
          primary: Colors.blue, secondary: Colors.white),
      iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.black))),
      scaffoldBackgroundColor: Colors.white,
      // Background is white
      cupertinoOverrideTheme: const CupertinoThemeData(
          primaryColor: Colors.blue, applyThemeToAll: true),
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
              textStyle: WidgetStateProperty.all(TextStyle(fontSize: 14.sp)),
              foregroundColor: WidgetStateProperty.all(Colors.blue))),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.blue; // Active color
          }
          return Colors.black; // Passive color
        }),
      ),
      appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          // AppBar background is white
          foregroundColor: Colors.black,
          // AppBar text and icon colors are black
          elevation: 1,
          centerTitle: true,
          titleTextStyle: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white)),
      inputDecorationTheme: InputDecorationTheme(
          contentPadding: const EdgeInsets.fromLTRB(8, 5.0, 0, 5.0),
          border: const OutlineInputBorder(),
          hintStyle: TextStyle(
            fontSize: 16.sp,
            color: Colors.black,
          ),

          suffixIconColor: Colors.black),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              textStyle: WidgetStateProperty.all(const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.white)),
              backgroundColor: MaterialStateProperty.all(Colors.blue),
              // Button color
              foregroundColor: MaterialStateProperty.all(Colors.white),
              // Text color
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0))),
              elevation: MaterialStateProperty.all(0.0),
              fixedSize: MaterialStateProperty.all(Size.fromHeight(40.h)))),
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
              textStyle: MaterialStateProperty.all(
                  const TextStyle(fontWeight: FontWeight.w600)),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0))),
              side: MaterialStateProperty.all(BorderSide(color: Colors.blue)),
              fixedSize: MaterialStateProperty.all(Size.fromHeight(30.h)))),
      useMaterial3: false,
    );

// Dark Theme: Black and White
ThemeData get DarkTheme => ThemeData(
      fontFamily: 'Nunito',
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: Colors.black, // Primary color set to black
        secondary: Colors.white, // Secondary color set to white
      ),
      scaffoldBackgroundColor: Colors.black,
      // Background is black
      cupertinoOverrideTheme: const CupertinoThemeData(
          primaryColor: Colors.white, applyThemeToAll: true),
      iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.black))),
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
              textStyle: MaterialStateProperty.all(TextStyle(fontSize: 14.sp)),
              foregroundColor: WidgetStateProperty.all(Colors.white))),
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.white; // Active color
          }
          return Colors.grey; // Passive color
        }),
      ),
      appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          // AppBar background is black
          foregroundColor: Colors.white,
          // AppBar text and icon colors are white
          elevation: 1,
          centerTitle: true,
          titleTextStyle: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white)),
      inputDecorationTheme: InputDecorationTheme(
          contentPadding: const EdgeInsets.fromLTRB(8, 5.0, 0, 5.0),
          border: const OutlineInputBorder(),
          hintStyle: TextStyle(
            fontSize: 16.sp,
            color: Colors.white70, // Hint text in white with some transparency
          ),
          suffixIconColor: Colors.white),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              textStyle: MaterialStateProperty.all(
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              backgroundColor: MaterialStateProperty.all(Colors.white),
              // Button color
              foregroundColor: MaterialStateProperty.all(Colors.black),
              // Text color
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0))),
              elevation: MaterialStateProperty.all(0.0),
              fixedSize: MaterialStateProperty.all(Size.fromHeight(40.h)))),
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
              textStyle: MaterialStateProperty.all(
                  const TextStyle(fontWeight: FontWeight.w600)),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0))),
              side: WidgetStateProperty.all(BorderSide(color: Colors.white)),
              fixedSize: WidgetStateProperty.all(Size.fromHeight(30.h)))),

      useMaterial3: false,
    );
