import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tourism_app/core/component/buttons/custom_text_button.dart';
import 'package:tourism_app/core/themes/colors.dart';
import 'package:tourism_app/core/themes/styles.dart';
import 'package:tourism_app/core/utils/item_above_modal_bottom_sheet.dart';


Future<void> failureModalBottomSheet(BuildContext context, {required Function onPress}) async {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: ItemAboveModalBottomSheet(),
                ),
              //  SvgPicture.asset(AppIcons.failure),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  'Unable to send the request!'.tr(),
                  textAlign: TextAlign.center,
                  style: Styles.style18300.copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  'Please, make sure you have an internet connection'.tr(),
                  textAlign: TextAlign.center,
                  style: Styles.style12300,
                ),
                const SizedBox(
                  height: 40,
                ),
                CustomTextButton(
                  backgroundColor: Colors.transparent,
                  borderColor: Colors.transparent,
                  child: Text(
                    'Try again, Later'.tr(),
                    textAlign: TextAlign.center,
                    style: Styles.style16400.copyWith(fontWeight: FontWeight.w500, decoration: TextDecoration.underline),
                  ),
                  onPress: () {
                    onPress();
                  },
                ),
                const SizedBox(
                  height: 80,
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
