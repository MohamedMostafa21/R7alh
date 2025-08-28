import 'package:flutter/material.dart';
import 'package:tourism_app/core/component/custom_card_image_hotels.dart';
import 'package:tourism_app/core/utils/app_images.dart';

class HotelsBody extends StatelessWidget {
  const HotelsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
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
        ],
      ),
    );
  }
}
