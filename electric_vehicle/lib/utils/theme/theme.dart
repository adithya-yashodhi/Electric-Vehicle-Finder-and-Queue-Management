import 'package:flutter/material.dart';

import 'custom_theme/appbar_theme.dart';
import 'custom_theme/bottom_sheet_theme.dart';
import 'custom_theme/checkbox_theme.dart';
import 'custom_theme/chip_theme.dart';
import 'custom_theme/elevated_button_theme.dart';
import 'custom_theme/outlined_button_theme.dart';
import 'custom_theme/text_field_theme.dart';
import 'custom_theme/text_theme.dart';

class EVAppTheme {
  EVAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    primaryColor: const Color(0xff269E66),
    scaffoldBackgroundColor: Colors.white,
    textTheme: EVTextTheme.lightTextTheme,
    chipTheme: EVChipTheme.lightChipTheme,
    appBarTheme: EVAppBarTheme.lightAppBarTheme,
    checkboxTheme: EVCheckBoxTheme.lightCheckBoxTheme,
    bottomSheetTheme: EVBottomSheetTheme.lightBottomSheetTheme,
    elevatedButtonTheme: EVElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: EVOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: EVTextFieldTheme.lightInputDecorationTheme,
  );
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.dark,
    primaryColor: const Color(0xff269E66),
    scaffoldBackgroundColor: Colors.black,
    textTheme: EVTextTheme.darkTextTheme,
    chipTheme: EVChipTheme.darkChipTheme,
    appBarTheme: EVAppBarTheme.darkAppBarTheme,
    checkboxTheme: EVCheckBoxTheme.darkCheckBoxTheme,
    bottomSheetTheme: EVBottomSheetTheme.darkBottomSheetTheme,
    elevatedButtonTheme: EVElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: EVOutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: EVTextFieldTheme.darkInputDecorationTheme,
  );


}