import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tourism_app/core/themes/colors.dart';
import 'package:tourism_app/core/themes/styles.dart';

AppBar shareAppBar(BuildContext context,
    {required String nameAppBar, bool notificationIcon = true, bool hideBack = false, void Function()? onPressed}) {
  return AppBar(
    forceMaterialTransparency: true,
    leading: !hideBack
        ? GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(width: 15),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                      //  border: Border.all(color: const Color(0xff202020), width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withOpacity(0.15),
                          spreadRadius: -4.5,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
            ),
          )
        : const SizedBox(),
    title: Text(
      nameAppBar.tr(),
      textAlign: TextAlign.center,
      style: Styles.styleHeader,
    ),
  );
}
