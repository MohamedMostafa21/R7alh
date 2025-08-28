import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ArrowBackButton extends StatelessWidget {
  const ArrowBackButton({
    super.key,
    this.borderColor,
    this.backgroundColor,
    this.iconColor,
  });
  final Color? borderColor;
  final Color? backgroundColor;
  final Color? iconColor;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        margin: EdgeInsets.only(
            right: context.locale.languageCode == 'ar' ? 16 : 0,
            left: context.locale.languageCode == 'ar' ? 0 : 16),
        padding: EdgeInsets.only(
          left: context.locale.languageCode == 'ar' ? 9.5 : 8,
          right: context.locale.languageCode == 'ar' ? 8 : 9.5,
          top: 8,
          bottom: 8,
        ),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
              width: 1.3, color: borderColor ?? const Color(0xFF000000)),
        ),
        // child: context.locale.languageCode == 'ar'
        //     ? SvgPicture.asset(
        //         colorFilter: ColorFilter.mode(iconColor ?? Colors.black, BlendMode.srcIn),
        //         AppIcons.arrowBack,
        //         height: 13,
        //         width: 13,
        //       )
        //     : Transform.rotate(
        //         angle: pi,
        //         child: SvgPicture.asset(
        //           colorFilter: ColorFilter.mode(iconColor ?? Colors.black, BlendMode.srcIn),
        //           AppIcons.arrowBack,
        //           height: 13,
        //           width: 13,
        //         ),
        //       ),
      ),
    );
  }
}
