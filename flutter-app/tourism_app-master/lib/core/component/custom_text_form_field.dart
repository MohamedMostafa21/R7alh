import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tourism_app/core/themes/colors.dart';
import 'package:tourism_app/core/themes/styles.dart';
import 'package:tourism_app/core/utils/constants.dart';
import 'package:tourism_app/core/utils/screen_spaces_extension.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String? nameField;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Widget? labelText;
  final bool? password;
  final int? maxLines;
  final TextInputType? textInputType;
  final Color? fillColor;
  final Color? focusedBorderColor;
  final Color? enabledBorder;
  final double? fontSizeHintText;
  final double? height;
  final double? width;
  final EdgeInsets? contentPadding;
  final EdgeInsets? outPadding;
  final double? borderRadius;
  final bool? validationOnNumber;
  final bool? enable;
  final Key? validateKey;
  final TextStyle? hintStyle;
  final void Function(String value)? onChange;
  final Function()? onTap;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final String? labelStringText;
  final MainAxisSize? mainAxisSize;
  final Color? borderColor;
  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    this.suffixIcon,
    this.prefixIcon,
    this.password = false,
    this.maxLines,
    this.textInputType,
    this.fillColor,
    this.fontSizeHintText,
    this.focusedBorderColor,
    this.validationOnNumber,
    this.labelText,
    this.nameField,
    this.height,
    this.width,
    this.enable = true,
    this.enabledBorder,
    this.borderRadius,
    this.contentPadding,
    this.onChange,
    this.outPadding,
    this.validateKey,
    this.hintStyle,
    this.onTap,
    this.focusNode,
    this.inputFormatters,
    this.labelStringText,
    this.mainAxisSize,
    this.borderColor,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _obscureText = false;

  @override
  void initState() {
    _obscureText = widget.password!;

    super.initState();
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  bool validateField(String value) {
    if (value.isEmpty) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    ///You must add [[width]] in SizeBox before use it
    return Column(
      mainAxisSize: widget.mainAxisSize ?? MainAxisSize.max,
      children: [
        Padding(
          padding:
              widget.outPadding ?? const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            // width: context.screenWidth * (widget.width ?? .9),
            // height: context.screenHeight * (widget.height ?? .13),
            decoration: const ShapeDecoration(
              shape: RoundedRectangleBorder(),
              shadows: [
                BoxShadow(
                  color: Color(0x0A000000),
                  blurRadius: 35,
                  offset: Offset(0, 9),
                  spreadRadius: -4,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.nameField != null)
                  Text(
                    widget.nameField!.tr(),
                    style: Styles.style14300
                        .copyWith(color: AppColors.cPaymentColor),
                  ),
                if (widget.nameField != null) 10.ESH(),
                TextFormField(
                  focusNode: widget.focusNode,
                  onTap: widget.onTap,
                  obscureText: _obscureText,
                  controller: widget.controller,
                  keyboardType:
                      widget.textInputType ?? TextInputType.visiblePassword,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textColor.withOpacity(0.6),
                      fontSize: 13.sp),
                  onChanged: (value) {
                    if (widget.onChange != null) {
                      widget.onChange!.call(value);
                    }
                  },
                  validator: (value) {
                    if (!validateField(value!)) {
                      return 'Empty Field'.tr();
                    }
                    return null;
                  },
                  inputFormatters: widget.inputFormatters ??
                      [
                        if (widget.validationOnNumber != null &&
                            widget.validationOnNumber!)
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d{0,2}$')),
                      ],
                  maxLines: widget.maxLines ?? 1,
                  cursorColor: AppColors.textColorTextFormField,
                  decoration: InputDecoration(
                    enabled: widget.enable!,
                    hintText: widget.hintText.tr(),
                    hintStyle: widget.hintStyle ??
                        TextStyle(
                          color: AppColors.textColor,
                          fontSize: Constants.tablet
                              ? (widget.fontSizeHintText ?? 14)
                              : (widget.fontSizeHintText ?? 14).sp,
                          fontWeight: FontWeight.w300,
                        ),
                    prefixIcon: widget.prefixIcon,
                    label: widget.labelText,
                    labelText: widget.labelStringText,
                    labelStyle: const TextStyle(color: Colors.black),
                    fillColor: AppColors.white,
                    filled: true,
                    contentPadding: (widget.contentPadding ??
                            const EdgeInsets.symmetric(horizontal: 8))
                        .w,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(widget.borderRadius ?? 15.r)),
                      borderSide: BorderSide(
                          color: widget.borderColor ??
                              AppColors.primaryColor.withOpacity(0.1)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(widget.borderRadius ?? 15.r)),
                      borderSide: BorderSide(
                          color: widget.borderColor ??
                              AppColors.primaryColor.withOpacity(0.1)),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(widget.borderRadius ?? 15.r)),
                      borderSide: BorderSide(
                          color: widget.borderColor ??
                              AppColors.primaryColor.withOpacity(0.1)),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(widget.borderRadius ?? 15.r)),
                      borderSide: BorderSide(color: AppColors.red),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(widget.borderRadius ?? 15.r)),
                      borderSide: BorderSide(
                          color: widget.borderColor ??
                              AppColors.primaryColor.withOpacity(0.1)),
                    ),
                    suffixIcon: widget.password != null && widget.password!
                        ? Padding(
                            padding: const EdgeInsets.all(10.0).w,
                            child: InkWell(
                              onTap: _toggle,
                              child: _obscureText
                                  ? Icon(Icons.visibility,
                                      color: AppColors.textColorTextFormField)
                                  : Icon(Icons.visibility_off,
                                      color: AppColors.textColorTextFormField),
                            ),
                          )
                        : widget.suffixIcon,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
