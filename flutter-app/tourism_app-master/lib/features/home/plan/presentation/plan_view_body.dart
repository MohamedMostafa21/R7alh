import 'package:flutter/material.dart';
import 'package:tourism_app/core/component/cache_image.dart';
import 'package:tourism_app/core/component/custom_app_bar.dart';
import 'package:tourism_app/core/component/custom_search_bar.dart';
import 'package:tourism_app/core/themes/colors.dart';

class PlanViewBody extends StatelessWidget {
  const PlanViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        title: "Choose Your Plan",
        icon: Icons.arrow_back,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
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
                itemCount: 10,
                itemBuilder: (context, index) {
                  return PlanCardVertical();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlanCardVertical extends StatelessWidget {
  const PlanCardVertical({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Get the screen width
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Stack(
        children: [
          CacheImage(
            height: 170,
            width: screenWidth, // Set width to full screen width with some padding
            imageUrl: '',
            errorColor: Colors.grey,
          ),
          Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Egypt Through The Ages',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '1-Day Plan',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Tour Guide',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Explore Egypt through its most iconic historical sites with a professional guide. Perfect for a one-day adventure!',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white.withOpacity(0.7)),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
