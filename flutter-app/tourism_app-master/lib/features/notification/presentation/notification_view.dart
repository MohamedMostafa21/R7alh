import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tourism_app/features/notification/presentation/widgets/notification_item.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  NotificationViewState createState() => NotificationViewState();
}

class NotificationViewState extends State<NotificationView> {
  List<int> notifications = [1, 2, 3];
  void _onDismissNotification(int index) {
    setState(() {
      notifications.removeAt(index);
    });
    // if (notifications.isEmpty) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('No notifications available')),
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Notifications'.tr()),
      //   leading: const FittedBox(
      //     fit: BoxFit.scaleDown,
      //     child: ArrowBackButton(),
      //   ),
      // ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          if (notifications.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Text(
                  'No notifications available'.tr(),
                ),
              ),
            ),
          if (notifications.isNotEmpty)
            ...notifications.map((notification) {
              final int index = notifications.indexOf(notification);
              return Dismissible(
                key: Key(notification.toString()),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  _onDismissNotification(index);
                },
                child: NotificationItem(
                  onDismiss: () => _onDismissNotification(index),
                ),
              );
            }),
        ],
      ),
    );
  }
}
