import 'package:flutter/material.dart';
import 'package:shikha/utils/theme/custom_themes/appbar_theme.dart';
import 'package:shikha/utils/theme/custom_themes/bottom_sheet_theme.dart';
import 'package:shikha/utils/theme/custom_themes/checkbox_theme.dart';
import 'package:shikha/utils/theme/custom_themes/chip_theme.dart';
import 'package:shikha/utils/theme/custom_themes/elevated_button_theme.dart';
import 'package:shikha/utils/theme/custom_themes/outlined_button_theme.dart';
import 'package:shikha/utils/theme/custom_themes/text_field_theme.dart';
import 'package:shikha/utils/theme/custom_themes/text_theme.dart';



class TAppTheme{
  TAppTheme._();

  static ThemeData lightTheme= ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness:Brightness.light,
    primaryColor: Colors.orange,
    scaffoldBackgroundColor: Colors.white,
    textTheme: TTextTheme.lightTextTheme,
    elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,
    chipTheme: TChipTheme.lightChipTheme,
    appBarTheme: TAppBarTheme.lightAppBarTheme,
    checkboxTheme: TCheckboxTheme.lightChechboxTheme,
    bottomSheetTheme: TButtonSheetTheme.lightBottomSheetTheme,
    outlinedButtonTheme: TOutlinesButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: TTextFormFieldTheme.lightInputDecorationTheme,

  );


  static ThemeData darkTheme= ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness:Brightness.dark,
    primaryColor: Colors.orange,
    scaffoldBackgroundColor: Colors.black,
    textTheme: TTextTheme.darkTextTheme,
    elevatedButtonTheme: TElevatedButtonTheme.darkElevatedButtonTheme,
    chipTheme: TChipTheme.darkChipTheme,
    appBarTheme: TAppBarTheme.darkAppBarTheme,
    checkboxTheme: TCheckboxTheme.darkChechboxTheme,
    bottomSheetTheme: TButtonSheetTheme.darkBottomSheetTheme,
    outlinedButtonTheme: TOutlinesButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: TTextFormFieldTheme.darkInputDecorationTheme,

  );




}