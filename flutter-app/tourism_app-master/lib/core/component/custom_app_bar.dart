import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tourism_app/core/component/custom_text.dart';
import 'package:tourism_app/core/themes/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconData icon;
  final IconData? transformIcon;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;

  const CustomAppBar({
    required this.title,
    this.icon = Icons.arrow_back,
    this.onBackPressed,
    this.transformIcon,
    super.key,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
        forceMaterialTransparency: true,
        foregroundColor: AppColors.backgroundColor,
        elevation: 0,
        backgroundColor: AppColors.backgroundColor,
        title: CustomText(
          text: title,
          color: AppColors.cBoldTextColor,
          fontSize: 20.sp,
          fontWeight: FontWeight.w500,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            icon,
            color: Colors.black,
          ),
          onPressed: onBackPressed ?? () => Navigator.pop(context),
        ),
        actions: actions);
  }

  @override
  Size get preferredSize => Size.fromHeight(75);
}
