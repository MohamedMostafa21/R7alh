import 'package:flutter/material.dart';

class CustomFAB extends StatelessWidget {
  const CustomFAB({
    super.key,
    required this.onPressed,
    this.showOptions,
    this.enableSwitchingColor = false,
  });

  final VoidCallback onPressed;
  final bool? showOptions;
  final bool enableSwitchingColor;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      tooltip: '',
      backgroundColor: enableSwitchingColor
          ? showOptions ?? false
              ? Colors.white
              : Colors.black
          : Colors.black,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400), // Adjust animation duration
        switchInCurve: Curves.easeInOutBack, // Smooth curved effect on transition
        switchOutCurve: Curves.easeInOut, // Smooth exit transition
        transitionBuilder: (Widget child, Animation<double> animation) {
          return RotationTransition(
            turns: animation, // Rotate during transition
            child: child,
          );
        },
        child: enableSwitchingColor
            ? showOptions ?? false
                ? const Icon(
                    Icons.close,
                    color: Colors.black,
                    key: ValueKey('close'), 
                  )
                : const Icon(
                    Icons.add,
                    color: Colors.white,
                    key: ValueKey('add'),
                  )
            : const Icon(
                Icons.add,
                color: Colors.white,
                key: ValueKey('add'),
              ),
      ),
    );
  }
}
