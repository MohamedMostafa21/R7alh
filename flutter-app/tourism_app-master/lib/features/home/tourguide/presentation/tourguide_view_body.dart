import 'package:flutter/material.dart';
import 'package:tourism_app/core/component/custom_app_bar.dart';
import 'package:tourism_app/core/component/custom_card_image_tourguide.dart';
import 'package:tourism_app/core/component/custom_search_bar.dart';
import 'package:tourism_app/core/utils/app_images.dart';

class TourguideViewBody extends StatefulWidget {
  const TourguideViewBody({super.key});

  @override
  State<TourguideViewBody> createState() => _TourguideBodyState();
}

class _TourguideBodyState extends State<TourguideViewBody> {
  final List<Map<String, dynamic>> tourGuide = [
    {
      "image": AppImages.groupTourguide,
      "language1": 'English',
      "language2": 'Japanese',
      "name": 'Ahmed fathy',
      "rate": 1,
      "price": 500.0,
    },
    {
      "image": AppImages.groupTourguide,
      "language1": 'English',
      "language2": 'Japanese',
      "name": 'Ahmed fathy',
      "rate": 1,
      "price": 500.0,
    },
    {
      "image": AppImages.groupTourguide,
      "language1": 'English',
      "language2": 'Japanese',
      "name": 'Ahmed fathy',
      "rate": 1,
      "price": 500.0,
    },
    {
      "image": AppImages.groupTourguide,
      "language1": 'English',
      "language2": 'Japanese',
      "name": 'Ahmed fathy',
      "rate": 1,
      "price": 500.0,
    },
    {
      "image": AppImages.groupTourguide,
      "language1": 'English',
      "language2": 'Japanese',
      "name": 'Ahmed fathy',
      "rate": 1,
      "price": 500.0,
    },
    {
      "image": AppImages.groupTourguide,
      "language1": 'English',
      "language2": 'Japanese',
      "name": 'Ahmed fathy',
      "rate": 1,
      "price": 500.0,
    },
    {
      "image": AppImages.groupTourguide,
      "language1": 'English',
      "language2": 'Japanese',
      "name": 'Ahmed fathy',
      "rate": 1,
      "price": 500.0,
    }
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "tour Guides",
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
          child: GridView.builder(
              itemCount: tourGuide.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                final tourguide = tourGuide[index];
                return CustomCardImageTourguide(
                    name: tourguide["name"],
                    rate: tourguide["rate"],
                    image: tourguide["image"],
                    language1: tourguide["language1"],
                    language2: tourguide["language2"],
                    price: tourguide["price"]);
              }),
        ),
      ]),
    );
  }
}
