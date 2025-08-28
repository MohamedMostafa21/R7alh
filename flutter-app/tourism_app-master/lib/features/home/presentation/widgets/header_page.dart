import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tourism_app/core/component/cache_image.dart';
import 'package:tourism_app/core/component/notification_icon.dart';
import 'package:tourism_app/core/network/local/cache.dart';
import 'package:tourism_app/core/themes/colors.dart';
import 'package:tourism_app/core/utils/constants.dart';

class HeaderHomePage extends StatelessWidget {
  const HeaderHomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          CacheImage(
            imageUrl: userCacheValue?.user?.profilePictureUrl ?? '',
            circle: true,
            width: 40,
            height: 40,
            errorColor: Colors.grey,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hi,'.tr(), style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: AppColors.textColor)),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(userCacheValue?.user?.firstName ?? Constants.unKnown,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(color: AppColors.black)),
                ),
              ],
            ),
          ),
          const Spacer(),
          const NotificationIcon(),
        ],
      ),
    );
  }
}
