import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tourism_app/core/themes/colors.dart';
import 'package:tourism_app/core/utils/responsive_text.dart';

class OnboardingPage extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  const OnboardingPage(
      {super.key,
      required this.image,
      required this.title,
      required this.description});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            image,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 50.h,
          right: 4,
          child: Text(
            'Skip',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: AppColors.appTextColor,
                fontSize: getResponsiveFontSize(context, fontSize: 16)),
          ),
        ),
        Positioned(
          top: 680.h,
          left: 3,
          right: 3,
          child: Column(
            children: [
              Text(
                title,
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: AppColors.appTextColor,
                    fontSize: getResponsiveFontSize(context, fontSize: 28)),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .02,
              ),
              Text(
                textAlign: TextAlign.left,
                description,
                style: TextStyle(
                    color: AppColors.appTextColor,
                    fontSize: getResponsiveFontSize(context, fontSize: 14)),
              ),
            ],
          ),
        )
      ],
    );
  }
}
