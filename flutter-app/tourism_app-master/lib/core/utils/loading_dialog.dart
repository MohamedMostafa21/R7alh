import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tourism_app/core/themes/colors.dart';

void animationDialogLoading(BuildContext context) {
  showDialog(
    context: context,
    barrierColor: Colors.black26,
    barrierDismissible: false,
    builder: (context) => const Dialog(
      backgroundColor: Colors.transparent,
      child: SizedBox(
        height: 500,
        width: 500,
        child: SpinKitRipple(
          color: AppColors.primaryColor,
          size: 200,
        ),
      ),
    ),
  );
}

void closeDialog(BuildContext context) {
  Navigator.pop(context);
}
