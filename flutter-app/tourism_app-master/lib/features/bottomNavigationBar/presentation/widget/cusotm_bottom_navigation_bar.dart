import 'package:flutter/material.dart';
import 'package:tourism_app/core/themes/colors.dart';
import 'package:tourism_app/features/bottomNavigationBar/presentation/widget/navigation_bar_icon.dart';

class CustomNavigationBarWidget extends StatefulWidget {
  const CustomNavigationBarWidget({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onItemSelected; 

  @override
  State<CustomNavigationBarWidget> createState() => _CustomNavigationBarWidgetState();
}

class _CustomNavigationBarWidgetState extends State<CustomNavigationBarWidget> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(60),
        border: Border.all(
          width: 0.5,
          color: const Color(0xffF0F0F3),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          5,
          (index) {
            return NavBarItem(
              index: index,
              currentIndex: widget.selectedIndex,
              onTap: () {
                widget.onItemSelected(index);
              },
            );
          },
        ),
      ),
    );
  }
}