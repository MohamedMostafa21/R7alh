import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tourism_app/core/component/buttons/arrow_back_button.dart';
import 'package:tourism_app/core/themes/colors.dart';


class CustomSliverAppBar extends StatelessWidget {
  const CustomSliverAppBar({
    super.key,
    required this.forceElevated,
  });
  final bool forceElevated;
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 75,
      forceMaterialTransparency: true,
      pinned: true,
      floating: true,
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.transparent,
      forceElevated: forceElevated,
      flexibleSpace: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
        child: Container(
          color: AppColors.primaryColor,
          child: Row(
            children: [
              const ArrowBackButton(
                borderColor: Colors.white,
                iconColor: Colors.white,
                backgroundColor: Colors.transparent,
              ),
              const SizedBox(width: 10),
              Center(
                child: Text(
                  'Orders'.tr(),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
