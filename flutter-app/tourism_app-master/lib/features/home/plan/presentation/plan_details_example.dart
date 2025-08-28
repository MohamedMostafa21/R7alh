import 'package:flutter/material.dart';
import 'package:tourism_app/features/home/data/models/plane_model.dart';
import 'package:tourism_app/features/home/plan/presentation/plan_details_view.dart';

/// Example usage of the updated PlanDetailsView
/// This file demonstrates how to use the plan details screen with real data
class PlanDetailsExampleUsage {
  /// Example 1: Navigate to plan details with a plan model
  static void navigateToPlanDetails(BuildContext context, PlanModel planModel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlanDetailsView(planModel: planModel),
      ),
    );
  }

  /// Example 2: Create a sample plan model for testing
  static PlanModel createSamplePlan() {
    return PlanModel(
      id: 1,
      name: 'Cairo Historical Tour',
      description: 'Discover the wonders of ancient Egyptian civilization with an exciting day trip through Cairo\'s most iconic historical sites.',
      price: 120,
      days: 1,
      tourGuideId: 1,
      tourGuideName: 'Ahmed Hassan',
      thumbnailUrl: '/images/cairo-tour.jpg',
      planPlaces: [
        PlanPlaces(
          id: 1,
          planId: 1,
          placeId: 1,
          placeName: 'The Great Pyramid of Giza',
          thumbnailUrl: '/images/pyramid.jpg',
          order: 1,
          duration: '2 hours',
          additionalDescription: 'Marvel at the last standing wonder of the ancient world.',
          specialPrice: 25,
        ),
        PlanPlaces(
          id: 2,
          planId: 1,
          placeId: 2,
          placeName: 'The Sphinx',
          thumbnailUrl: '/images/sphinx.jpg',
          order: 2,
          duration: '1 hour',
          additionalDescription: 'Explore the mysterious guardian of the pyramids.',
          specialPrice: 15,
        ),
        PlanPlaces(
          id: 3,
          planId: 1,
          placeId: 3,
          placeName: 'Egyptian Museum',
          thumbnailUrl: '/images/museum.jpg',
          order: 3,
          duration: '3 hours',
          additionalDescription: 'Discover the treasures of ancient Egypt including Tutankhamun\'s artifacts.',
          specialPrice: 30,
        ),
      ],
    );
  }

  /// Example 3: Create a multi-day plan
  static PlanModel createMultiDayPlan() {
    return PlanModel(
      id: 2,
      name: 'Egypt Heritage Adventure',
      description: 'A comprehensive 3-day journey through Egypt\'s most significant historical and cultural sites.',
      price: 450,
      days: 3,
      tourGuideId: 2,
      tourGuideName: 'Fatima Al-Zahra',
      thumbnailUrl: '/images/egypt-heritage.jpg',
      planPlaces: [
        PlanPlaces(
          id: 4,
          planId: 2,
          placeId: 1,
          placeName: 'Pyramids of Giza',
          thumbnailUrl: '/images/giza.jpg',
          order: 1,
          duration: 'Half Day',
          additionalDescription: 'Day 1: Explore the iconic pyramids and sphinx.',
        ),
        PlanPlaces(
          id: 5,
          planId: 2,
          placeId: 4,
          placeName: 'Karnak Temple',
          thumbnailUrl: '/images/karnak.jpg',
          order: 2,
          duration: 'Full Day',
          additionalDescription: 'Day 2: Visit the magnificent temple complex in Luxor.',
        ),
        PlanPlaces(
          id: 6,
          planId: 2,
          placeId: 5,
          placeName: 'Valley of the Kings',
          thumbnailUrl: '/images/valley-kings.jpg',
          order: 3,
          duration: 'Half Day',
          additionalDescription: 'Day 3: Discover the royal tombs of ancient pharaohs.',
        ),
      ],
    );
  }
}

/// Example Widget: Plan Details Button
class PlanDetailsButton extends StatelessWidget {
  final PlanModel planModel;
  final String buttonText;

  const PlanDetailsButton({
    super.key,
    required this.planModel,
    this.buttonText = 'View Details',
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlanDetailsView(planModel: planModel),
          ),
        );
      },
      child: Text(buttonText),
    );
  }
}

/// Example Widget: Plan Preview Card that navigates to details
class PlanPreviewCard extends StatelessWidget {
  final PlanModel planModel;

  const PlanPreviewCard({
    super.key,
    required this.planModel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlanDetailsView(planModel: planModel),
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                planModel.name ?? 'Unknown Plan',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: 8),
              Text(
                planModel.description ?? 'No description available',
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.schedule, size: 16, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(
                    '${planModel.days ?? 1} day${(planModel.days ?? 1) > 1 ? 's' : ''}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  SizedBox(width: 16),
                  Icon(Icons.attach_money, size: 16, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(
                    '\$${planModel.price ?? 0}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Spacer(),
                  if (planModel.planPlaces != null)
                    Text(
                      '${planModel.planPlaces!.length} places',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Example: Demo screen showing plan details functionality
class PlanDetailsDemoScreen extends StatelessWidget {
  const PlanDetailsDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final samplePlan = PlanDetailsExampleUsage.createSamplePlan();
    final multiDayPlan = PlanDetailsExampleUsage.createMultiDayPlan();

    return Scaffold(
      appBar: AppBar(
        title: Text('Plan Details Demo'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Plan Details Examples',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: 16),
            Text(
              'Single Day Plan:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 8),
            PlanPreviewCard(planModel: samplePlan),
            SizedBox(height: 24),
            Text(
              'Multi-Day Plan:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 8),
            PlanPreviewCard(planModel: multiDayPlan),
            SizedBox(height: 24),
            Text(
              'Direct Navigation:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: PlanDetailsButton(
                    planModel: samplePlan,
                    buttonText: 'View Cairo Tour',
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: PlanDetailsButton(
                    planModel: multiDayPlan,
                    buttonText: 'View Heritage Tour',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
