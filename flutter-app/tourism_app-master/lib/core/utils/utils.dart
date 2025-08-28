import 'dart:developer';
import 'package:tourism_app/core/component/buttons/custom_text_button.dart';
import 'package:tourism_app/core/component/sharred_divider.dart';
import 'package:tourism_app/core/themes/colors.dart';
import 'package:tourism_app/core/themes/styles.dart';
import 'package:tourism_app/core/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum UtilState {
  success,
  warning,
  error,
  none,
}

class Utils {
  static const boxShadow = BoxShadow(
    blurRadius: 35,
    offset: Offset(0, 9),
    spreadRadius: -4,
  );

  static const customBoxShadow = BoxShadow(
    color: Color(0x0A000000),
    blurRadius: 35,
    offset: Offset(0, 9),
    spreadRadius: -4,
  );

  static TextSpan highlightText(
      {required String text, bool isExpanded = false}) {
    final List<TextSpan> spans = [];
    final List<String> words = text.split(' ');
    final int sizeWords = words.length <= 25 ? words.length : 25;

    if (!isExpanded) {
      for (int i = 0; i <= sizeWords - 1; i++) {
        if (words[i].startsWith('#')) {
          spans.add(
            TextSpan(
              text: '${words[i]} ',
              style: TextStyle(
                  color: AppColors.secondPrimaryColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: Constants.fontFamily),
            ),
          );
        } else {
          spans.add(TextSpan(
              text: '${words[i]} ',
              style: Styles.style12400.copyWith(color: AppColors.black)));
        }
      }
    } else {
      for (final String word in words) {
        if (word.startsWith('#')) {
          spans.add(
            TextSpan(
              text: '$word ',
              style: const TextStyle(
                color: AppColors.secondPrimaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        } else {
          spans.add(TextSpan(
              text: '$word ',
              style: Styles.style12400.copyWith(color: AppColors.black)));
        }
      }
    }

    return TextSpan(children: spans);
  }

  static void setStatusAndNavigationBarMethod(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: AppColors.scaffoldBackGround,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: AppColors.scaffoldBackGround,
      ),
    );
  }

  // launch url =======>>>>
  static Future<void> launchURLFunction(
    String url, {
    LaunchMode mode = LaunchMode.externalApplication,
  }) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      Utils.showToast(
          title: 'Sorry, Cannot launch url'.tr(), state: UtilState.error);
    }
    // await launchUrl(Uri.parse(url), mode: mode);
  }

  /// ------------------------------ toast --------------------------------------
  static void showToast({
    required String title,
    Color textColor = Colors.white,
    ToastGravity gravity = ToastGravity.BOTTOM,
    required UtilState state,
  }) {
    Fluttertoast.showToast(
      msg: title,
      toastLength: Toast.LENGTH_LONG,
      gravity: gravity,
      timeInSecForIosWeb: 5,
      backgroundColor: _toastColor(state),
      textColor: textColor,
      fontSize: 16.0,
    );
  }

  static Color _toastColor(UtilState utilState) {
    Color? color;
    switch (utilState) {
      case UtilState.success:
        color = AppColors.green;
        break;
      case UtilState.warning:
        color = AppColors.amber;
        break;
      case UtilState.error:
        color = AppColors.red;
        break;
      case UtilState.none:
        color = AppColors.black;
        break;
    }
    return color;
  }

  static BoxDecoration containerBoxDecoration = BoxDecoration(
    color: AppColors.white,
    borderRadius: BorderRadius.circular(15.r),
  );

  static bool selectImageExtension({required String originalString}) {
    final String fileExtension;
    final List<String> imageExtensions = ['jpg', 'png'];
    fileExtension = originalString.split('.').last.split('?').first;
    for (final value in imageExtensions) {
      if (fileExtension == value) {
        return true;
      }
    }
    return false;
  }

  static String addTimeNow({required DateTime dateTime}) {
    final bool am = dateTime.hour < 12;
    final int hour = am ? dateTime.hour : dateTime.hour - 12;
    final int minute = dateTime.minute;
    return '$hour:$minute ${am ? 'am '.tr()[0] : 'pm '.tr()[0]}';
  }
}

void printDM(String title, {bool stop = false}) {
  if (kDebugMode) {
    log(title);
  }
}

Future<void> customModalBottomSheet({
  required BuildContext context,
  required String title,
  required Map<String, bool> subTitle,
  required String nameConfirmButton,
  required String nameCancelButton,
  required Function onPressConfirmButton,
  required Function onPressCancelButton,
  Widget? specialWidget,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10.r),
                topLeft: Radius.circular(10.r)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 42,
                    height: 5,
                    decoration: ShapeDecoration(
                      color: const Color(0xFF858585),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              Text(
                title,
                style: Styles.style18300.copyWith(
                    fontWeight: FontWeight.w400, color: AppColors.textColor),
              ),
              ...List.generate(
                subTitle.length,
                (index) => Column(
                  children: [
                    CheckboxListTile(
                      value: subTitle[subTitle.keys.toList()[index]],
                      onChanged: (bool? value) {
                        subTitle[subTitle.keys.toList()[index]] = value!;
                        setState(() {});
                      },
                      title: Text(
                        subTitle.keys.toList()[index],
                        style: Styles.style14300
                            .copyWith(color: AppColors.textColor),
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                      checkboxShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      activeColor: AppColors.textColor,
                      contentPadding: EdgeInsets.zero,
                    ),
                    const SharredDivider(
                      height: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomTextButton(
                      backgroundColor: AppColors.white,
                      borderColor: AppColors.textColor,
                      child: Text(
                        nameConfirmButton,
                        style: Styles.style16400.copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColors.textColor),
                      ),
                      onPress: () {
                        subTitle.forEach((key, value) {
                          subTitle[key] = false;
                        });
                        setState(() {});
                        onPressConfirmButton();
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 11,
                  ),
                  Expanded(
                    flex: 2,
                    child: CustomTextButton(
                      borderColor: AppColors.transparent,
                      backgroundColor: AppColors.black,
                      child: Text(
                        nameCancelButton,
                        style: Styles.style16400.copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColors.white),
                      ),
                      onPress: () {
                        Navigator.pop(context);
                        onPressCancelButton();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        );
      },
    ),
  );
}

Future<void> languagesModalBottomSheet({
  required BuildContext context,
}) {
  Locale convertLocal = context.locale;
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10.r),
                topLeft: Radius.circular(10.r)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 42,
                    height: 5,
                    decoration: ShapeDecoration(
                      color: const Color(0xFF858585),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              Text(
                'languages'.tr(),
                style: Styles.style18300.copyWith(
                    fontWeight: FontWeight.w400, color: AppColors.textColor),
              ),
              const SizedBox(
                height: 24,
              ),
              Container(
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: convertLocal.languageCode == 'ar'
                            ? AppColors.textColor
                            : AppColors.cBorderTextFormField),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: RadioListTile(
                  value:
                      convertLocal.languageCode == 'ar' ? 'العربية' : 'English',
                  groupValue: 'العربية',
                  //  fillColor: MaterialStatePropertyAll(AppColors.green),
                  title: Text(
                    'العربية',
                    style: Styles.style14300,
                  ),
                  onChanged: (value) {
                    convertLocal = const Locale('ar', 'SA');
                    setState(() {});
                  },
                  activeColor: AppColors.primaryColor,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Container(
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: convertLocal.languageCode == 'en'
                            ? AppColors.textColor
                            : AppColors.cBorderTextFormField),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: RadioListTile(
                  value:
                      convertLocal.languageCode == 'ar' ? 'العربية' : 'English',
                  groupValue: 'English',
                  title: Text(
                    'English',
                    style: Styles.style14300,
                  ),
                  onChanged: (value) {
                    convertLocal = const Locale('en', 'US');

                    setState(() {});
                  },
                  activeColor: AppColors.primaryColor,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              SizedBox(
                height: 50,
                child: CustomTextButton(
                  backgroundColor: AppColors.white,
                  borderColor: AppColors.textColor,
                  child: Text(
                    'Save'.tr(),
                    style: Styles.style16400.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.textColor),
                  ),
                  onPress: () {
                    context.setLocale(convertLocal);
                    setState(() {});
                    //todo
                    //context.navigateToPage(Constants.user ? const BottomNavBarScreen() : const NavBArScreens());
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        );
      },
    ),
  );
}

Future<DateTime> customShowDatePicker({
  required BuildContext context,
}) {
  return showDatePicker(
    builder: (context, child) => Theme(
      data: Theme.of(context).copyWith(
        colorScheme: const ColorScheme.light(
          primary: AppColors.primaryColor,
          onSurface: AppColors.white,
        ),
      ),
      child: child!,
    ),
    context: context,
    firstDate: DateTime(
      2022,
    ),
    lastDate: DateTime(
      2040,
    ),
    initialDate: DateTime.now(),
  ).then((value) {
    return value ?? DateTime.now();
  });
}
