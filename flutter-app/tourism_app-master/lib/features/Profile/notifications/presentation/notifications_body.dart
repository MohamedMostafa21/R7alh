import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tourism_app/core/component/custom_card_notification.dart';
import 'package:tourism_app/core/themes/colors.dart';
import 'package:tourism_app/core/utils/app_images.dart';

class NotificationsBody extends StatelessWidget {
  const NotificationsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: TextStyle(fontSize: 25.sp),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            CustomCardNotification(
              image: AppImages.notification,
              title: 'You Have 15% Discount On Your First Ticket',
              description:
                  'Congratulations! Enjoy A Special 15% Discount On Your First Booking With Guide To Egypt',
              dateTime: DateTime(2024, 12, 16),
            ),
            CustomCardNotification(
              image: AppImages.notification,
              title: 'You Have 15% Discount On Your First Ticket',
              description:
                  'Congratulations! Enjoy A Special 15% Discount On Your First Booking With Guide To Egypt',
              dateTime: DateTime(2024, 12, 16),
            ),
            CustomCardNotification(
              image: AppImages.notification,
              title: 'You Have 15% Discount On Your First Ticket',
              description:
                  'Congratulations! Enjoy A Special 15% Discount On Your First Booking With Guide To Egypt',
              dateTime: DateTime(2024, 12, 16),
            ),
            SizedBox(
              height: 10,
            ),
            CustomCardNotification(
              image: AppImages.notification,
              title: 'You Have 15% Discount On Your First Ticket',
              description:
                  'Congratulations! Enjoy A Special 15% Discount On Your First Booking With Guide To Egypt',
              dateTime: DateTime(2024, 12, 16),
            ),
            CustomCardNotification(
              image: AppImages.notification,
              title: 'You Have 15% Discount On Your First Ticket',
              description:
                  'Congratulations! Enjoy A Special 15% Discount On Your First Booking With Guide To Egypt',
              dateTime: DateTime(2024, 12, 16),
            ),
            CustomCardNotification(
              image: AppImages.notification,
              title: 'You Have 15% Discount On Your First Ticket',
              description:
                  'Congratulations! Enjoy A Special 15% Discount On Your First Booking With Guide To Egypt',
              dateTime: DateTime(2024, 12, 16),
            ),
            CustomCardNotification(
              image: AppImages.notification,
              title: 'You Have 15% Discount On Your First Ticket',
              description:
                  'Congratulations! Enjoy A Special 15% Discount On Your First Booking With Guide To Egypt',
              dateTime: DateTime(2024, 12, 16),
            ),
            CustomCardNotification(
              image: AppImages.notification,
              title: 'You Have 15% Discount On Your First Ticket',
              description:
                  'Congratulations! Enjoy A Special 15% Discount On Your First Booking With Guide To Egypt',
              dateTime: DateTime(2024, 12, 16),
            ),
            CustomCardNotification(
              image: AppImages.notification,
              title: 'You Have 15% Discount On Your First Ticket',
              description:
                  'Congratulations! Enjoy A Special 15% Discount On Your First Booking With Guide To Egypt',
              dateTime: DateTime(2024, 12, 16),
            ),
          ],
        ),
      ),
    );
  }
}
