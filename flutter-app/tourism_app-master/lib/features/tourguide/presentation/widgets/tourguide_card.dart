import 'package:flutter/material.dart';
import 'package:tourism_app/core/component/cache_image.dart';
import 'package:tourism_app/core/network/end_points.dart';
import 'package:tourism_app/features/home/data/models/tourguid_model.dart';

class TourGuideCard extends StatefulWidget {
  final TourGuidModel tourGuide;
  final VoidCallback? onTap;

  const TourGuideCard({
    super.key,
    required this.tourGuide,
    this.onTap,
  });

  @override
  State<TourGuideCard> createState() => _TourGuideCardState();
}

class _TourGuideCardState extends State<TourGuideCard> {
  late bool isFavorited;

  @override
  void initState() {
    super.initState();
    isFavorited = widget.tourGuide.isFavorited ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black.withOpacity(0.05)),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              color: Colors.grey.withOpacity(0.1),
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Image Section
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                      child: CacheImage(
                        imageUrl: widget.tourGuide.profilePictureUrl != null ? '${EndPoints.domain}${widget.tourGuide.profilePictureUrl}' : '',
                        errorColor: Colors.grey[300]!,
                        boxFit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Favorite Icon
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isFavorited = !isFavorited;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isFavorited ? Icons.favorite : Icons.favorite_border,
                          color: isFavorited ? Colors.red : Colors.grey,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                  // Availability Status
                  if (widget.tourGuide.isAvailable == true)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Available',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Info Section
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Name
                    Text(
                      '${widget.tourGuide.firstName ?? ''} ${widget.tourGuide.lastName ?? ''}'.trim(),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),

                    // Languages
                    if (widget.tourGuide.languages != null && widget.tourGuide.languages!.isNotEmpty)
                      Row(
                        children: [
                          Icon(
                            Icons.language,
                            color: Colors.grey,
                            size: 12,
                          ),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              widget.tourGuide.languages!.take(2).join(', '),
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey,
                                    fontSize: 10,
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                    // Rating and Price Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Rating
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 14,
                            ),
                            SizedBox(width: 2),
                            Text(
                              widget.tourGuide.stars?.toStringAsFixed(1) ?? '0.0',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontSize: 11,
                                  ),
                            ),
                          ],
                        ),
                        // Price
                        Text(
                          '\$${widget.tourGuide.hourlyRate?.toString() ?? '0'}/hr',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                        ),
                      ],
                    ),

                    // Experience
                    Text(
                      '${widget.tourGuide.yearsOfExperience ?? 0} years exp.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
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
}
