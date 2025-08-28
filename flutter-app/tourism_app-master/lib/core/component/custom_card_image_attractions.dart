import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCardImageAttractions extends StatelessWidget {
  final String image;
  final String name;
  final String governorate;
  final String country;
  final int rate;
  final IconData iconData;
  final String descraption;
  final VoidCallback? onTap;

  const CustomCardImageAttractions(
      {super.key,
      required this.name,
      required this.governorate,
      required this.country,
      required this.rate,
      required this.iconData,
      required this.descraption,
      this.onTap,
      required this.image});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              image,
              height: 200.h,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, top: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Row(
                    children: [
                      Icon(
                        iconData,
                        color: Colors.white,
                        size: 16.w,
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Text(
                        governorate,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Text(
                        country,
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
                                  index < rate ? Icons.star : Icons.star_border,
                                  color: Colors.amber,
                                  size: 16.w,
                                )),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Icon(
                        iconData,
                        color: Colors.white,
                        size: 16.w,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    descraption,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
