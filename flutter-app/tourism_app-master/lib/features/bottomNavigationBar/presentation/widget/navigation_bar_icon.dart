import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tourism_app/core/themes/colors.dart';
import 'package:tourism_app/core/utils/app_icons.dart';
import 'package:tourism_app/features/bottomNavigationBar/presentation/widget/icon_indecator.dart';

class NavBarItem extends StatelessWidget {
  const NavBarItem({
    super.key,
    required this.index,
    required this.currentIndex,
    required this.onTap,
  });

  final int index;
  final int currentIndex;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool isSelected = currentIndex == index;

    return SizedBox(
      width: 30,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                isSelected ? selectedNavBarIcons[index] : unSelectedNavBarIcons[index],
                height: 24,
                width: 24,
                colorFilter: ColorFilter.mode(
                  isSelected ? AppColors.primaryColor : Colors.grey,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(height: 5),
              if (isSelected) const IconIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
List<String> selectedNavBarIcons = [
  AppIcons.homePageSelected,
  AppIcons.guideSelected,
  AppIcons.cameraSelected,
  AppIcons.plansSelected,
  AppIcons.menuSelected,
];
List<String> unSelectedNavBarIcons = [
  AppIcons.homePageUnSelected,
  AppIcons.guideUnSelected,
  AppIcons.cameraUnSelected,
  AppIcons.plansUnSelected,
  AppIcons.menuUnSelected,
];
