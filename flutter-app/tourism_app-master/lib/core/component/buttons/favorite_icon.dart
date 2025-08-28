import 'package:flutter/material.dart';

class FavoriteIcon extends StatefulWidget {
  const FavoriteIcon({
    super.key,
  });

  @override
  _FavoriteIconState createState() => _FavoriteIconState();
}

class _FavoriteIconState extends State<FavoriteIcon> {
  bool isFavorited = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isFavorited = !isFavorited;
        });
      },
      child: Container(
        padding: EdgeInsets.all(7),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.08)),
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.favorite,
          color: isFavorited ? Colors.red : Colors.grey.withOpacity(0.3),
          size: 15.0, // or use 15.sp if using a package like `flutter_screenutil`
        ),
      ),
    );
  }
}
