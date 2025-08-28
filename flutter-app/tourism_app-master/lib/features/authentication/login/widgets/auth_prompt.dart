import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tourism_app/core/themes/colors.dart';

class AuthPrompt extends StatelessWidget {
  const AuthPrompt({
    super.key,
    required this.text,
    required this.actionText,
    this.onTap,
  });
  final String text;
  final String actionText;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: text, style: Theme.of(context).textTheme.bodyMedium),
          TextSpan(
            text: actionText,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.primaryColor),
            recognizer: TapGestureRecognizer()..onTap = onTap,
          ),
        ],
      ),
    );
  }
}
