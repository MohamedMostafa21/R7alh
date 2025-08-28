import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tourism_app/core/themes/colors.dart';
import 'package:tourism_app/core/utils/constants.dart';

ThemeData light = ThemeData(
  scaffoldBackgroundColor: AppColors.white,
  fontFamily: Constants.fontFamily,
  dividerTheme: DividerThemeData(color: AppColors.transparent),
  primaryColor: AppColors.primaryColor,
  textSelectionTheme: TextSelectionThemeData(
    selectionColor: AppColors.primaryColor.withOpacity(0.5),
    cursorColor: AppColors.primaryColor,
    selectionHandleColor: AppColors.primaryColor,
  ),
  appBarTheme: AppBarTheme(
    centerTitle: true,
    color: AppColors.transparent,
    elevation: 0,
    systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: AppColors.transparent, statusBarIconBrightness: Brightness.dark),
  ),
  cardTheme: CardThemeData(
    shape: ContinuousRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    color: AppColors.white,
  ),
);
