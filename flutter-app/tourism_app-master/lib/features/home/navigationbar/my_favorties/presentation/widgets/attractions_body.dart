import 'package:flutter/material.dart';
import 'package:tourism_app/core/component/custom_card_image_attractions.dart';
import 'package:tourism_app/core/utils/app_images.dart';

class AttractionsBody extends StatelessWidget {
  const AttractionsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [

          ListView.builder(
            shrinkWrap: true, 
              physics: NeverScrollableScrollPhysics(),
            itemCount: 10,
            
            itemBuilder: (context,index){
            return CustomCardImageAttractions(
            image: AppImages.rectangleAttraction,
            name: 'East and West Banks',
            governorate: 'Luxor',
            country: 'Egypt',
            rate: 4,
            iconData: Icons.location_pin,
            descraption:
                'Lorem Ipsum is simply dummy text of the printing and typesetting industry. ',
            onTap: () {
              print('Card Tapped!');
            },
          );
          
          })

          
        ],
      ),
    );
  }
}
