import 'package:flutter/material.dart';
import 'package:tourism_app/core/component/review_dialog.dart';

/// Example usage of the reusable ReviewDialog component
/// This file demonstrates how to use the dialog across different entity types
class ReviewDialogExampleUsage {
  /// Example: Using in Tour Guide Details Screen
  static void showTourGuideReview(BuildContext context, int tourGuideId, String tourGuideName) {
    ReviewDialog.show(
      context: context,
      entityName: 'tourguide',
      entityId: tourGuideId,
      entityTitle: tourGuideName,
      onReviewSubmitted: () {
        // Optional callback when review is successfully submitted
        print('Tour guide review submitted successfully!');
        // You can add any additional logic here like refreshing data
      },
    );
  }

  /// Example: Using in Place Details Screen
  static void showPlaceReview(BuildContext context, int placeId, String placeName) {
    ReviewDialog.show(
      context: context,
      entityName: 'place',
      entityId: placeId,
      entityTitle: placeName,
      onReviewSubmitted: () {
        // Optional callback for place reviews
        print('Place review submitted successfully!');
      },
    );
  }

  /// Example: Using in Hotel Details Screen
  static void showHotelReview(BuildContext context, int hotelId, String hotelName) {
    ReviewDialog.show(
      context: context,
      entityName: 'hotel',
      entityId: hotelId,
      entityTitle: hotelName,
      onReviewSubmitted: () {
        // Optional callback for hotel reviews
        print('Hotel review submitted successfully!');
      },
    );
  }

  /// Example: Using in Restaurant Details Screen
  static void showRestaurantReview(BuildContext context, int restaurantId, String restaurantName) {
    ReviewDialog.show(
      context: context,
      entityName: 'restaurant',
      entityId: restaurantId,
      entityTitle: restaurantName,
      onReviewSubmitted: () {
        // Optional callback for restaurant reviews
        print('Restaurant review submitted successfully!');
      },
    );
  }

  /// Example: Using in Plan Details Screen
  static void showPlanReview(BuildContext context, int planId, String planName) {
    ReviewDialog.show(
      context: context,
      entityName: 'plan',
      entityId: planId,
      entityTitle: planName,
      onReviewSubmitted: () {
        // Optional callback for plan reviews
        print('Plan review submitted successfully!');
      },
    );
  }

  /// Example: Simple usage without title or callback
  static void showSimpleReview(BuildContext context, String entityType, int entityId) {
    ReviewDialog.show(
      context: context,
      entityName: entityType,
      entityId: entityId,
      // No title or callback - minimal usage
    );
  }
}

/// Example Widget showing how to integrate the dialog in a screen
class ExampleScreenWithReviewButton extends StatelessWidget {
  final int entityId;
  final String entityName;
  final String entityTitle;

  const ExampleScreenWithReviewButton({
    super.key,
    required this.entityId,
    required this.entityName,
    required this.entityTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(entityTitle)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Entity Details Here...'),
            SizedBox(height: 20),

            // Example 1: Elevated Button
            ElevatedButton.icon(
              onPressed: () => ReviewDialog.show(
                context: context,
                entityName: entityName,
                entityId: entityId,
                entityTitle: entityTitle,
              ),
              icon: Icon(Icons.rate_review),
              label: Text('Write Review'),
            ),

            SizedBox(height: 16),

            // Example 2: Icon Button with custom styling
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                onPressed: () => ReviewDialog.show(
                  context: context,
                  entityName: entityName,
                  entityId: entityId,
                  entityTitle: entityTitle,
                  onReviewSubmitted: () {
                    // Custom callback
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Thank you for your review!')),
                    );
                  },
                ),
                icon: Icon(Icons.add_comment, color: Colors.white),
                tooltip: 'Add Review',
              ),
            ),

            SizedBox(height: 16),

            // Example 3: Text button in a card
            Card(
              child: ListTile(
                leading: Icon(Icons.star_border),
                title: Text('Rate this $entityName'),
                subtitle: Text('Share your experience'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () => ReviewDialog.show(
                  context: context,
                  entityName: entityName,
                  entityId: entityId,
                  entityTitle: entityTitle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Example: How to use in existing review sections
class ReviewSectionWithDialog extends StatelessWidget {
  final String entityName;
  final int entityId;
  final String entityTitle;

  const ReviewSectionWithDialog({
    super.key,
    required this.entityName,
    required this.entityId,
    required this.entityTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header with Add Review Button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Reviews',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            GestureDetector(
              onTap: () => ReviewDialog.show(
                context: context,
                entityName: entityName,
                entityId: entityId,
                entityTitle: entityTitle,
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'Add Review',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 12),

        // Reviews list would go here
        Text('Reviews list...'),
      ],
    );
  }
}
