import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourism_app/core/component/app_bar_sharred.dart';
import 'package:tourism_app/core/utils/navigate.dart';
import 'package:tourism_app/features/booking/views/my_booking_view.dart';
import 'package:tourism_app/features/home/manager/favorite/cubit/favorite_cubit.dart';
import 'package:tourism_app/features/home/restaurant/presentation/restaurants_view_body.dart';
import 'package:tourism_app/features/home/hotelse/presentation/hotels_view_body.dart';
import 'package:tourism_app/features/menu/views/apply_as_guide_view.dart';
import 'package:tourism_app/features/menu/views/hotels_view.dart';
import 'package:tourism_app/features/menu/views/restaurants_view.dart';

class MenuView extends StatelessWidget {
  const MenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: shareAppBar(hideBack: true, context, nameAppBar: 'Menu'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.person,
                      color: Theme.of(context).primaryColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome Back!',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[800],
                              ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Manage your travel experience',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Section Title
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 12),
              child: Text(
                'Quick Actions',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
              ),
            ),

            // Menu Items Container
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                children: [
                  _buildMenuItem(
                    context,
                    icon: Icons.book_online_outlined,
                    title: 'My Bookings',
                    subtitle: 'View your bookings and trips',
                    onTap: () {
                      context.navigateToPage(MyBookingView());
                    },
                  ),
                  _buildDivider(),
                  // BlocBuilder<FavoriteCubit, FavoriteState>(
                  //   builder: (context, state) {
                  //     final favoriteCount = FavoriteCubit.of(context).totalFavoritesCount;
                  //     return _buildMenuItem(
                  //       context,
                  //       icon: Icons.favorite_outline,
                  //       title: 'My Favorites',
                  //       subtitle: '$favoriteCount saved items',
                  //       onTap: () {
                  //         _showFavoritesDialog(context);
                  //       },
                  //     );
                  //   },
                  // ),
                  // _buildDivider(),
                  _buildMenuItem(
                    context,
                    icon: Icons.restaurant_outlined,
                    title: 'Restaurants',
                    subtitle: 'Discover local dining',
                    onTap: () {
                      context.navigateToPage(RestaurantsView());
                    },
                  ),
                  _buildDivider(),
                  _buildMenuItem(
                    context,
                    icon: Icons.hotel_outlined,
                    title: 'Hotels',
                    subtitle: 'Find perfect accommodations',
                    onTap: () {
                      context.navigateToPage(HotelsView());
                    },
                  ),
                  _buildDivider(),
                  _buildMenuItem(
                    context,
                    icon: Icons.person_add_outlined,
                    title: 'Apply as Tour Guide',
                    subtitle: 'Join our guide community',
                    onTap: () {
                      context.navigateToPage(ApplyAsGuideView());
                    },
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      indent: 56,
      endIndent: 20,
      color: Colors.grey[200],
    );
  }

  void _showFavoritesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'My Favorites',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        content: BlocBuilder<FavoriteCubit, FavoriteState>(
          builder: (context, state) {
            final favoriteCubit = FavoriteCubit.of(context);
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildFavoriteRow('Places', favoriteCubit.favoritePlaces.length, Icons.place_outlined),
                _buildFavoriteRow('Hotels', favoriteCubit.favoriteHotels.length, Icons.hotel_outlined),
                _buildFavoriteRow('Restaurants', favoriteCubit.favoriteRestaurants.length, Icons.restaurant_outlined),
                _buildFavoriteRow('Tour Guides', favoriteCubit.favoriteTourGuides.length, Icons.person_outline),
                _buildFavoriteRow('Plans', favoriteCubit.favoritePlans.length, Icons.event_outlined),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).primaryColor,
            ),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteRow(String title, int count, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              count.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showApplyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Apply as Tour Guide',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        content: const Text(
          'Would you like to apply to become a tour guide? We\'ll send you more information.',
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Application submitted! We\'ll contact you soon.'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}
