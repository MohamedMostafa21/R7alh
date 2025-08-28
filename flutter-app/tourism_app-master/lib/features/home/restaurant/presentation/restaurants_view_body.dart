import 'package:flutter/material.dart';
import 'package:tourism_app/core/component/custom_app_bar.dart';
import 'package:tourism_app/core/component/custom_card_image_restaurant.dart';
import 'package:tourism_app/core/component/custom_search_bar.dart';
import 'package:tourism_app/core/utils/app_images.dart';
import 'package:tourism_app/features/city/persentaiton/city_details_view.dart';

class RestaurantCafeViewBody extends StatelessWidget {
  RestaurantCafeViewBody({super.key});
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
    return Scaffold(
        appBar: CustomAppBar(
          title: "Restaurants",
          icon: Icons.arrow_back,
        ),
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomSearchBar(
              hintText: "Search",
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey,
              ),
              suffixIcon: Icon(Icons.filter_list, color: Colors.grey),
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                itemCount: restaurants.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  final restaurant = restaurants[index];
                  return NearbyRestaurantCard(
                    imageUrl: '',
                    name: 'The Plo',
                    location: 'Luxor, Egypt',
                    rating: 5.0,
                  );
                },
              ),
            ),
          ),
        ]));
  }
}
