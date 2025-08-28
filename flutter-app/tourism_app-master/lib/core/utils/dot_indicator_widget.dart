import 'package:flutter/material.dart';
import 'package:tourism_app/core/themes/colors.dart';

class DotIndicator extends StatelessWidget {
  final Color selectedColor;

  const DotIndicator({
    super.key,
    required this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 8,
      height: 8,
      decoration: ShapeDecoration(
        color: selectedColor.withOpacity(selectedColor == AppColors.textColor ? 1 : .3),
        shape: const OvalBorder(),
      ),
    );
  }
}
