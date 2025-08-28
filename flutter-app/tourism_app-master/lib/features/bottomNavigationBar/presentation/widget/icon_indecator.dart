
import 'package:flutter/material.dart';
import 'package:tourism_app/core/themes/colors.dart';

class IconIndicator extends StatelessWidget {
  const IconIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primaryColor,
      ),
      height: 7,
      width: 7,
    );
  }
}

