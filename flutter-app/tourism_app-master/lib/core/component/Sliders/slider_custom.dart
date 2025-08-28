import 'package:flutter/material.dart';
import 'package:tourism_app/core/component/Sliders/sharred.dart';
import 'package:tourism_app/core/themes/colors.dart';


class SliderCustom extends StatefulWidget {
  final double valueSlider;
  final Color? activeTrackColor;
  final Color? inactiveTrackColor;

  const SliderCustom({super.key, required this.valueSlider, this.activeTrackColor, this.inactiveTrackColor});

  @override
  State<SliderCustom> createState() => _SliderCustomState();
}

class _SliderCustomState extends State<SliderCustom> {
  @override
  Widget build(BuildContext context) {
    double valueSlider = widget.valueSlider;

    return SliderTheme(
      data: SliderThemeData(
        thumbShape: const RoundSliderOverlayShape(overlayRadius: 1),
        activeTrackColor: widget.activeTrackColor ?? AppColors.secondPrimaryColor,
        inactiveTrackColor: widget.inactiveTrackColor ?? AppColors.cBackGroundColorSlider,
        trackShape: CustomTrackShape(),
      ),
      child: Slider(
        max: 100,
        value: valueSlider,
        thumbColor: AppColors.transparent,
        onChanged: (value) {
          valueSlider = value;
        },
      ),
    );
  }
}

/*
 Expanded(
          child: SliderTheme(
            data: SliderThemeData(
              thumbShape: const RoundSliderOverlayShape(overlayRadius: 1),
              activeTrackColor: AppColors.selectedCharData,
              inactiveTrackColor: AppColors.cLightPlusNumber,
              // trackHeight: context.screenHeight * .017,

              trackShape: CustomTrackShape(),
            ),
            child: Slider(
              max: 100,
              value: valueSlider,
              thumbColor: CAppColors.transparent,
              onChanged: (value) {
                valueSlider = value;
              },
            ),
          ),
        ),
        Text(
          '$valueSlider %',
          style: Styles.style14400.copyWith(color: AppColors.textColorTextFormField),
        ),
*/
