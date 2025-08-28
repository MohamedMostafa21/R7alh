import 'package:flutter/material.dart';
import 'package:tourism_app/core/component/custom_card_image_restaurant.dart';
import 'package:tourism_app/core/utils/app_images.dart';

class RestaurantCafeBody extends StatelessWidget {
  RestaurantCafeBody({super.key});
  final List<Map<String, dynamic>> restaurants = [
    {
      "image": AppImages.rectangleAttraction,
      "name": "East and West Banks",
      "governorate": "Luxor",
      "country": "Egypt",
      "rate": 4,
      "iconData": Icons.location_pin,
    },
    {
      "image": AppImages.rectangleAttraction,
      "name": "Khan El-Khalili",
      "governorate": "Cairo",
      "country": "Egypt",
      "rate": 5,
      "iconData": Icons.location_pin,
    },
    {
      "image": AppImages.rectangleAttraction,
      "name": "Giza Pyramids",
      "governorate": "Giza",
      "country": "Egypt",
      "rate": 5,
      "iconData": Icons.location_pin,
    },
    {
      "image": AppImages.rectangleAttraction,
      "name": "Alexandria Corniche",
      "governorate": "Alexandria",
      "country": "Egypt",
      "rate": 4,
      "iconData": Icons.location_pin,
    },
    {
      "image": AppImages.rectangleAttraction,
      "name": "Siwa Oasis",
      "governorate": "Matrouh",
      "country": "Egypt",
      "rate": 5,
      "iconData": Icons.location_pin,
    },
    {
      "image": AppImages.rectangleAttraction,
      "name": "Mount Sinai",
      "governorate": "South Sinai",
      "country": "Egypt",
      "rate": 4,
      "iconData": Icons.location_pin,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: restaurants.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemBuilder: (context, index) {
          final restaurant = restaurants[index];
          return CustomCardImageRestaurant(
              name: restaurant["name"],
              governorate: restaurant["governorate"],
              country: restaurant["country"],
              rate: restaurant["rate"],
              iconData: restaurant["iconData"],
              image: restaurant["image"]);
        },
      ),
    );
  }
}
