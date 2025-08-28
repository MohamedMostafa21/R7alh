/*
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logo/core/themes/colors.dart';
import 'package:logo/core/themes/styles.dart';
import 'package:logo/core/utils/screen_spaces_extension.dart';

class CustomTextPhoneNumber extends StatelessWidget {
  final TextEditingController phoneNumberController;
  final String? nameField;

  const CustomTextPhoneNumber({super.key, required this.phoneNumberController, this.nameField});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(useMaterial3: false),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (nameField != null)
            Text(
              nameField!,
              style: Styles.style12700,
            ),
          if (nameField != null) 10.ESH(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10).w,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r), color: AppColors.white),
            child: IntlPhoneField(
              showCountryFlag: false,
              initialCountryCode: '+20',
              controller: phoneNumberController,
              decoration: InputDecoration(
                counter: Container(),
                //fillColor: AppColors.white,
                border: InputBorder.none,
                focusedBorder: const OutlineInputBorder(),
                //filled: true,
                disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30.r)),
              ),
              dropdownIcon: const Icon(
                Icons.keyboard_arrow_down_sharp,
                color: Colors.black,
              ),
              dropdownIconPosition: IconPosition.trailing,
            ),
          ),
        ],
      ),
    );
  }
}
*/
