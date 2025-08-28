import 'package:flutter/material.dart';
import 'package:tourism_app/core/themes/colors.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final double height;
  final String? fontFamily;
  final TextAlign textAlign; 

  const CustomText({
    super.key,
    required this.text,
    this.fontSize = 24.0,
    this.fontWeight = FontWeight.w500,
    this.color = AppColors.appTextColor,
    
    this.height = 1.2,
    this.fontFamily,
    this.textAlign = TextAlign.start, 
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign, 
      style: TextStyle(
        fontWeight: fontWeight,
        fontSize: fontSize,
        color: color,
        height: height,
        fontFamily: fontFamily,
      ),
    );
  }
}
