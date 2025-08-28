import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class CustomPopUpButton extends StatelessWidget {
  final void Function()? onOpened;
  final void Function()? onCanceled;
  final void Function(int)? onSelected;
  final List<PopupMenuEntry<int>> Function(BuildContext) itemBuilder;
  const CustomPopUpButton({super.key,  this.onOpened, this.onCanceled, this.onSelected, required this.itemBuilder, this.child});
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      splashRadius: BorderSide.strokeAlignCenter,
      surfaceTintColor: Colors.white,
      color: Colors.white,
      offset: Offset(45.w, 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      onOpened: onOpened,
      onCanceled: onCanceled,
      itemBuilder: itemBuilder,
      onSelected: onSelected,
      child: child,
    );
  }
}
