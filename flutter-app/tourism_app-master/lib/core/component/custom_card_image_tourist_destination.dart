import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCardImageDestination extends StatefulWidget {
  final String image;
  final String name;

  final VoidCallback? onTap;

  const CustomCardImageDestination(
      {super.key, required this.name, this.onTap, required this.image});

  @override
  State<CustomCardImageDestination> createState() =>
      _CustomCardImageRestaurantState();
}

class _CustomCardImageRestaurantState
    extends State<CustomCardImageDestination> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              widget.image,
              height: 300.h,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 6, right: 6, top: 50),
              child: Positioned(
                top: 2,
                child: Text(
                  widget.name,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.grey,
                  size: 26.w,
                ),
                onPressed: () {
                  setState(() {
                    isFavorite = !isFavorite;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
