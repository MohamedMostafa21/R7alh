import 'package:flutter/material.dart';
import 'package:tourism_app/core/component/custom_app_bar.dart';
import 'package:tourism_app/core/component/custom_card_image_hotels.dart';
import 'package:tourism_app/core/component/custom_card_image_tourist_destination.dart';
import 'package:tourism_app/core/component/custom_search_bar.dart';
import 'package:tourism_app/core/utils/app_images.dart';

class TouristDestinationViewBody extends StatelessWidget {
  const TouristDestinationViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Choose your Tourist destination ",
        icon: Icons.arrow_back,
      ),
      body: Column(
        children: [
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
              itemCount: 12,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 6,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                return CustomCardImageDestination(
                  name: 'Cairo',
                  image: AppImages.Rectangle2Hotels,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
