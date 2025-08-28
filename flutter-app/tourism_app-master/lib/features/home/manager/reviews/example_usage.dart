// This is an example file showing how to use the ReviewsCubit
// You can copy this code to integrate reviews into your existing widgets

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourism_app/features/home/manager/reviews/cubit/reviews_cubit.dart';
import 'package:tourism_app/features/home/data/models/review_model.dart';

class ReviewsExampleWidget extends StatefulWidget {
  final String entityName; // 'place', 'tourguide', 'hotel', 'restaurant', 'plan'
  final int entityId; // The ID of the entity

  const ReviewsExampleWidget({
    super.key,
    required this.entityName,
    required this.entityId,
  });

  @override
  State<ReviewsExampleWidget> createState() => _ReviewsExampleWidgetState();
}

class _ReviewsExampleWidgetState extends State<ReviewsExampleWidget> {
  @override
  void initState() {
    super.initState();
    // Load reviews when widget initializes
    ReviewsCubit.of(context).getReviews(
      context: context,
      entityName: widget.entityName,
      entityId: widget.entityId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reviews Example')),
      body: BlocBuilder<ReviewsCubit, ReviewsState>(
        builder: (context, state) {
          if (state is ReviewsLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ReviewsGetError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.e}'),
                  ElevatedButton(
                    onPressed: () {
                      ReviewsCubit.of(context).getReviews(
                        context: context,
                        entityName: widget.entityName,
                        entityId: widget.entityId,
                      );
                    },
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is ReviewsGetSuccess) {
            final reviews = state.reviews;
            return Column(
              children: [
                // Reviews Summary
                Container(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Text(
                        'Reviews (${ReviewsCubit.of(context).totalReviewsCount})',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Spacer(),
                      Text(
                        'Avg: ${ReviewsCubit.of(context).averageRating.toStringAsFixed(1)} ⭐',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),

                // Add Review Button
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton(
                    onPressed: () => _showCreateReviewDialog(context),
                    child: Text('Add Review'),
                  ),
                ),

                // Reviews List
                Expanded(
                  child: ListView.builder(
                    itemCount: reviews.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      final review = reviews.data![index];
                      return _ReviewItem(review: review);
                    },
                  ),
                ),
              ],
            );
          }

          return Center(child: Text('No reviews yet'));
        },
      ),
    );
  }

  void _showCreateReviewDialog(BuildContext context) {
    final ratingController = TextEditingController();
    final commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Add Review'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: ratingController,
              decoration: InputDecoration(
                labelText: 'Rating (1-5)',
                hintText: 'Enter rating from 1 to 5',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            TextField(
              controller: commentController,
              decoration: InputDecoration(
                labelText: 'Comment',
                hintText: 'Write your review...',
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Cancel'),
          ),
          BlocListener<ReviewsCubit, ReviewsState>(
            listener: (context, state) {
              if (state is ReviewsCreateSuccess) {
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Review added successfully!')),
                );
              } else if (state is ReviewsCreateError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${state.e}')),
                );
              }
            },
            child: BlocBuilder<ReviewsCubit, ReviewsState>(
              builder: (context, state) {
                if (state is ReviewsCreateLoading) {
                  return CircularProgressIndicator();
                }
                return ElevatedButton(
                  onPressed: () {
                    final rating = int.tryParse(ratingController.text);
                    final comment = commentController.text.trim();

                    if (rating != null && rating >= 1 && rating <= 5 && comment.isNotEmpty) {
                      ReviewsCubit.of(context).createReview(
                        context: context,
                        entityName: widget.entityName,
                        entityId: widget.entityId,
                        rate: rating,
                        comment: comment,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please provide valid rating (1-5) and comment')),
                      );
                    }
                  },
                  child: Text('Submit'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewItem extends StatelessWidget {
  final ReviewData review;

  const _ReviewItem({required this.review});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  review.userName ?? 'Anonymous',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Spacer(),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    Text('${review.rating ?? 0}'),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              review.comment ?? '',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 8),
            Text(
              review.createdAt ?? '',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

/* 
USAGE EXAMPLES:

1. For a place:
ReviewsExampleWidget(entityName: 'place', entityId: placeId)

2. For a tour guide:
ReviewsExampleWidget(entityName: 'tourguide', entityId: tourGuideId)

3. For a hotel:
ReviewsExampleWidget(entityName: 'hotel', entityId: hotelId)

4. For a restaurant:
ReviewsExampleWidget(entityName: 'restaurant', entityId: restaurantId)

5. For a plan:
ReviewsExampleWidget(entityName: 'plan', entityId: planId)

CUBIT METHODS:

1. Get Reviews:
ReviewsCubit.of(context).getReviews(
  context: context,
  entityName: 'place', // or 'tourguide', 'hotel', 'restaurant', 'plan'
  entityId: 123,
);

2. Create Review:
ReviewsCubit.of(context).createReview(
  context: context,
  entityName: 'place',
  entityId: 123,
  rate: 5,
  comment: 'Great place to visit!',
);

3. Access helper methods:
- ReviewsCubit.of(context).totalReviewsCount
- ReviewsCubit.of(context).averageRating
- ReviewsCubit.of(context).hasMorePages
- ReviewsCubit.of(context).clearReviews()

*/
