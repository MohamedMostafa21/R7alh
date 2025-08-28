import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourism_app/core/component/app_bar_sharred.dart';
import 'package:tourism_app/core/component/cache_image.dart';
import 'package:tourism_app/core/network/end_points.dart';
import 'package:tourism_app/core/utils/constants_models.dart';
import 'package:tourism_app/core/utils/navigate.dart';
import 'package:tourism_app/features/home/manager/hotel/cubit/hotel_cubit.dart';
import 'package:tourism_app/features/home/manager/favorite/cubit/favorite_cubit.dart';
import 'package:tourism_app/features/menu/data/models/hotel_model.dart';
import 'package:tourism_app/features/menu/views/hotel_details_view.dart';

class HotelsView extends StatefulWidget {
  const HotelsView({super.key});

  @override
  State<HotelsView> createState() => _HotelsViewState();
}

class _HotelsViewState extends State<HotelsView> {
  @override
  void initState() {
    super.initState();
    // Load hotels when the view initializes
    HotelCubit.of(context).getHotels(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: shareAppBar(
        context,
        nameAppBar: 'Hotels',
      ),
      body: BlocBuilder<HotelCubit, HotelState>(
        builder: (context, state) {
          if (state is HotelLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is HotelError) {
            return _buildErrorState(state.e);
          } else if (state is HotelSuccess) {
            return _buildHotelsGrid();
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
                HotelCubit.of(context).getHotels(context: context);
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
              Icons.hotel_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No Hotels Available',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Hotels will be available soon',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[500],
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHotelsGrid() {
    List<HotelModel> hotels = ConstantsModels.hotelModel ?? [];

    if (hotels.isEmpty) {
      return _buildEmptyState();
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 1.5,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: hotels.length,
        itemBuilder: (context, index) {
          return HotelCard(hotel: hotels[index]);
        },
      ),
    );
  }
}

class HotelCard extends StatefulWidget {
  final HotelModel hotel;

  const HotelCard({
    super.key,
    required this.hotel,
  });

  @override
  State<HotelCard> createState() => _HotelCardState();
}

class _HotelCardState extends State<HotelCard> {
  late bool isFavorited;

  @override
  void initState() {
    super.initState();
    isFavorited = widget.hotel.isFavorited ?? false;
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
          context.navigateToPage(HotelDetailsView(hotelId: widget.hotel.id?.toInt() ?? -1));
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              // Hotel Image
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: widget.hotel.thumbnailUrl != null
                      ? CacheImage(
                          imageUrl: '${EndPoints.domain}${widget.hotel.thumbnailUrl}',
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
                              Icons.hotel,
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
                      entityId: widget.hotel.id?.toInt() ?? 0,
                      entityType: 'hotel',
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

              // Hotel Information
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
                      // Hotel Name
                      Text(
                        widget.hotel.name ?? 'Unknown Hotel',
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
                              '${widget.hotel.city ?? ''}, ${widget.hotel.country ?? ''}',
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
                          if (widget.hotel.stars != null) ...[
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  widget.hotel.stars!.toStringAsFixed(1),
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

                          // Price
                          if (widget.hotel.startingPrice != null) ...[
                            Text(
                              'From \$${widget.hotel.startingPrice}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              '/night',
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
