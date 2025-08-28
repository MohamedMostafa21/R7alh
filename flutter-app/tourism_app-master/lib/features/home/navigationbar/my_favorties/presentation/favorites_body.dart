import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tourism_app/core/themes/colors.dart';
import 'package:tourism_app/features/home/navigationbar/my_favorties/presentation/widgets/attractions_body.dart';
import 'package:tourism_app/features/home/navigationbar/my_favorties/presentation/widgets/hotels_body.dart';
import 'package:tourism_app/features/home/navigationbar/my_favorties/presentation/widgets/restaurant_cafe_body.dart';
import 'package:tourism_app/features/home/navigationbar/my_favorties/presentation/widgets/tourguide_body.dart';

class MyFavoritesBody extends StatefulWidget {
  const MyFavoritesBody({super.key});

  @override
  State<MyFavoritesBody> createState() => _MyFavoritesBodyState();
}

class _MyFavoritesBodyState extends State<MyFavoritesBody> {
  Color dafultColor = Colors.black;
  Color pressedColor = Colors.blue;
  String selectedText = '';

  void _onTap(String text) {
    setState(() {
      dafultColor = pressedColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                TextClikable('Attractions'),
                SizedBox(width: 7),
                TextClikable('Hotels'),
                SizedBox(width: 7),
                TextClikable('RestaurantCafe'),
                SizedBox(width: 7),
                TextClikable('TourGuides'),
              ],
            ),
          ),
          Expanded(child: ShowContent()),
        ],
      ),
    );
  }

  Widget TextClikable(String text) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedText = text;
        });
      },
      child: Text(
        text,
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
          color: selectedText == text ? Colors.blue : Colors.black,
        ),
      ),
    );
  }

  Widget ShowContent() {
    if (selectedText == 'Attractions') {
      return AttractionsBody();
    } else if (selectedText == 'Hotels') {
      return HotelsBody();
    } else if (selectedText == 'RestaurantCafe') {
      return RestaurantCafeBody();
    } else if (selectedText == 'TourGuides') {
      return TourguideBody();
    } else {
      return const Center(child: Text('Select an option'));
    }
  }
}