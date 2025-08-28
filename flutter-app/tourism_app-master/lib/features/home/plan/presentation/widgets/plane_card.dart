import 'package:flutter/material.dart';
import 'package:tourism_app/core/component/cache_image.dart';
import 'package:tourism_app/core/network/end_points.dart';
import 'package:tourism_app/core/utils/navigate.dart';
import 'package:tourism_app/features/home/data/models/plane_model.dart';
import 'package:tourism_app/features/home/plan/presentation/plan_details_view.dart';

class PlanCardHorizontal extends StatelessWidget {
  final PlanModel? planModel;
  final bool isHorizontalScroll;

  const PlanCardHorizontal({
    super.key,
    this.planModel,
    this.isHorizontalScroll = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (planModel != null) {
          context.navigateToPage(PlanDetailsView(planModel: planModel!));
        }
      },
      child: Padding(
        padding: isHorizontalScroll ? const EdgeInsets.only(right: 10) : EdgeInsets.zero,
        child: Stack(
          children: [
            CacheImage(
              height: 170,
              width: isHorizontalScroll ? 300 : double.infinity,
              imageUrl: ' ${EndPoints.domain}${planModel?.thumbnailUrl ?? ''}',
              errorColor: Colors.grey,
            ),
            Positioned(
              bottom: 10,
              left: 10,
              right: 10, // Added to constrain the width
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    planModel?.name ?? 'Egypt Through The Ages',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 4), // Added spacing
                  Row(
                    mainAxisSize: MainAxisSize.min, // Prevents excessive space between items
                    children: [
                      // Day Plan icon and text
                      Icon(
                        Icons.calendar_today,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${planModel?.days ?? 1}-Day Plan',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white),
                      ),
                      const SizedBox(width: 10), // Space between Day Plan and Tour Guide
                      // Tour Guide icon and text
                      Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        planModel?.tourGuideName ?? 'Tour Guide',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8), // Added space between row and description
                  // Description Text with max 3 lines
                  Text(
                    planModel?.description ??
                        'Explore Egypt through its most iconic historical sites with a professional guide. Perfect for a one-day adventure!',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white.withOpacity(0.7)),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis, // Truncate text if it exceeds 3 lines
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
