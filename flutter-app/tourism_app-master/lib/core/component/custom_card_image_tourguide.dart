import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCardImageTourguide extends StatefulWidget {
  final String image;
  final String name;
  final String language1;
  final String language2;
  final int rate;
  final double price;

  final VoidCallback? onTap;

  const CustomCardImageTourguide({
    super.key,
    required this.name,
    required this.rate,
    this.onTap,
    required this.image,
    required this.language1,
    required this.language2,
    required this.price,
  });

  @override
  _CustomCardImageTourguideState createState() =>
      _CustomCardImageTourguideState();
}

class _CustomCardImageTourguideState extends State<CustomCardImageTourguide> {
  bool isFavourite = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        elevation: 4,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 165.h,
              width: double.infinity,
              child: Stack(
                children: [
                  Image.asset(
                    widget.image,
                    height: double.infinity,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 10.h,
                    left: 10.w,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isFavourite = !isFavourite;
                        });
                      },
                      child: Icon(
                        isFavourite ? Icons.favorite : Icons.favorite_border,
                        color: isFavourite ? Colors.red : Colors.black,
                        size: 24.sp,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0.h,
                    right: 0.w,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade900,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        "${widget.price.toStringAsFixed(0)} EGP/Hr",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment
                  //     .spaceBetween,
                  children: [
                    Text(
                      widget.name,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.language,
                          color: Colors.grey,
                          size: 10.sp,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          "${widget.language1}, ${widget.language2}",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.sp,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 12.sp,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          widget.rate.toStringAsFixed(1),
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
