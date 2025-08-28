import 'package:flutter/material.dart';
import 'package:tourism_app/core/utils/constants.dart';
import 'package:tourism_app/features/onbording/presentation/widgets/onboarding_data_page.dart';
import 'package:tourism_app/features/onbording/presentation/widgets/progress_indicator.dart';
import 'package:tourism_app/features/onbording/presentation/widgets/skip_button.dart';
class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  final PageController pageController = PageController();
  int currentIndex = 0;
  double circularProgressValue = 1 / 3;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (String image in onboardingImages) {
      precacheImage(AssetImage(image), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedContainer(
              decoration: BoxDecoration(image: DecorationImage(image: AssetImage(onboardingImages[currentIndex]), fit: BoxFit.fill)),
              duration: const Duration(milliseconds: 500),
              // child: Image.asset(
              //   onboardingImages[currentIndex],
              //   fit: BoxFit.fill,
              // ),
            ),
          ),
          Positioned.fill(
            child: PageView.builder(
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                  circularProgressValue = (currentIndex + 1) / 3;
                });
              },
              controller: pageController,
              itemCount: 3,
              itemBuilder: (context, index) {
                return OnBoardingDataPage(
                  index: index,
                );
              },
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: SkipButton(),
          ),
          Positioned(
            bottom: 10,
            left: 20,
            child: ProgressIndicatorWidget(pageController: pageController, circularProgressValue: circularProgressValue),
          ),
        ],
      ),
    );
  }
}
