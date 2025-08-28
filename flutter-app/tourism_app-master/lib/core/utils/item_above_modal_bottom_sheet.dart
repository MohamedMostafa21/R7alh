import 'package:flutter/material.dart';

class ItemAboveModalBottomSheet extends StatelessWidget {
  const ItemAboveModalBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 42,
          height: 5,
          decoration: ShapeDecoration(
            color: const Color(0xFF858585),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
        ),
      ],
    );
  }
}
