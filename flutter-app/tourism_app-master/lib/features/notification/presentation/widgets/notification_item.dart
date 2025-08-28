import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tourism_app/core/themes/colors.dart';
import 'package:tourism_app/core/utils/app_icons.dart';

class NotificationItem extends StatelessWidget {
  final Function onDismiss; // Callback to notify parent when dismissed

  const NotificationItem({
    super.key,
    required this.onDismiss, // Passing the callback
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: const Key('notification-item'),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        onDismiss();
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(content: Text('Notification dismissed')),
        // );
      },
      background: Container(
        margin: const EdgeInsets.symmetric(horizontal: 13),
        decoration: const BoxDecoration(
          color: Colors.red,
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           SvgPicture.asset(AppIcons.verifyIcon),
            const SizedBox(width: 10),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          'The maintenance request has been confirmed.',
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 14.sp),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Since 2 days',
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w300),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Your request has been successfully confirmed! You will be contacted soon to schedule the maintenance appointment.',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 14.sp, color: AppColors.textColor, fontWeight: FontWeight.w300),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
