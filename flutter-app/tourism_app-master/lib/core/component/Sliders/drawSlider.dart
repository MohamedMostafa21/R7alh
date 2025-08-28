import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tourism_app/core/utils/extensions.dart';

class DrawSlider extends StatelessWidget {
  final Color? sliderColor;
  final double valueSlider;

  const DrawSlider({super.key, this.sliderColor = Colors.black, required this.valueSlider});

  @override
  Widget build(BuildContext context) {
    final double width = context.screenWidth * .2;
    final double height = context.screenHeight * .003;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4).h,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Container(
            height: height,
            width: width,
            decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(5.r)),
          ),
          Container(
            width: width * (valueSlider / 100),
            height: height - 1,
            decoration: BoxDecoration(color: sliderColor, borderRadius: BorderRadius.circular(5.r)),
          ),
        ],
      ),
    );
  }
}
