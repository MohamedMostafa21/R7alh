import 'package:flutter/material.dart';
import 'package:tourism_app/core/themes/colors.dart';
import 'package:tourism_app/core/themes/styles.dart';


ThemeData dark = ThemeData(
  scaffoldBackgroundColor: AppColors.black,
  fontFamily: 'DM Sans',
  dividerTheme: DividerThemeData(color: AppColors.transparent),
  appBarTheme: AppBarTheme(
    color: AppColors.transparent,
    elevation: 0,
  ),
  textTheme: TextTheme(
    bodyLarge: Styles.style14400.copyWith(color: AppColors.white),
  ),
);
