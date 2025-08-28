import 'package:flutter/material.dart';
import 'package:tourism_app/core/component/custom_search_bar.dart';
import 'package:tourism_app/features/city/persentaiton/city_details_view.dart';

class HotelListScreen extends StatelessWidget {
  const HotelListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text('Hotels'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
          Expanded(
            child: ListView.builder(
              itemCount: 10, // Number of hotel cards
              itemBuilder: (context, index) {
                return HotelCard();
              },
            ),
          ),
        ],
      ),
    );
  }
}
