import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCardImageRestaurant extends StatefulWidget {
  final String image;
  final String name;
  final String governorate;
  final String country;
  final int rate;
  final IconData iconData;

  final VoidCallback? onTap;

  const CustomCardImageRestaurant(
      {super.key,
      required this.name,
      required this.governorate,
      required this.country,
      required this.rate,
      required this.iconData,
      this.onTap,
      required this.image});

  @override
  State<CustomCardImageRestaurant> createState() =>
      _CustomCardImageRestaurantState();
}

class _CustomCardImageRestaurantState extends State<CustomCardImageRestaurant> {
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Row(
                    children: [
                      Icon(
                        widget.iconData,
                        color: Colors.white,
                        size: 16.w,
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Text(
                        widget.governorate,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Text(
                        widget.country,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Row(
                    children: [
                      Row(
                        children: List.generate(
                            5,
                            (index) => Icon(
                                  index < widget.rate
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.amber,
                                  size: 16.w,
                                )),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Icon(
                        widget.iconData,
                        color: Colors.white,
                        size: 16.w,
                      ),
                    ],
                  ),
                ],
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
