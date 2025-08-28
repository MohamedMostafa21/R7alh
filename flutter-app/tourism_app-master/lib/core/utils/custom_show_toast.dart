
import 'package:flutter/material.dart';
import 'package:tourism_app/core/themes/colors.dart';
import 'package:tourism_app/core/themes/styles.dart';

void customShowToast(
  BuildContext context,
  String message,
  Color? backgroundColor,
) async {
  final OverlayState overlayState = Overlay.of(context);
  final OverlayEntry entry = OverlayEntry(
    builder: (context) => BottomToastOverlayContainer(message: message, backgroundColor: backgroundColor ?? Colors.white),
  );

  overlayState.insert(entry);
  await Future.delayed(const Duration(seconds: 5));
  entry.remove();
}

class BottomToastOverlayContainer extends StatefulWidget {
  final String message;
  final Color backgroundColor;

  const BottomToastOverlayContainer({
    super.key,
    required this.message,
    required this.backgroundColor,
  });

  @override
  State<BottomToastOverlayContainer> createState() => _BottomToastOverlayContainerState();
}

class _BottomToastOverlayContainerState extends State<BottomToastOverlayContainer> with SingleTickerProviderStateMixin {
  late AnimationController animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500))..forward();

  late Animation<double> slideAnimation = Tween<double>(begin: -0.5, end: 1.0).animate(
    CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOutCirc,
    ),
  );

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      animationController.reverse();
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: slideAnimation,
      builder: (context, child) {
        return PositionedDirectional(
          start: MediaQuery.of(context).size.width * (0.1),
          bottom: (MediaQuery.of(context).size.height * (0.075) * (slideAnimation.value)) + MediaQuery.viewInsetsOf(context).bottom,
          child: Opacity(
            opacity: slideAnimation.value < 0.0 ? 0.0 : slideAnimation.value,
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                width: MediaQuery.of(context).size.width * (0.8),
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Text(
                  widget.message,
                  style: Styles.style14500.copyWith(color: AppColors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
