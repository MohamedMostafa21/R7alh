import 'package:flutter/material.dart';
import 'package:tourism_app/core/component/custom_app_bar.dart';
import 'package:tourism_app/core/component/custom_card_image_hotels.dart';
import 'package:tourism_app/core/component/custom_search_bar.dart';
import 'package:tourism_app/core/utils/app_images.dart';

class HotelsViewBody extends StatelessWidget {
  const HotelsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Hotels",
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
            child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return CustomCardImageHotels(
                    country: 'Egypt',
                    governorate: 'Luxor',
                    iconData: Icons.location_pin,
                    image: AppImages.Rectangle2Hotels,
                    name: 'Four Seasons',
                    price: 20,
                    rate: 3,
                  );
                }),
          ),
        ],
      ),
    );
  }
}
