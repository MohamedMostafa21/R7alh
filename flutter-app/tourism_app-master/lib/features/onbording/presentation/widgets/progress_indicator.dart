import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tourism_app/core/themes/colors.dart';
import 'package:tourism_app/core/utils/navigate.dart';
import 'package:tourism_app/features/authentication/login/login_view.dart';
import 'package:tourism_app/features/onbording/presentation/widgets/forward_button.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  const ProgressIndicatorWidget({
    super.key,
    required this.pageController,
    required this.circularProgressValue,
  });

  final PageController pageController;
  final double circularProgressValue;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width - 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SmoothPageIndicator(
            controller: pageController,
            count: 3,
            effect: ExpandingDotsEffect(
              dotHeight: 10,
              dotWidth: 10,
              activeDotColor: AppColors.primaryColor,
              dotColor: AppColors.primaryColor.withOpacity(0.2),
            ),
          ),
          circularProgressValue == 1.0
              ? ElevatedButton(
                  onPressed: () {
                    context.navigateToPageWithReplacement(LoginView());
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: AppColors.primaryColor,
                  ),
                  child: Text('Start'),
                )
              : ForwardButton(pageController: pageController, circularProgressValue: circularProgressValue),
        ],
      ),
    );
  }
}
