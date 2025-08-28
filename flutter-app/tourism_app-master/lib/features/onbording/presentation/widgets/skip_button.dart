import 'package:flutter/material.dart';
import 'package:tourism_app/core/utils/navigate.dart';
import 'package:tourism_app/features/authentication/login/login_view.dart';

class SkipButton extends StatelessWidget {
  const SkipButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.navigateToPageWithReplacement(LoginView());
      },
      child: SizedBox(
        height: 30,
        child: Text(
          'Skip',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Colors.white,
              ),
        ),
      ),
    );
  }
}
