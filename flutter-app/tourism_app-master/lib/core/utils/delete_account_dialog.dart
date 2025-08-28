
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tourism_app/core/component/buttons/custom_text_button.dart';
import 'package:tourism_app/core/network/local/cache.dart';
import 'package:tourism_app/core/themes/colors.dart';
import 'package:tourism_app/core/themes/styles.dart';
import 'package:tourism_app/core/utils/constants.dart';

import 'custom_show_toast.dart';

Future<void> deleteAccountDialog(
  BuildContext context,
) async {
  showDialog(
    context: context,
    builder: (context) => Stack(
      alignment: AlignmentDirectional.center,
      children: [
        AlertDialog(
          backgroundColor: AppColors.white,
          titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
          title: Text(
            'Are you sure to delete your account with us?'.tr(),
            textAlign: TextAlign.center,
            style: Styles.style16400,
          ),
          actions: [
            CustomTextButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'I want to follow the account'.tr(),
                    textAlign: TextAlign.center,
                    style: Styles.style16400.copyWith(fontWeight: FontWeight.w500, color: AppColors.white),
                  ),
                ],
              ),
              onPress: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(
              height: 12,
            ),
            CustomTextButton(
              backgroundColor: AppColors.transparent,
              borderColor: AppColors.cLogOutColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'I want to delete the account'.tr(),
                    textAlign: TextAlign.center,
                    style: Styles.style16400.copyWith(fontWeight: FontWeight.w500, color: AppColors.cLogOutColor),
                  ),
                ],
              ),
              onPress: () {
                userCache?.clear();
                //userCacheValue = null;
                Constants.user = true;
                Navigator.pop(context);
                //todo:
               // context.navigateToPageWithReplacement(const BottomNavBarScreen());
             //   MainBlocHomeCubit.of(context).changeIndex(index: 0);
                customShowToast(
                  context,
                  'we will delete your account after 30 days if you do not log in while that the duration'.tr(),
                  AppColors.cLogOutColor,
                );
              },
            ),
          ],
        ),
        /*Positioned(
          top: 187.h,
          right: 50.w,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.white, width: 2),
            ),
            child: const Icon(
              Icons.close,
              color: AppColors.white,
            ),
          ),
        ),*/
      ],
    ),
  );
}
