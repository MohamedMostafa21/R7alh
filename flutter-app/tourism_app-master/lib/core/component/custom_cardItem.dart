import 'package:flutter/material.dart';
import 'package:tourism_app/core/component/custom_text.dart';
import 'package:tourism_app/core/themes/colors.dart';
import 'package:tourism_app/core/utils/responsive_text.dart';

class CardItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const CardItem({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 2,
        margin: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.01),
        child: ListTile(
          leading: Icon(icon, color: AppColors.babyblue),
          title: CustomText(
            text: title,
            color: AppColors.cBoldTextColor,
            fontSize: getResponsiveFontSize(context, fontSize: 16),
            fontWeight: FontWeight.w600,
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 24,
            color: AppColors.iconsColor,
          ),
        ),
      ),
    );
  }
}
