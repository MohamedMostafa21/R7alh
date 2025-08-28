import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tourism_app/core/component/buttons/custom_text_button.dart';
import 'package:tourism_app/core/component/cache_image.dart';
import 'package:tourism_app/core/component/custom_card_image_hotels.dart';
import 'package:tourism_app/core/component/custom_text_form_field.dart';
import 'package:tourism_app/core/utils/app_icons.dart';
import 'package:tourism_app/core/utils/app_images.dart';
import 'package:tourism_app/core/utils/navigate.dart';
import 'package:tourism_app/features/city/persentaiton/hotel_view.dart';
import 'package:tourism_app/features/home/plan/presentation/plan_details_view.dart';
import 'package:tourism_app/features/home/plan/presentation/widgets/plan_gallery.dart';
import 'package:tourism_app/features/home/presentation/home_view.dart';
import 'package:tourism_app/features/home/restaurant/presentation/restaurants_view_body.dart';

class CityDetailsView extends StatelessWidget {
  const CityDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text('City Name'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: PlanGallery(),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cairo',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Lorem Ipsumis simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      Text(
                        'Famous Tourist Attractions',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Spacer(),
                      Text(
                        'View All',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey),
                      )
                    ],
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(10, (index) {
                      return PlaceCard();
                    }),
                  ),
                ),
                const SizedBox(height: 15),
                RestaurantNearbySection(),
                const SizedBox(height: 15),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      Text(
                        'Hotels',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Spacer(),
                      InkWell(
                        onTap: () => context.navigateToPage(HotelListScreen()),
                        child: Text(
                          'View All',
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(5, (index) {
                        return HotelCard();
                      }),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showReviewDialog(BuildContext context) {
    double rating = 3.0; // Initial rating value

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text('Write a Review'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Score:'),
                  const SizedBox(height: 8),
                  RatingBar.builder(
                    initialRating: rating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        rating = rating;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                      contentPadding: EdgeInsets.all(5),
                      maxLines: 6,
                      outPadding: EdgeInsets.zero,
                      controller: TextEditingController(),
                      hintText: 'Review')
                ],
              ),
              actions: <Widget>[
                CustomTextButton(
                    onPress: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Post',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),
                    ))
              ],
            );
          },
        );
      },
    );
  }
}

class RestaurantNearbySection extends StatelessWidget {
  const RestaurantNearbySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title with 'See All' Button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Restaurant&Cafe Nearby',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextButton(
                onPressed: () {
                  context.navigateToPage(RestaurantCafeViewBody());
                },
                child: Text(
                  'View All',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),

        // Horizontal Scroll List
        SizedBox(
          height: 250,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: 5, // Number of restaurants (replace with dynamic count)
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              return NearbyRestaurantCard(
                imageUrl: '',
                name: 'The Plo',
                location: 'Luxor, Egypt',
                rating: 5.0,
              );
            },
          ),
        ),
      ],
    );
  }
}

class NearbyRestaurantCard extends StatefulWidget {
  final String imageUrl;
  final String name;
  final String location;
  final double rating;

  const NearbyRestaurantCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.location,
    required this.rating,
  });

  @override
  _NearbyRestaurantCardState createState() => _NearbyRestaurantCardState();
}

class _NearbyRestaurantCardState extends State<NearbyRestaurantCard> {
  bool isFavorite = false; // To track if the restaurant is marked as favorite

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150, // Card width
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Background image
            CacheImage(
              boxFit: BoxFit.cover,
              imageUrl: widget.imageUrl,
              errorColor: Colors.grey,
            ),

            // Favorite Icon
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    isFavorite = !isFavorite; // Toggle favorite state
                  });
                },
              ),
            ),

            // Details (name, location, rating)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                // width: 150,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Restaurant Name
                    Text(
                      widget.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // Location
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 12, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          widget.location,
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),

                    // Rating Stars
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          Icons.star,
                          size: 14,
                          color: index < widget.rating ? Colors.amber : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HotelCard extends StatefulWidget {
  const HotelCard({super.key});

  @override
  _HotelCardState createState() => _HotelCardState();
}

class _HotelCardState extends State<HotelCard> {
  bool isFavorited = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 300,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black.withOpacity(0.05)),
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 2,
                color: Colors.grey.withOpacity(0.1),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section
              CacheImage(
                customBorderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                imageUrl: '',
                errorColor: Colors.grey,
                height: 110,
              ),

              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hotel Name and Favorite Icon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Four Seasons',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            isFavorited ? Icons.favorite : Icons.favorite_border,
                            color: isFavorited ? Colors.red : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              isFavorited = !isFavorited;
                            });
                          },
                        ),
                      ],
                    ),

                    // Rating
                    Row(
                      children: [
                        RatingBarIndicator(
                          rating: 4.0,
                          itemBuilder: (context, index) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 20.0,
                          direction: Axis.horizontal,
                        ),
                        SizedBox(width: 5),
                        Text(
                          '4.0',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 5),

                    // Location
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.grey,
                          size: 16,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Luxor, Egypt',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10),

                    // Price
                    Text(
                      'Starting from 20\$',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
