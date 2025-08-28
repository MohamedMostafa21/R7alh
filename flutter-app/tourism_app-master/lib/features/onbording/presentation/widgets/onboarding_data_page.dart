import 'package:flutter/material.dart';
import 'package:tourism_app/core/themes/colors.dart';
import 'package:tourism_app/core/utils/constants.dart';

class OnBoardingDataPage extends StatefulWidget {
  final int index;

  const OnBoardingDataPage({super.key, required this.index});

  @override
  State<OnBoardingDataPage> createState() => _OnBoardingDataPageState();
}

class _OnBoardingDataPageState extends State<OnBoardingDataPage> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Spacer(),
          Text(
            onboardingData[widget.index].title,
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(color: AppColors.white),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            onboardingData[widget.index].description,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.white),
          ),
          SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }
}
