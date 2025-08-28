import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tourism_app/core/themes/colors.dart';

class ForwardButton extends StatelessWidget {
  const ForwardButton({
    super.key,
    required this.pageController,
    required this.circularProgressValue,
  });

  final PageController pageController;
  final double circularProgressValue;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      },
      child: SizedBox(
        height: 50,
        width: 50,
        child: FittedBox(
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                strokeWidth: 3,
                value: circularProgressValue,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                backgroundColor: AppColors.primaryColor.withOpacity(0.2),
              ),
              Container(
                height: 22,
                width: 22,
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primaryColor),
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 12.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
