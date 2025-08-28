import 'package:flutter/material.dart';
import 'package:tourism_app/core/themes/colors.dart';


class CustomDividerWidget extends StatelessWidget {
  const CustomDividerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      thickness: 0.5,
      color: AppColors.primaryColor.withOpacity(0.2),
    );
  }
}
