import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tourism_app/core/themes/colors.dart';
import 'package:tourism_app/core/utils/extensions.dart';

class CustomTextButton extends StatefulWidget {
  final Widget child;
  final Color? backgroundColor; // Background color
  final List<Color>? gradientColors; // Gradient colors
  final List<double>? stops; // Gradient stops
  final Color? borderColor;
  final Function? onPress;
  final double? width;
  final double? height;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  const CustomTextButton({
    super.key,
    required this.child,
    this.backgroundColor,
    this.gradientColors,
    this.stops, // New property for stops
    this.borderColor,
    required this.onPress,
    this.width,
    this.height,
    this.borderRadius,
    this.padding, this.margin,
  });

  @override
  State<CustomTextButton> createState() => _CustomTextButtonState();
}

class _CustomTextButtonState extends State<CustomTextButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      width: context.screenWidth * (widget.width ?? .9),
      height: widget.height ?? 50.h,
      decoration: BoxDecoration(
        color:
            widget.gradientColors == null ? widget.backgroundColor ?? AppColors.primaryColor : null, // Use backgroundColor if gradientColors is null
        gradient: widget.gradientColors != null
            ? LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: widget.gradientColors!,
                stops: widget.stops, // Apply stops if provided
              )
            : null,
        borderRadius: BorderRadius.circular((widget.borderRadius ?? 30).r),
        border: Border.all(
          color: widget.borderColor ?? AppColors.transparent,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular((widget.borderRadius ?? 30).r),
          onTap: () {
            if (widget.onPress != null) {
              widget.onPress!();
            }
          },
          child: Padding(
            padding: widget.padding ?? EdgeInsets.zero,
            child: Center(child: widget.child),
          ),
        ),
      ),
    );
  }
}


/*
 ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(widget.backgroundColor ?? AppColors.white),
            shape: MaterialStatePropertyAll(
              ContinuousRectangleBorder(
                side: BorderSide(color: widget.borderColor ?? AppColors.primaryColor),
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 10.r),
              ),
            ),
          )
 */
