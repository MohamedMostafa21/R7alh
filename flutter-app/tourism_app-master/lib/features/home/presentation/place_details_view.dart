import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tourism_app/core/component/app_bar_sharred.dart';
import 'package:tourism_app/core/component/buttons/custom_text_button.dart';
import 'package:tourism_app/core/component/cache_image.dart';
import 'package:tourism_app/core/component/review_dialog.dart';
import 'package:tourism_app/core/network/end_points.dart';
import 'package:tourism_app/core/utils/app_icons.dart';
import 'package:tourism_app/core/utils/constants_models.dart';
import 'package:tourism_app/core/utils/navigate.dart';
import 'package:tourism_app/features/home/data/models/place_mode.dart';
import 'package:tourism_app/features/home/data/models/activity_model.dart';
import 'package:tourism_app/features/home/manager/places/cubit/place_cubit.dart';
import 'package:tourism_app/features/home/manager/favorite/cubit/favorite_cubit.dart';
import 'package:tourism_app/features/home/manager/reviews/cubit/reviews_cubit.dart';
import 'package:tourism_app/features/home/manager/getActivites/cubit/get_activities_cubit.dart';
import 'package:tourism_app/features/home/presentation/home_view.dart';
import 'package:tourism_app/features/home/restaurant/presentation/restaurants_view_body.dart';
import 'package:tourism_app/features/tourguide/presentation/tourguide_details_view.dart';

class PlaceDetailsView extends StatefulWidget {
  final int placeId;

  const PlaceDetailsView({
    super.key,
    required this.placeId,
  });

  @override
  State<PlaceDetailsView> createState() => _PlaceDetailsViewState();
}

class _PlaceDetailsViewState extends State<PlaceDetailsView> {
  late bool isFavorited;
  int selectedImageIndex = 0;
  late PageController _pageController;
  Timer? _autoScrollTimer;
  bool _userInteracting = false;

  @override
  void initState() {
    super.initState();
    isFavorited = false;
    _pageController = PageController();

    // Fetch place data by ID
    PlaceCubit.of(context).getPlaceById(placeId: widget.placeId);
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    if (ConstantsModels.placeObject == null) return;
    List<String> imageUrls = _getImageUrls(ConstantsModels.placeObject!);
    if (imageUrls.length <= 1) return; // Don't auto-scroll if only one image

    _autoScrollTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (!_userInteracting && mounted) {
        int nextPage = (selectedImageIndex + 1) % imageUrls.length;
        _pageController.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _stopAutoScroll() {
    _autoScrollTimer?.cancel();
  }

  void _resumeAutoScroll() {
    if (!_userInteracting && mounted) {
      _stopAutoScroll();
      _startAutoScroll();
    }
  }

  List<String> _getImageUrls(PlaceModel placeModel) {
    List<String> imageUrls = [];
    if (placeModel.thumbnailUrl != null) {
      imageUrls.add('${EndPoints.domain}${placeModel.thumbnailUrl}');
    }
    if (placeModel.imageUrls != null) {
      imageUrls.addAll(placeModel.imageUrls!.map((url) => '${EndPoints.domain}$url'));
    }

    if (imageUrls.isEmpty) {
      imageUrls = ['https://via.placeholder.com/400x250']; // Fallback image
    }

    return imageUrls;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaceCubit, PlaceState>(
      builder: (context, state) {
        if (state is PlaceLoading) {
          return Scaffold(
            appBar: shareAppBar(
              context,
              nameAppBar: 'Place Details',
            ),
            body: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            ),
          );
        }

        if (state is PlaceError) {
          return Scaffold(
            appBar: shareAppBar(
              context,
              nameAppBar: 'Place Details',
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
                    'Failed to load place details',
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
                      PlaceCubit.of(context).getPlaceById(placeId: widget.placeId);
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

        if (ConstantsModels.placeObject == null) {
          return Scaffold(
            appBar: shareAppBar(
              context,
              nameAppBar: 'Place Details',
            ),
            body: const Center(
              child: Text('Place not found'),
            ),
          );
        }

        PlaceModel placeModel = ConstantsModels.placeObject!;

        // Set up auto-scroll when data is loaded
        if (!_userInteracting) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _startAutoScroll();
          });
        }

        // Set favorite status and load additional data when place is loaded
        if (isFavorited != (placeModel.isFavorited ?? false)) {
          isFavorited = placeModel.isFavorited ?? false;
        }

        // Load reviews and activities for this place
        if (placeModel.id != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ReviewsCubit.of(context).getReviews(
              context: context,
              entityName: 'place',
              entityId: placeModel.id!,
            );

            GetActivitiesCubit.of(context).getActivityByPlaceId(
              placeId: placeModel.id!,
            );
          });
        }

        return Scaffold(
          appBar: shareAppBar(
            context,
            nameAppBar: placeModel.name ?? 'Place Details',
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Gallery Section
                _buildImageGallery(placeModel),

                // Main Content
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with title and favorite button
                      _buildHeader(placeModel),
                      const SizedBox(height: 16),

                      // Location and rating info
                      _buildLocationRating(placeModel),
                      const SizedBox(height: 16),

                      // Price information
                      if (placeModel.averagePrice != null) ...[
                        _buildPriceSection(placeModel),
                        const SizedBox(height: 16),
                      ],

                      // Description Section
                      _buildDescriptionSection(placeModel),
                      const SizedBox(height: 16),

                      // Place Information
                      _buildPlaceInfoSection(placeModel),
                      const SizedBox(height: 16),

                      // Activities Section
                      _buildActivitiesSection(),
                      const SizedBox(height: 16),

                      // Map Section (placeholder)
                      _buildMapSection(),
                      const SizedBox(height: 16),

                      // Reviews Section
                      _buildReviewsSection(entityId: placeModel.id?.toInt() ?? -1),
                      const SizedBox(height: 100), // Space for bottom button
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageGallery(PlaceModel placeModel) {
    List<String> imageUrls = _getImageUrls(placeModel);

    return SizedBox(
      height: 300,
      child: Stack(
        children: [
          // Main image display with auto-scroll
          GestureDetector(
            onPanStart: (_) {
              setState(() {
                _userInteracting = true;
              });
              _stopAutoScroll();
            },
            onPanEnd: (_) {
              setState(() {
                _userInteracting = false;
              });
              // Resume auto-scroll after user stops interacting
              Future.delayed(Duration(seconds: 2), () {
                if (!_userInteracting && mounted) {
                  _resumeAutoScroll();
                }
              });
            },
            onTap: () {
              // Pause auto-scroll on tap for 5 seconds
              setState(() {
                _userInteracting = true;
              });
              _stopAutoScroll();
              Future.delayed(Duration(seconds: 5), () {
                if (mounted) {
                  setState(() {
                    _userInteracting = false;
                  });
                  _resumeAutoScroll();
                }
              });
            },
            child: PageView.builder(
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
          ),

          // Auto-scroll pause indicator
          if (_userInteracting)
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.pause, color: Colors.white, size: 14),
                    SizedBox(width: 4),
                    Text(
                      'Auto-scroll paused',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
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
                    margin: EdgeInsets.symmetric(horizontal: 3),
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

  Widget _buildHeader(PlaceModel placeModel) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                placeModel.name ?? 'Unknown Place',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              if (placeModel.type != null) ...[
                const SizedBox(height: 4),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    placeModel.type!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              ],
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              isFavorited = !isFavorited;
            });
            // TODO: Integrate with FavoriteCubit
            FavoriteCubit.of(context).toggleFavorite(
              context: context,
              entityId: placeModel.id ?? 0,
              entityType: 'place',
            );
          },
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 2),
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

  Widget _buildLocationRating(PlaceModel placeModel) {
    return Row(
      children: [
        Icon(Icons.location_on, color: Colors.grey[600], size: 18),
        SizedBox(width: 4),
        Expanded(
          child: Text(
            '${placeModel.city ?? ''}, ${placeModel.country ?? ''}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ),
        if (placeModel.stars != null) ...[
          SizedBox(width: 16),
          Icon(Icons.star, color: Colors.amber, size: 18),
          SizedBox(width: 4),
          Text(
            placeModel.stars!.toStringAsFixed(1),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ],
    );
  }

  Widget _buildPriceSection(PlaceModel placeModel) {
    return Container(
      padding: EdgeInsets.all(16),
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
          SizedBox(width: 8),
          Text(
            'Average Price: ',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            '\$${placeModel.averagePrice}',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
          ),
          Spacer(),
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

  Widget _buildDescriptionSection(PlaceModel placeModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About This Place',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        SizedBox(height: 8),
        Text(
          placeModel.description ??
              'This is a wonderful place to visit with amazing attractions and beautiful scenery. Perfect for tourists looking for an authentic experience.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                height: 1.5,
              ),
        ),
      ],
    );
  }

  Widget _buildPlaceInfoSection(PlaceModel placeModel) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Place Information',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: 12),
          if (placeModel.location != null) _buildInfoRow('Location', placeModel.location!, Icons.location_on),
          if (placeModel.type != null) _buildInfoRow('Category', placeModel.type!, Icons.category),
          _buildInfoRow('Working Hours', '6:00 AM - 8:00 PM', Icons.access_time),
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
          SizedBox(width: 8),
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

  Widget _buildActivitiesSection() {
    return BlocBuilder<GetActivitiesCubit, GetActivitiesState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.local_activity,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Activities & Experiences',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                if (ConstantsModels.activityList != null && ConstantsModels.activityList!.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${ConstantsModels.activityList!.length} available',
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
            if (state is GetActivitiesLoading)
              SizedBox(
                height: 120,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              )
            else if (state is GetActivitiesError)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Failed to load activities',
                        style: TextStyle(color: Colors.red[700]),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (ConstantsModels.placeObject?.id != null) {
                          GetActivitiesCubit.of(context).getActivityByPlaceId(
                            placeId: ConstantsModels.placeObject!.id!,
                          );
                        }
                      },
                      child: Text('Retry'),
                    ),
                  ],
                ),
              )
            else if (ConstantsModels.activityList == null || ConstantsModels.activityList!.isEmpty)
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
                      Icons.local_activity_outlined,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No activities available',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Activities will be added for this place soon',
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
                  children: ConstantsModels.activityList!.map((activity) => PlaceActivityCard(activity: activity)).toList(),
                ),
              ),
          ],
        );
      },
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
        SizedBox(height: 8),
        Container(
          height: 200,
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
                  height: 200,
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
                        // TODO: Open map with place location
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Opening map...')),
                        );
                      },
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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

  Widget _buildNearbyPlacesSection() {
    return BlocBuilder<PlaceCubit, PlaceState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Nearby Places',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Spacer(),
                TextButton(
                  onPressed: () {
                    // TODO: Navigate to all places view
                  },
                  child: Text('View All'),
                ),
              ],
            ),
            SizedBox(height: 8),
            if (state is PlaceSuccess) ...[
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ConstantsModels.placeModel?.take(5).map((place) {
                        return PlaceCard(
                          placeModel: place,
                          isHorizontalScroll: true,
                        );
                      }).toList() ??
                      [],
                ),
              ),
            ] else ...[
              // Placeholder cards
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(3, (index) => PlaceCard()),
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildRestaurantSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Restaurants & Cafes Nearby',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Spacer(),
            TextButton(
              onPressed: () {
                context.navigateToPage(RestaurantCafeViewBody());
              },
              child: Text('View All'),
            ),
          ],
        ),
        SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            separatorBuilder: (context, index) => SizedBox(width: 12),
            itemBuilder: (context, index) {
              return _buildRestaurantCard();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRestaurantCard() {
    return Container(
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            CacheImage(
              imageUrl: 'https://via.placeholder.com/150x200',
              width: 150,
              height: 200,
              boxFit: BoxFit.cover,
              errorColor: Colors.grey[300]!,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
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
                  children: [
                    Text(
                      'Restaurant Name',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 12, color: Colors.white),
                        SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            'Location',
                            style: TextStyle(color: Colors.white, fontSize: 10),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          Icons.star,
                          size: 12,
                          color: index < 4 ? Colors.amber : Colors.grey,
                        );
                      }),
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

  Widget _buildReviewsSection({required int entityId}) {
    return ReviewingSection(
      entityId: entityId,
      entityName: 'place',
    );
  }

  Widget _buildSampleReview(String name, double rating, String date, String text) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 2,
            color: Colors.grey.withOpacity(0.1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CacheImage(
            circle: true,
            imageUrl: 'https://via.placeholder.com/50',
            errorColor: Colors.grey,
            height: 50,
            width: 50,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        SizedBox(width: 4),
                        Text(rating.toString()),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  date,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                SizedBox(height: 8),
                Text(
                  text,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingButtons() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: CustomTextButton(
              onPress: () {
                // TODO: Implement booking functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Booking functionality will be implemented soon!'),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                );
              },
              child: Text(
                'Book Now',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              onPressed: () {
                // TODO: Share functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Share functionality coming soon!')),
                );
              },
              icon: Icon(
                Icons.share,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Professional Activity Card for Place Details
class PlaceActivityCard extends StatelessWidget {
  final ActivityModel activity;

  const PlaceActivityCard({
    super.key,
    required this.activity,
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
        child: InkWell(
          onTap: () {
            // TODO: Navigate to activity details or show booking dialog
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Book activity: ${activity.name}'),
                backgroundColor: Theme.of(context).primaryColor,
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Activity Image
              Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                ),
                child: activity.thumbnailUrl != null
                    ? CacheImage(
                        imageUrl: '${EndPoints.domain}${activity.thumbnailUrl}',
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
                            Icons.local_activity,
                            size: 48,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
              ),

              // Activity Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Activity Name
                    Text(
                      activity.name ?? 'Unknown Activity',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 8),

                    // Activity Description
                    if (activity.description != null && activity.description!.isNotEmpty)
                      Text(
                        activity.description!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                              height: 1.4,
                            ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),

                    const SizedBox(height: 12),

                    // Price and Book Button Row
                    Row(
                      children: [
                        // Price
                        if (activity.price != null)
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.attach_money,
                                    size: 16,
                                    color: Colors.green[700],
                                  ),
                                  Text(
                                    '${activity.price}',
                                    style: TextStyle(
                                      color: Colors.green[700],
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        const SizedBox(width: 8),

                        // Book Button
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Book',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.arrow_forward,
                                size: 14,
                                color: Colors.white,
                              ),
                            ],
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
      ),
    );
  }
}
