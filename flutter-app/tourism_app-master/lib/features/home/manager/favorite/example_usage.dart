import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourism_app/features/home/manager/favorite/cubit/favorite_cubit.dart';

/// Example usage of the enhanced FavoriteCubit component
/// This file demonstrates how to use the cubit across different entity types and scenarios
class FavoriteCubitExampleUsage {
  /// Example 1: Basic favorite toggle for a place
  static Future<void> togglePlaceFavorite(BuildContext context, int placeId) async {
    await FavoriteCubit.of(context).toggleFavorite(
      context: context,
      entityType: 'place',
      entityId: placeId,
    );
  }

  /// Example 2: Check if a tour guide is favorited
  static bool isTourGuideFavorited(BuildContext context, int tourGuideId) {
    return FavoriteCubit.of(context).isFavorited(
      entityType: 'tourguide',
      entityId: tourGuideId,
    );
  }

  /// Example 3: Add hotel to favorites without auto-refreshing the list
  static Future<void> addHotelToFavorites(BuildContext context, int hotelId) async {
    await FavoriteCubit.of(context).postFavorite(
      context: context,
      entityType: 'hotel',
      entityId: hotelId,
      showToast: true, // Show success/error toast
    );
  }

  /// Example 4: Get all favorite restaurants
  static List getFavoriteRestaurants(BuildContext context) {
    return FavoriteCubit.of(context).favoriteRestaurants;
  }

  /// Example 5: Get total favorites count for user stats
  static int getTotalFavoritesCount(BuildContext context) {
    return FavoriteCubit.of(context).totalFavoritesCount;
  }
}

/// Example Widget: Favorite Button Component
class FavoriteButton extends StatelessWidget {
  final String entityType;
  final int entityId;
  final String? entityName;
  final VoidCallback? onFavoriteChanged;

  const FavoriteButton({
    super.key,
    required this.entityType,
    required this.entityId,
    this.entityName,
    this.onFavoriteChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteCubit, FavoriteState>(
      builder: (context, state) {
        final isFavorited = FavoriteCubit.of(context).isFavorited(
          entityType: entityType,
          entityId: entityId,
        );

        final isLoading = state is FavoritePostLoading;

        return GestureDetector(
          onTap: isLoading
              ? null
              : () async {
                  await FavoriteCubit.of(context).toggleFavorite(
                    context: context,
                    entityType: entityType,
                    entityId: entityId,
                  );
                  onFavoriteChanged?.call();
                },
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isFavorited ? Colors.red.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: isLoading
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(
                    isFavorited ? Icons.favorite : Icons.favorite_border,
                    color: isFavorited ? Colors.red : Colors.grey,
                    size: 20,
                  ),
          ),
        );
      },
    );
  }
}

/// Example Widget: Favorites List Screen
class FavoritesListExample extends StatefulWidget {
  const FavoritesListExample({super.key});

  @override
  _FavoritesListExampleState createState() => _FavoritesListExampleState();
}

class _FavoritesListExampleState extends State<FavoritesListExample> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);

    // Load favorites when screen opens
    Future.microtask(() => FavoriteCubit.of(context).getFavorites(context: context));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Favorites'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            Tab(text: 'Places'),
            Tab(text: 'Hotels'),
            Tab(text: 'Restaurants'),
            Tab(text: 'Tour Guides'),
            Tab(text: 'Plans'),
          ],
        ),
      ),
      body: BlocBuilder<FavoriteCubit, FavoriteState>(
        builder: (context, state) {
          if (state is FavoriteGetLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is FavoriteGetError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error loading favorites: ${state.e}'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => FavoriteCubit.of(context).getFavorites(context: context),
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildFavoritesList('place'),
              _buildFavoritesList('hotel'),
              _buildFavoritesList('restaurant'),
              _buildFavoritesList('tourguide'),
              _buildFavoritesList('plan'),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFavoritesList(String entityType) {
    final favorites = FavoriteCubit.of(context).getFavoritesByType(entityType);

    if (favorites.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No ${entityType}s in favorites yet',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey,
                  ),
            ),
            SizedBox(height: 8),
            Text(
              'Start exploring and add your favorite ${entityType}s!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final favorite = favorites[index];
        return _buildFavoriteCard(favorite, entityType);
      },
    );
  }

  Widget _buildFavoriteCard(favorite, String entityType) {
    String? name;
    int? entityId;

    switch (entityType) {
      case 'place':
        name = favorite.placeName;
        entityId = favorite.placeId;
        break;
      case 'hotel':
        name = favorite.hotelName;
        entityId = favorite.hotelId?.toInt();
        break;
      case 'restaurant':
        name = favorite.restaurantName;
        entityId = favorite.restaurantId?.toInt();
        break;
      case 'tourguide':
        name = favorite.tourGuideName;
        entityId = favorite.tourGuideId?.toInt();
        break;
      case 'plan':
        name = favorite.planName;
        entityId = favorite.planId?.toInt();
        break;
    }

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(_getEntityIcon(entityType)),
        title: Text(name ?? 'Unknown'),
        subtitle: Text('Tap to view details'),
        trailing: entityId != null
            ? FavoriteButton(
                entityType: entityType,
                entityId: entityId,
                onFavoriteChanged: () {
                  // Refresh favorites list after removing
                  FavoriteCubit.of(context).getFavorites(context: context);
                },
              )
            : null,
        onTap: () {
          // Navigate to detail screen
          print('Navigate to $entityType details: $entityId');
        },
      ),
    );
  }

  IconData _getEntityIcon(String entityType) {
    switch (entityType) {
      case 'place':
        return Icons.place;
      case 'hotel':
        return Icons.hotel;
      case 'restaurant':
        return Icons.restaurant;
      case 'tourguide':
        return Icons.person;
      case 'plan':
        return Icons.event;
      default:
        return Icons.favorite;
    }
  }
}

/// Example Widget: Entity Detail Screen with Favorite Button
class EntityDetailScreenExample extends StatelessWidget {
  final String entityType;
  final int entityId;
  final String entityName;

  const EntityDetailScreenExample({
    super.key,
    required this.entityType,
    required this.entityId,
    required this.entityName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(entityName),
        actions: [
          FavoriteButton(
            entityType: entityType,
            entityId: entityId,
            entityName: entityName,
          ),
          SizedBox(width: 16),
        ],
      ),
      body: BlocListener<FavoriteCubit, FavoriteState>(
        listener: (context, state) {
          if (state is FavoritePostSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Favorite updated successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is FavoritePostError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.e}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Text('Entity Details Here...'),
              SizedBox(height: 20),

              // Additional favorite toggle button in the content
              ElevatedButton.icon(
                onPressed: () {
                  FavoriteCubit.of(context).toggleFavorite(
                    context: context,
                    entityType: entityType,
                    entityId: entityId,
                  );
                },
                icon: Icon(Icons.favorite),
                label: Text('Add to Favorites'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Example Widget: Favorites Count Badge
class FavoritesCountBadge extends StatelessWidget {
  const FavoritesCountBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteCubit, FavoriteState>(
      builder: (context, state) {
        final count = FavoriteCubit.of(context).totalFavoritesCount;

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$count',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }
}
