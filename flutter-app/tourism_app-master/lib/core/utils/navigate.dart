import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

extension NavigationExtension on BuildContext {
  void navigateToPage(
      Widget widget, {
        PageTransitionType? pageTransitionType,
      }) {
    Navigator.of(this).push(
      PageTransition(
        child: widget,
        type: pageTransitionType ?? PageTransitionType.fade,
        duration: const Duration(milliseconds: 500),
      ),
    );
  }

  void navigateToPageWithReplacement(Widget page) {
    Navigator.of(this).pushReplacement(
      PageTransition(
        child: page,
        type: PageTransitionType.fade,
        duration: const Duration(milliseconds: 500),
      ),
    );
  }

  void navigateToPageWithClearStack(Widget page) {
    Navigator.of(this).pushAndRemoveUntil(
      PageTransition(
        child: page,
        type: PageTransitionType.fade,
        duration: const Duration(milliseconds: 500),
      ),
          (route) => false,
    );
  }
}
