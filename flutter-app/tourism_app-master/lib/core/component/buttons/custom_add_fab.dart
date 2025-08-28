
import 'package:flutter/material.dart';

class CustomAddFAB extends StatelessWidget {
  const CustomAddFAB({
    super.key, this.onTap,
  });
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              color: Colors.black.withOpacity(0.5),
            ),
          ],
          shape: BoxShape.circle,
          color: Colors.black,
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}
