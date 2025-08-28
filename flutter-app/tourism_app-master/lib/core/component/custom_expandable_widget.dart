import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class CustomExpandableWidget extends StatelessWidget {
  const CustomExpandableWidget({
    super.key,
    required this.controller,
    this.child,
    required this.title,
  });

  final ExpandableController? controller;
  final Widget? child;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xffF6F6F6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(width: 0.1),
      ),
      child: ExpandablePanel(
        controller: controller,
        theme: const ExpandableThemeData(
          hasIcon: false, // To hide the default arrow icon
          tapBodyToExpand: true,
          tapBodyToCollapse: true,
        ),
        header: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
              Icon(controller!.expanded ? Icons.remove : Icons.add), // You can change this icon dynamically based on expanded state
            ],
          ),
        ),
        collapsed: Container(), // Empty or minimal content when collapsed
        expanded: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: child,
        ),
      ),
    );
  }
}
