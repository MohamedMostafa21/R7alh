import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCardNotification extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final DateTime dateTime;
  final VoidCallback? onTap;

  const CustomCardNotification({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    required this.dateTime,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Stack(children: [
          Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  CircleAvatar(
                    radius: 30.w,
                    backgroundImage: AssetImage(image),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                              fontSize: 15.sp, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Color(0xff9B9496),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  dateTime.toString(),
                  style: TextStyle(fontSize: 7.sp),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
