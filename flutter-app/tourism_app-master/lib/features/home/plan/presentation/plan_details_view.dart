import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourism_app/core/component/buttons/custom_text_button.dart';
import 'package:tourism_app/core/component/cache_image.dart';
import 'package:tourism_app/core/component/review_dialog.dart';
import 'package:tourism_app/core/network/end_points.dart';
import 'package:tourism_app/core/utils/app_icons.dart';
import 'package:tourism_app/core/utils/constants_models.dart';
import 'package:tourism_app/features/home/data/models/plane_model.dart';
import 'package:tourism_app/features/home/data/models/place_mode.dart';
import 'package:tourism_app/features/home/data/models/activity_model.dart';
import 'package:tourism_app/features/home/plan/presentation/widgets/plan_gallery.dart';
import 'package:tourism_app/features/home/presentation/home_view.dart';
import 'package:tourism_app/features/tourguide/presentation/tourguide_details_view.dart';

class PlanDetailsView extends StatelessWidget {
  final PlanModel planModel;

  const PlanDetailsView({
    super.key,
    required this.planModel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: [
        CustomTextButton(
          width: MediaQuery.sizeOf(context).width,
          borderRadius: 8,
          onPress: () {},
          child: Text(
            'Book Now - \$${planModel.price ?? 0}',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),
          ),
        ),
      ],
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text(planModel.name ?? 'Plan Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: CacheImage(
                imageUrl: '${EndPoints.domain} ${planModel.thumbnailUrl ?? ''}',
                height: 200,
                width: double.infinity,
                errorColor: Colors.grey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    planModel.name ?? 'Unknown Plan',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.schedule, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text('${planModel.days ?? 1} day${(planModel.days ?? 1) > 1 ? 's' : ''}'),
                      const SizedBox(width: 16),
                      Icon(Icons.attach_money, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text('\$${planModel.price ?? 0}'),
                      if (planModel.tourGuideName != null) ...[
                        const SizedBox(width: 16),
                        Icon(Icons.person, color: Colors.grey),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            planModel.tourGuideName!,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (planModel.description != null && planModel.description!.isNotEmpty) ...[
                    Text(
                      'Description',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      planModel.description!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (planModel.planPlaces != null && planModel.planPlaces!.isNotEmpty) ...[
                    Row(
                      children: [
                        Text(
                          'Plan Places (${planModel.planPlaces!.length})',
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Text(
                          'Visit Order',
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    PlanPlacesSection(planPlaces: planModel.planPlaces!),
                    const SizedBox(height: 24),
                  ],

                  // // Activities Section
                  // if (planModel.planPlaces != null && planModel.planPlaces!.isNotEmpty) ...[
                  //   ActivitiesSection(planPlaces: planModel.planPlaces!),
                  //   const SizedBox(height: 24),
                  // ],

                  ReviewingSection(
                    entityName: 'plan',
                    entityId: planModel.id?.toInt() ?? -1,
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlanPlacesSection extends StatelessWidget {
  final List<PlanPlaces> planPlaces;

  const PlanPlacesSection({
    super.key,
    required this.planPlaces,
  });

  @override
  Widget build(BuildContext context) {
    // Sort places by order
    final sortedPlaces = List<PlanPlaces>.from(planPlaces);
    sortedPlaces.sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0));

    return Column(
      children: [
        // Places Grid (2 columns)
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.75,
          ),
          itemCount: sortedPlaces.length,
          itemBuilder: (context, index) {
            final planPlace = sortedPlaces[index];
            return PlanPlaceCard(
              planPlace: planPlace,
              orderNumber: index + 1,
            );
          },
        ),

        // Expandable Details List
        const SizedBox(height: 16),
        ExpansionTile(
          title: Text(
            'Detailed Itinerary',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
          ),
          children: sortedPlaces.map((planPlace) {
            return PlanPlaceDetailTile(planPlace: planPlace);
          }).toList(),
        ),
      ],
    );
  }
}

class PlanPlaceCard extends StatelessWidget {
  final PlanPlaces planPlace;
  final int orderNumber;

  const PlanPlaceCard({
    super.key,
    required this.planPlace,
    required this.orderNumber,
  });

  @override
  Widget build(BuildContext context) {
    // Convert PlanPlaces to PlaceModel for PlaceCard compatibility
    final placeModel = PlaceModel(
      id: planPlace.placeId?.toInt(),
      name: planPlace.placeName,
      thumbnailUrl: planPlace.thumbnailUrl,
    );

    return Stack(
      children: [
        PlaceCard(
          placeModel: placeModel,
          isHorizontalScroll: false,
        ),
        // Order number badge
        Positioned(
          top: 8,
          left: 8,
          child: Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$orderNumber',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        // Duration badge (if available)
        if (planPlace.duration != null && planPlace.duration!.isNotEmpty)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                planPlace.duration!,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class PlanPlaceDetailTile extends StatelessWidget {
  final PlanPlaces planPlace;

  const PlanPlaceDetailTile({
    super.key,
    required this.planPlace,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Order indicator
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${planPlace.order ?? 0}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      planPlace.placeName ?? 'Unknown Place',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    if (planPlace.duration != null)
                      Text(
                        'Duration: ${planPlace.duration}',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                  ],
                ),
              ),
              if (planPlace.specialPrice != null)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '\$${planPlace.specialPrice}',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          if (planPlace.additionalDescription != null && planPlace.additionalDescription!.isNotEmpty) ...[
            SizedBox(height: 8),
            Text(
              planPlace.additionalDescription!,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }
}

class ReviewCard extends StatelessWidget {
  final String reviewerName;
  final double rating;
  final String date;
  final String reviewText;
  final String imageUrl;

  const ReviewCard({
    super.key,
    required this.reviewerName,
    required this.rating,
    required this.date,
    required this.reviewText,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black.withOpacity(0.05)),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 2,
            color: Colors.grey.withOpacity(0.1),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CacheImage(
              circle: true,
              imageUrl: imageUrl,
              errorColor: Colors.grey,
              height: 50,
              width: 50,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        reviewerName,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.yellow[700], size: 16),
                          const SizedBox(width: 4),
                          Text(rating.toString()),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    reviewText,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Activities Section Widget
// class ActivitiesSection extends StatefulWidget {
//   final List<PlanPlaces> planPlaces;

//   const ActivitiesSection({
//     super.key,
//     required this.planPlaces,
//   });

//   @override
//   State<ActivitiesSection> createState() => _ActivitiesSectionState();
// }

// class _ActivitiesSectionState extends State<ActivitiesSection> {
//   final Set<int> _loadedPlaceIds = {};
//   bool _isExpanded = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadActivitiesForAllPlaces();
//   }

//   void _loadActivitiesForAllPlaces() {
//     for (final planPlace in widget.planPlaces) {
//       if (planPlace.placeId != null && !_loadedPlaceIds.contains(planPlace.placeId!.toInt())) {
//         _loadedPlaceIds.add(planPlace.placeId!.toInt());
//         GetActivitiesCubit.of(context).getActivityByPlaceId(placeId: planPlace.placeId!.toInt());
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<GetActivitiesCubit, GetActivitiesState>(
//       builder: (context, state) {
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Icon(
//                   Icons.local_activity,
//                   color: Theme.of(context).primaryColor,
//                   size: 24,
//                 ),
//                 const SizedBox(width: 8),
//                 Text(
//                   'Activities & Experiences',
//                   style: Theme.of(context).textTheme.bodyLarge!.copyWith(
//                         fontWeight: FontWeight.bold,
//                       ),
//                 ),
//                 const Spacer(),
//                 if (ConstantsModels.activityList != null && ConstantsModels.activityList!.isNotEmpty)
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: Theme.of(context).primaryColor.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Text(
//                       '${ConstantsModels.activityList!.length} available',
//                       style: TextStyle(
//                         color: Theme.of(context).primaryColor,
//                         fontSize: 12,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             if (state is GetActivitiesLoading)
//               Container(
//                 height: 120,
//                 child: Center(
//                   child: CircularProgressIndicator(
//                     color: Theme.of(context).primaryColor,
//                   ),
//                 ),
//               )
//             else if (state is GetActivitiesError)
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.red.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: Colors.red.withOpacity(0.3)),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(Icons.error_outline, color: Colors.red, size: 20),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: Text(
//                         'Failed to load activities',
//                         style: TextStyle(color: Colors.red[700]),
//                       ),
//                     ),
//                     TextButton(
//                       onPressed: _loadActivitiesForAllPlaces,
//                       child: Text('Retry'),
//                     ),
//                   ],
//                 ),
//               )
//             else if (ConstantsModels.activityList == null || ConstantsModels.activityList!.isEmpty)
//               Container(
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: Colors.grey[50],
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: Colors.grey[200]!),
//                 ),
//                 child: Column(
//                   children: [
//                     Icon(
//                       Icons.local_activity_outlined,
//                       size: 48,
//                       color: Colors.grey[400],
//                     ),
//                     const SizedBox(height: 12),
//                     Text(
//                       'No activities available',
//                       style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                             color: Colors.grey[600],
//                             fontWeight: FontWeight.w500,
//                           ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       'Activities will be added for this plan soon',
//                       style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                             color: Colors.grey[500],
//                           ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ],
//                 ),
//               )
//             else
//               Column(
//                 children: [
//                   // Show first 2 activities by default
//                   ...ConstantsModels.activityList!
//                       .take(_isExpanded ? ConstantsModels.activityList!.length : 2)
//                       .map((activity) => ActivityCard(activity: activity))
//                       .toList(),

//                   // Show more button if there are more than 2 activities
//                   if (ConstantsModels.activityList!.length > 2)
//                     Padding(
//                       padding: const EdgeInsets.only(top: 12),
//                       child: InkWell(
//                         onTap: () {
//                           setState(() {
//                             _isExpanded = !_isExpanded;
//                           });
//                         },
//                         borderRadius: BorderRadius.circular(8),
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//                           decoration: BoxDecoration(
//                             border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.3)),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 _isExpanded ? 'Show Less' : 'Show ${ConstantsModels.activityList!.length - 2} More Activities',
//                                 style: TextStyle(
//                                   color: Theme.of(context).primaryColor,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                               const SizedBox(width: 4),
//                               Icon(
//                                 _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
//                                 color: Theme.of(context).primaryColor,
//                                 size: 20,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//           ],
//         );
//       },
//     );
//   }
// }

// // Professional Activity Card Widget
// class ActivityCard extends StatelessWidget {
//   final ActivityModel activity;

//   const ActivityCard({
//     super.key,
//     required this.activity,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.08),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//         border: Border.all(color: Colors.grey[100]!),
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(16),
//         child: InkWell(
//           onTap: () {
//             // TODO: Navigate to activity details or show more info
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text('Activity details for ${activity.name}'),
//                 backgroundColor: Theme.of(context).primaryColor,
//               ),
//             );
//           },
//           child: Row(
//             children: [
//               // Activity Image
//               Container(
//                 width: 100,
//                 height: 100,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[200],
//                 ),
//                 child: activity.thumbnailUrl != null
//                     ? CacheImage(
//                         imageUrl: '${EndPoints.domain}${activity.thumbnailUrl}',
//                         width: 100,
//                         height: 100,
//                         boxFit: BoxFit.cover,
//                         borderRadius: 0,
//                         errorColor: Colors.grey[300]!,
//                       )
//                     : Container(
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             begin: Alignment.topLeft,
//                             end: Alignment.bottomRight,
//                             colors: [
//                               Theme.of(context).primaryColor.withOpacity(0.3),
//                               Theme.of(context).primaryColor.withOpacity(0.1),
//                             ],
//                           ),
//                         ),
//                         child: Icon(
//                           Icons.local_activity,
//                           size: 32,
//                           color: Theme.of(context).primaryColor,
//                         ),
//                       ),
//               ),

//               // Activity Details
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Activity Name
//                       Text(
//                         activity.name ?? 'Unknown Activity',
//                         style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                               fontWeight: FontWeight.w600,
//                               color: Colors.grey[800],
//                             ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),

//                       const SizedBox(height: 6),

//                       // Activity Description
//                       if (activity.description != null && activity.description!.isNotEmpty)
//                         Text(
//                           activity.description!,
//                           style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                                 color: Colors.grey[600],
//                                 height: 1.3,
//                               ),
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                         ),

//                       const SizedBox(height: 8),

//                       // Price and Action Row
//                       Row(
//                         children: [
//                           // Price
//                           if (activity.price != null)
//                             Container(
//                               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                               decoration: BoxDecoration(
//                                 color: Colors.green.withOpacity(0.1),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Icon(
//                                     Icons.attach_money,
//                                     size: 14,
//                                     color: Colors.green[700],
//                                   ),
//                                   Text(
//                                     '${activity.price}',
//                                     style: TextStyle(
//                                       color: Colors.green[700],
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),

//                           const Spacer(),

//                           // Action Button
//                           Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                             decoration: BoxDecoration(
//                               color: Theme.of(context).primaryColor.withOpacity(0.1),
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Text(
//                                   'Learn More',
//                                   style: TextStyle(
//                                     color: Theme.of(context).primaryColor,
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 4),
//                                 Icon(
//                                   Icons.arrow_forward_ios,
//                                   size: 10,
//                                   color: Theme.of(context).primaryColor,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
