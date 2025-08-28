import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tourism_app/core/component/cache_image.dart';
import 'package:tourism_app/core/themes/colors.dart';

class CustomCardImageHotels extends StatefulWidget {
  final String image;
  final String name;
  final String governorate;
  final String country;
  final double rate;
  final IconData iconData;
  final double price;
  final VoidCallback? onTap;

  const CustomCardImageHotels({
    super.key,
    required this.name,
    required this.governorate,
    required this.country,
    required this.rate,
    required this.iconData,
    this.onTap,
    required this.image,
    required this.price,
  });

  @override
  State<CustomCardImageHotels> createState() => _CustomCardImageHotelsState();
}

class _CustomCardImageHotelsState extends State<CustomCardImageHotels> {
  bool isFavorite = false;

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
              blurRadius: 2,
              color: Colors.grey.withOpacity(0.1),
            )
          ],
        ),
        child: Stack(
          children: [
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: CacheImage(
                      borderRadius: 3,
                      imageUrl: widget.image,
                      errorColor: Colors.grey,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.name,
                            style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontSize: 16.sp),
                          ),
                          SizedBox(height: 3),
                          Row(
                            children: [
                              Row(
                                children: List.generate(
                                  5,
                                  (index) => Icon(
                                    index < widget.rate ? Icons.star : Icons.star_border,
                                    color: Colors.amber,
                                    size: 16.w,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                widget.rate.toString(),
                                style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey),
                              ),
                            ],
                          ),
                          SizedBox(height: 3),
                          Row(
                            children: [
                              Icon(
                                widget.iconData,
                                color: Colors.grey,
                                size: 20.w,
                              ),
                              SizedBox(width: 3),
                              Text(
                                widget.governorate,
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey),
                              ),
                              SizedBox(width: 3),
                              Text(
                                ', ',
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey),
                              ),
                              SizedBox(width: 3),
                              Text(
                                widget.country,
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey),
                              ),
                            ],
                          ),
                          SizedBox(height: 3),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Starting from ',
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey),
                                ),
                                TextSpan(
                                  text: '${widget.price}\$',
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.primaryColor, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 3),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    isFavorite = !isFavorite;
                  });
                },
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.grey,
                  size: 26.w,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
