
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tourism_app/core/themes/colors.dart';

void loginDialog(BuildContext context) {
  showDialog(
    //barrierDismissible: false,
    barrierColor: AppColors.black.withOpacity(.3),
    context: context,
    builder: (BuildContext context) {
      return const LoginRequiredDialog();
    },
  );
}

class LoginRequiredDialog extends StatelessWidget {
  const LoginRequiredDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // todo:add login screen
    return PopScope(
      canPop: false,
      child: AlertDialog(
        backgroundColor: Colors.white,
        title: Text('Login Required'.tr()),
        content: Text('You need to log in to access this feature.'.tr()),
        actions: [
          TextButton(
            onPressed: () {
            //  context.navigateToPage(const LoginScreen());
            },
            child: Text('Login'.tr()),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            //  MainBlocHomeCubit.of(context).changeIndex(index: 0);
            },
            child: Text('cancel'.tr()),
          ),
        ],
      ),
    );
  }
}
