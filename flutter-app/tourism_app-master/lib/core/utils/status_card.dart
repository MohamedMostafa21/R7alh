import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tourism_app/core/themes/colors.dart';
import 'package:tourism_app/core/themes/styles.dart';


class StatusCard extends StatelessWidget {
  final bool booking;
  final bool rental;

  const StatusCard({
    super.key,
    required this.booking,
    this.rental = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: ShapeDecoration(
        color: booking ? AppColors.cBookedColor : AppColors.greenWarm,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        booking ? 'Booked'.tr() : (rental ? 'Available for rent'.tr() : 'Available for sale'.tr()),
        textAlign: TextAlign.right,
        style: Styles.style12300.copyWith(color: booking ? AppColors.black : AppColors.white),
      ),
    );
  }
}
