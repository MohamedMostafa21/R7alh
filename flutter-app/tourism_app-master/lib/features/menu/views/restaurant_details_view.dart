import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourism_app/core/component/app_bar_sharred.dart';
import 'package:tourism_app/core/component/cache_image.dart';
import 'package:tourism_app/core/component/review_dialog.dart';
import 'package:tourism_app/core/network/end_points.dart';
import 'package:tourism_app/core/utils/constants_models.dart';
import 'package:tourism_app/features/home/manager/favorite/cubit/favorite_cubit.dart';
import 'package:tourism_app/features/home/manager/restaurant/cubit/restaurant_cubit.dart';
import 'package:tourism_app/features/menu/data/models/resturant_model.dart';
import 'package:tourism_app/features/tourguide/presentation/tourguide_details_view.dart';

class RestaurantDetailsView extends StatefulWidget {
  final int restaurantId;

  const RestaurantDetailsView({
    super.key,
    required this.restaurantId,
  });

  @override
  State<RestaurantDetailsView> createState() => _RestaurantDetailsViewState();
}

class _RestaurantDetailsViewState extends State<RestaurantDetailsView> {
  late bool isFavorited;
  int selectedImageIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    isFavorited = false;
    _pageController = PageController();

    // Fetch restaurant data by ID
    RestaurantCubit.of(context).getRestaurantById(restaurantId: widget.restaurantId);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<String> _getImageUrls(ResturantsModel restaurant) {
    List<String> imageUrls = [];
    if (restaurant.thumbnailUrl != null) {
      imageUrls.add('${EndPoints.domain}${restaurant.thumbnailUrl}');
    }
    if (restaurant.imageUrls != null) {
      imageUrls.addAll(restaurant.imageUrls!.map((url) => '${EndPoints.domain}$url'));
    }

    if (imageUrls.isEmpty) {
      imageUrls = ['https://via.placeholder.com/400x250']; // Fallback image
    }

    // Limit to maximum 10 images
    return imageUrls.take(10).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RestaurantCubit, RestaurantState>(
      builder: (context, state) {
        if (state is RestaurantLoading) {
          return Scaffold(
            appBar: shareAppBar(
              context,
              nameAppBar: 'Restaurant Details',
            ),
            body: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            ),
          );
        }

        if (state is RestaurantError) {
          return Scaffold(
            appBar: shareAppBar(
              context,
              nameAppBar: 'Restaurant Details',
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load restaurant details',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.red[700],
                          fontWeight: FontWeight.w600,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.e,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      RestaurantCubit.of(context).getRestaurantById(restaurantId: widget.restaurantId);
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (ConstantsModels.restaurantObject == null) {
          return Scaffold(
            appBar: shareAppBar(
              context,
              nameAppBar: 'Restaurant Details',
            ),
            body: const Center(
              child: Text('Restaurant not found'),
            ),
          );
        }

        ResturantsModel restaurant = ConstantsModels.restaurantObject!;

        // Set favorite status when restaurant is loaded
        if (isFavorited != (restaurant.isFavorited ?? false)) {
          isFavorited = restaurant.isFavorited ?? false;
        }

        return Scaffold(
          appBar: shareAppBar(
            context,
            nameAppBar: restaurant.name ?? 'Restaurant Details',
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Gallery Section
                _buildImageGallery(restaurant),

                // Main Content
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with title and favorite button
                      _buildHeader(restaurant),
                      const SizedBox(height: 16),

                      // Location and rating info
                      _buildLocationRating(restaurant),
                      const SizedBox(height: 16),

                      // Price information
                      if (restaurant.averagePrice != null) ...[
                        _buildPriceSection(restaurant),
                        const SizedBox(height: 16),
                      ],

                      // Description Section
                      _buildDescriptionSection(restaurant),
                      const SizedBox(height: 16),

                      // Restaurant Information
                      _buildRestaurantInfoSection(restaurant),
                      const SizedBox(height: 16),

                      // Menu/Meals Section
                      _buildMenuSection(restaurant),
                      const SizedBox(height: 16),

                      // Map Section (placeholder)
                      _buildMapSection(),
                      const SizedBox(height: 20),

                      // Reviews Section
                      ReviewingSection(
                        entityName: 'restaurant',
                        entityId: restaurant.id?.toInt() ?? -1,
                      ),
                      const SizedBox(height: 100), // Space for bottom button
                    ],
                  ),
                ),
              ],
            ),
          ),
          // floatingActionButton: _buildReservationButton(restaurant),
          // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }

  Widget _buildImageGallery(ResturantsModel restaurant) {
    List<String> imageUrls = _getImageUrls(restaurant);

    return SizedBox(
      height: 300,
      child: Stack(
        children: [
          // Main image display
          PageView.builder(
            controller: _pageController,
            itemCount: imageUrls.length,
            onPageChanged: (index) {
              setState(() {
                selectedImageIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return CacheImage(
                borderRadius: 0,
                imageUrl: imageUrls[index],
                width: double.infinity,
                height: 300,
                boxFit: BoxFit.cover,
                errorColor: Colors.grey[300]!,
              );
            },
          ),

          // Image indicators
          if (imageUrls.length > 1)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  imageUrls.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: selectedImageIndex == index ? 20 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: selectedImageIndex == index ? Colors.white : Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),

          // Gradient overlay for better text visibility
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.5),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ResturantsModel restaurant) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                restaurant.name ?? 'Unknown Restaurant',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              if (restaurant.cuisine != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    restaurant.cuisine!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              isFavorited = !isFavorited;
            });
            FavoriteCubit.of(context).toggleFavorite(
              context: context,
              entityId: restaurant.id?.toInt() ?? 0,
              entityType: 'restaurant',
            );
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              isFavorited ? Icons.favorite : Icons.favorite_border,
              color: isFavorited ? Colors.red : Colors.grey,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationRating(ResturantsModel restaurant) {
    return Row(
      children: [
        const Icon(Icons.location_on, color: Colors.grey, size: 18),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            '${restaurant.city ?? ''}, ${restaurant.country ?? ''}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ),
        if (restaurant.stars != null) ...[
          const SizedBox(width: 16),
          const Icon(Icons.star, color: Colors.amber, size: 18),
          const SizedBox(width: 4),
          Text(
            restaurant.stars!.toStringAsFixed(1),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ],
    );
  }

  Widget _buildPriceSection(ResturantsModel restaurant) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor.withOpacity(0.1),
            Theme.of(context).primaryColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.attach_money,
            color: Theme.of(context).primaryColor,
            size: 24,
          ),
          const SizedBox(width: 8),
          Text(
            'Average Price: ',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            '\$${restaurant.averagePrice}',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
          ),
          const Spacer(),
          Text(
            'per person',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(ResturantsModel restaurant) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About This Restaurant',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          restaurant.description ??
              'A wonderful dining experience with authentic cuisine and excellent service. Perfect for enjoying quality meals in a great atmosphere.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                height: 1.5,
              ),
        ),
      ],
    );
  }

  Widget _buildRestaurantInfoSection(ResturantsModel restaurant) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Restaurant Information',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          if (restaurant.cuisine != null) _buildInfoRow('Cuisine', restaurant.cuisine!, Icons.restaurant_menu),
          if (restaurant.location != null) _buildInfoRow('Location', restaurant.location!, Icons.location_on),
          _buildInfoRow('Opening Hours', '10:00 AM - 11:00 PM', Icons.access_time),
          _buildInfoRow('Contact', '+20 123 456 789', Icons.phone),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Theme.of(context).primaryColor),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(ResturantsModel restaurant) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.menu_book,
              color: Theme.of(context).primaryColor,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              'Menu & Specialties',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Spacer(),
            if (restaurant.meals != null && restaurant.meals!.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${restaurant.meals!.length} items',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (restaurant.meals == null || restaurant.meals!.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.restaurant_menu,
                  size: 48,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 12),
                Text(
                  'Menu Coming Soon',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'We are working on bringing you detailed menu information',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[500],
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        else
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: restaurant.meals!.map((meal) => MealCard(meal: meal)).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildMapSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Location on Map',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey[200],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                // Placeholder for map
                Container(
                  width: double.infinity,
                  height: 150,
                  color: Colors.grey[300],
                  child: Icon(
                    Icons.map,
                    size: 60,
                    color: Colors.grey[600],
                  ),
                ),
                // Map overlay button
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Opening map...')),
                        );
                      },
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'View on Map',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Meal Card Widget is already defined above
class MealCard extends StatelessWidget {
  final Meals meal;

  const MealCard({
    super.key,
    required this.meal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Meal Image
            Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
              child: meal.thumbnailUrl != null
                  ? CacheImage(
                      imageUrl: '${EndPoints.domain}${meal.thumbnailUrl}',
                      width: double.infinity,
                      height: 140,
                      boxFit: BoxFit.cover,
                      borderRadius: 0,
                      errorColor: Colors.grey[300]!,
                    )
                  : Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Theme.of(context).primaryColor.withOpacity(0.3),
                            Theme.of(context).primaryColor.withOpacity(0.1),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.fastfood,
                          size: 48,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
            ),

            // Meal Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Meal Name
                  Text(
                    meal.name ?? 'Delicious Meal',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                  ),

                  const SizedBox(height: 8),

                  // Meal Description
                  if (meal.description != null && meal.description!.isNotEmpty)
                    Text(
                      meal.description!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                            height: 1.4,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                  const SizedBox(height: 12),

                  // Price and Order Button Row
                  Row(
                    children: [
                      // Price
                      if (meal.price != null)
                        Expanded(
                          child: Text(
                            '\$${meal.price}',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                      const SizedBox(width: 8),

                      // Order Button
                      ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Added ${meal.name} to order'),
                              backgroundColor: Theme.of(context).primaryColor,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Order',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
