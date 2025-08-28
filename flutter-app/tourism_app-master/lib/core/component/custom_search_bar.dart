import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tourism_app/core/component/custom_text.dart';
import 'package:tourism_app/core/themes/colors.dart';

class CustomSearchBar extends StatelessWidget {
  final String hintText;
  final Widget prefixIcon;
  final Widget suffixIcon;
  final VoidCallback? onBackPressed;

  const CustomSearchBar({
    this.onBackPressed,
    super.key,
    required this.hintText,
    required this.prefixIcon,
    required this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Background color
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.black),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 12.0),
          suffixIcon: IconButton(
            icon: suffixIcon,
            onPressed: () {},
          ),
        ),
        onFieldSubmitted: (value) {
          print("Search query: $value");
        },
      ),
    );
  }
}
