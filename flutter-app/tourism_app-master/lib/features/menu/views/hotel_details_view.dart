import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourism_app/core/component/app_bar_sharred.dart';
import 'package:tourism_app/core/component/cache_image.dart';
import 'package:tourism_app/core/network/end_points.dart';
import 'package:tourism_app/core/utils/constants_models.dart';
import 'package:tourism_app/features/home/manager/favorite/cubit/favorite_cubit.dart';
import 'package:tourism_app/features/home/manager/hotel/cubit/hotel_cubit.dart';
import 'package:tourism_app/features/menu/data/models/hotel_model.dart';
import 'package:tourism_app/features/tourguide/presentation/tourguide_details_view.dart';

class HotelDetailsView extends StatefulWidget {
  final int hotelId;

  const HotelDetailsView({
    super.key,
    required this.hotelId,
  });

  @override
  State<HotelDetailsView> createState() => _HotelDetailsViewState();
}

class _HotelDetailsViewState extends State<HotelDetailsView> {
  late bool isFavorited;
  int selectedImageIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    isFavorited = false;
    _pageController = PageController();
    // Fetch hotel details by ID
    HotelCubit.of(context).getHotelById(hotelId: widget.hotelId);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<String> _getImageUrls(HotelModel? hotel) {
    List<String> imageUrls = [];
    if (hotel?.thumbnailUrl != null) {
      imageUrls.add('${EndPoints.domain}${hotel!.thumbnailUrl}');
    }
    if (hotel?.imageUrls != null) {
      imageUrls.addAll(hotel!.imageUrls!.map((url) => '${EndPoints.domain}$url'));
    }

    if (imageUrls.isEmpty) {
      imageUrls = ['https://via.placeholder.com/400x250']; // Fallback image
    }

    // Limit to maximum 10 images
    return imageUrls.take(10).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HotelCubit, HotelState>(
      builder: (context, state) {
        final hotel = ConstantsModels.hotelObject;

        return Scaffold(
          appBar: shareAppBar(
            context,
            nameAppBar: hotel?.name ?? 'Hotel Details',
          ),
          body: _buildBody(state, hotel),
        );
      },
    );
  }

  Widget _buildBody(HotelState state, HotelModel? hotel) {
    if (state is HotelLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state is HotelError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load hotel details',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.red[700],
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              state.e,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                HotelCubit.of(context).getHotelById(hotelId: widget.hotelId);
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (hotel == null) {
      return const Center(
        child: Text('Hotel not found'),
      );
    }

    // Update isFavorited when hotel data is loaded
    isFavorited = hotel.isFavorited ?? false;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Gallery Section
          _buildImageGallery(hotel),

          // Main Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with title and favorite button
                _buildHeader(hotel),
                const SizedBox(height: 16),

                // Location and rating info
                _buildLocationRating(hotel),
                const SizedBox(height: 16),

                // Price information
                if (hotel.startingPrice != null) ...[
                  _buildPriceSection(hotel),
                  const SizedBox(height: 16),
                ],

                // Description Section
                _buildDescriptionSection(hotel),
                const SizedBox(height: 16),

                // Hotel Information
                _buildHotelInfoSection(hotel),
                const SizedBox(height: 16),

                // Rooms Section
                _buildRoomsSection(hotel),
                const SizedBox(height: 16),

                // Map Section (placeholder)
                _buildMapSection(hotel),
                const SizedBox(height: 20),
                ReviewingSection(
                  entityName: 'hotel',
                  entityId: hotel.id?.toInt() ?? -1,
                ),
                const SizedBox(height: 100), // Space for bottom button
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageGallery(HotelModel hotel) {
    List<String> imageUrls = _getImageUrls(hotel);

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

  Widget _buildHeader(HotelModel hotel) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                hotel.name ?? 'Unknown Hotel',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              if (hotel.stars != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    ...List.generate(5, (index) {
                      return Icon(
                        Icons.star,
                        size: 16,
                        color: index < hotel.stars!.toInt() ? Colors.amber : Colors.grey[300],
                      );
                    }),
                    const SizedBox(width: 8),
                    Text(
                      '${hotel.stars!.toStringAsFixed(1)} Stars',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
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
            FavoriteCubit.of(context).toggleFavorite(
              context: context,
              entityId: hotel.id?.toInt() ?? 0,
              entityType: 'hotel',
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

  Widget _buildLocationRating(HotelModel hotel) {
    return Row(
      children: [
        Icon(Icons.location_on, color: Colors.grey[600], size: 18),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            '${hotel.city ?? ''}, ${hotel.country ?? ''}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ),
        if (hotel.stars != null) ...[
          const SizedBox(width: 16),
          Icon(Icons.star, color: Colors.amber, size: 18),
          const SizedBox(width: 4),
          Text(
            hotel.stars!.toStringAsFixed(1),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ],
    );
  }

  Widget _buildPriceSection(HotelModel hotel) {
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
            'Starting from: ',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            '\$${hotel.startingPrice}',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
          ),
          const Spacer(),
          Text(
            'per night',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(HotelModel hotel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About This Hotel',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          hotel.description ??
              'A wonderful hotel with excellent facilities and comfortable accommodations. Perfect for travelers looking for a memorable stay experience.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                height: 1.5,
              ),
        ),
      ],
    );
  }

  Widget _buildHotelInfoSection(HotelModel hotel) {
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
            'Hotel Information',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          if (hotel.location != null) _buildInfoRow('Location', hotel.location!, Icons.location_on),
          if (hotel.stars != null) _buildInfoRow('Rating', '${hotel.stars} Stars', Icons.star),
          _buildInfoRow('Check-in', '2:00 PM', Icons.access_time),
          _buildInfoRow('Check-out', '11:00 AM', Icons.access_time),
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

  Widget _buildRoomsSection(HotelModel hotel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Room Types',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        // Sample room types - you can modify this based on your hotel model
        _buildRoomCard('Standard Room', '\$${hotel.startingPrice ?? 100}', 'Double bed, Wi-Fi, AC'),
        const SizedBox(height: 8),
        _buildRoomCard('Deluxe Room', '\$${(hotel.startingPrice ?? 100) + 50}', 'King bed, Sea view, Balcony'),
        const SizedBox(height: 8),
        _buildRoomCard('Suite', '\$${(hotel.startingPrice ?? 100) + 150}', 'Living area, Kitchenette, Premium amenities'),
      ],
    );
  }

  Widget _buildRoomCard(String roomType, String price, String amenities) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  roomType,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  amenities,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
          ),
          Text(
            '$price/night',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapSection(HotelModel hotel) {
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
