import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourism_app/core/component/app_bar_sharred.dart';
import 'package:tourism_app/core/component/cache_image.dart';
import 'package:tourism_app/core/network/end_points.dart';
import 'package:tourism_app/core/utils/constants_models.dart';
import 'package:tourism_app/core/utils/navigate.dart';
import 'package:tourism_app/features/home/manager/restaurant/cubit/restaurant_cubit.dart';
import 'package:tourism_app/features/home/manager/favorite/cubit/favorite_cubit.dart';
import 'package:tourism_app/features/menu/data/models/resturant_model.dart';
import 'package:tourism_app/features/menu/views/restaurant_details_view.dart';

class RestaurantsView extends StatefulWidget {
  const RestaurantsView({super.key});

  @override
  State<RestaurantsView> createState() => _RestaurantsViewState();
}

class _RestaurantsViewState extends State<RestaurantsView> {
  @override
  void initState() {
    super.initState();
    // Load restaurants when the view initializes
    RestaurantCubit.of(context).getRestaurants(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: shareAppBar(
        context,
        nameAppBar: 'Restaurants',
      ),
      body: BlocBuilder<RestaurantCubit, RestaurantState>(
        builder: (context, state) {
          if (state is RestaurantLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is RestaurantError) {
            return _buildErrorState(state.e);
          } else if (state is RestaurantSuccess) {
            return _buildRestaurantsGrid();
          }
          return _buildEmptyState();
        },
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[500],
                  ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                RestaurantCubit.of(context).getRestaurants(context: context);
              },
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No Restaurants Available',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Restaurants will be available soon',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[500],
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRestaurantsGrid() {
    List<ResturantsModel> restaurants = ConstantsModels.restaurantModel ?? [];

    if (restaurants.isEmpty) {
      return _buildEmptyState();
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 1.3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: restaurants.length,
        itemBuilder: (context, index) {
          return RestaurantCard(restaurant: restaurants[index]);
        },
      ),
    );
  }
}

class RestaurantCard extends StatefulWidget {
  final ResturantsModel restaurant;

  const RestaurantCard({
    super.key,
    required this.restaurant,
  });

  @override
  State<RestaurantCard> createState() => _RestaurantCardState();
}

class _RestaurantCardState extends State<RestaurantCard> {
  late bool isFavorited;

  @override
  void initState() {
    super.initState();
    isFavorited = widget.restaurant.isFavorited ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          context.navigateToPage(RestaurantDetailsView(restaurantId: widget.restaurant.id?.toInt() ?? -1));
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              // Restaurant Image
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: widget.restaurant.thumbnailUrl != null
                      ? CacheImage(
                          imageUrl: '${EndPoints.domain}${widget.restaurant.thumbnailUrl}',
                          width: double.infinity,
                          height: double.infinity,
                          boxFit: BoxFit.cover,
                          borderRadius: 16,
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
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.restaurant,
                              size: 60,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                ),
              ),

              // Gradient Overlay
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),

              // Favorite Button
              Positioned(
                top: 12,
                right: 12,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isFavorited = !isFavorited;
                    });
                    FavoriteCubit.of(context).toggleFavorite(
                      context: context,
                      entityId: widget.restaurant.id?.toInt() ?? 0,
                      entityType: 'restaurant',
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isFavorited ? Icons.favorite : Icons.favorite_border,
                      color: isFavorited ? Colors.red : Colors.grey[600],
                      size: 20,
                    ),
                  ),
                ),
              ),

              // Cuisine Badge
              if (widget.restaurant.cuisine != null)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.restaurant.cuisine!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

              // Restaurant Information
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.8),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Restaurant Name
                      Text(
                        widget.restaurant.name ?? 'Unknown Restaurant',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),

                      // Location
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.white70,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${widget.restaurant.city ?? ''}, ${widget.restaurant.country ?? ''}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Rating and Price
                      Row(
                        children: [
                          // Rating
                          if (widget.restaurant.stars != null) ...[
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  widget.restaurant.stars!.toStringAsFixed(1),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 16),
                          ],

                          // Average Price
                          if (widget.restaurant.averagePrice != null) ...[
                            Text(
                              'Avg \$${widget.restaurant.averagePrice}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'per meal',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
