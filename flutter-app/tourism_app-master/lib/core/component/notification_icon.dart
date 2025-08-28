import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tourism_app/core/themes/colors.dart';
import 'package:tourism_app/core/utils/app_icons.dart';
import 'package:tourism_app/core/utils/navigate.dart';
import 'package:tourism_app/features/notification/presentation/notification_view.dart';

class NotificationIcon extends StatelessWidget {
  const NotificationIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.navigateToPage(const NotificationView());
      },
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: AppColors.white,
                border: Border.all(
                  width: 0.1,
                  color: Colors.grey.withOpacity(0.6),
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 1.5,
                    spreadRadius: 1.5,
                    color: const Color(0xffF0F0F3).withOpacity(0.4),
                  ),
                ]),
            child: SvgPicture.asset(AppIcons.notification),
          ),
          Positioned(
            top: 7,
            right: 7,
            child: Container(
              height: 12,
              width: 12,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(255, 232, 95, 95),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
