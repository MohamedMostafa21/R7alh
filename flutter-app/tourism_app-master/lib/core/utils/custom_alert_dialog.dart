
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tourism_app/core/component/buttons/custom_text_button.dart';
import 'package:tourism_app/core/themes/colors.dart';
import 'package:tourism_app/core/themes/styles.dart';
import 'package:tourism_app/core/utils/extensions.dart';

Future<void> customAlertDialog(
  BuildContext context, {
  required String name,
  String? subTitle,
  String? nameOnPress,
  String? nameOnPress2,
  required Function onPress,
  Function? onPress2,
  bool trueMark = true,
}) async {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      title: Stack(
        clipBehavior: Clip.none,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (trueMark)
                  SvgPicture.asset('assets/images/svg/tick_circle.svg'),
                Text(
                  name.tr(),
                  textAlign: TextAlign.center,
                  style: Styles.style15500,
                ),
                if (subTitle != null)
                  Text(
                    subTitle.tr(),
                    textAlign: TextAlign.center,
                    style: Styles.style12300,
                  ),
              ].paddingDirectional(bottom: 24),
            ),
          ),
          Positioned(
            top: -35,
            right: -5,
            child: Container(
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    width: 1,
                    color: Colors.white,
                  )),
              child: Center(
                  child: Icon(
                Icons.close,
                color: Colors.white,
                size: 15.sp,
              )),
            ),
          ),
        ],
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 50,
                child: CustomTextButton(
                  height: .06,
                  child: Text(
                    (nameOnPress ?? 'Good').tr(),
                    textAlign: TextAlign.center,
                    style: Styles.style16400.copyWith(
                        fontWeight: FontWeight.w500, color: AppColors.white),
                  ),
                  onPress: () {
                    Navigator.pop(context);
                    onPress();
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 12,
        ),
        // if (onPress2 != null)
        //   Row(
        //     children: [
        //       Expanded(
        //         child: CustomTextButton(
        //           backgroundColor: AppColors.white,
        //           borderColor: AppColors.primaryColor,
        //           height: .06,
        //           child: Text(
        //             (nameOnPress2 ?? 'Good').tr(),
        //             textAlign: TextAlign.center,
        //             style: Styles.style16400.copyWith(fontWeight: FontWeight.w500, color: AppColors.primaryColor),
        //           ),
        //           onPress: () {
        //             Navigator.pop(context);
        //             onPress2();
        //           },
        //         ),
        //       ),
        //     ],
        //   ),
      ],
    ),
  );
}

void showFancyCustomDialog(BuildContext context) {
  final Dialog fancyDialog = Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
      ),
      width: 300.0,
      child: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          Container(
            width: double.infinity,
            height: 50,
            alignment: Alignment.bottomCenter,
            decoration: const BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: const Align(
              child: Column(
                children: [
                  Text(
                    'Dialog Title!',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blue[300],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: const Align(
                  child: Text(
                    "Okay let's go!",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ),
          Align(
            // These values are based on trial & error method
            alignment: const Alignment(1.05, -1.05),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
  showDialog(context: context, builder: (BuildContext context) => fancyDialog);
}
