import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourism_app/core/component/cache_image.dart';
import 'package:tourism_app/core/network/end_points.dart';
import 'package:tourism_app/core/utils/constants_models.dart';
import 'package:tourism_app/core/utils/navigate.dart';
import 'package:tourism_app/features/city/persentaiton/city_details_view.dart';
import 'package:tourism_app/features/home/data/models/city_model.dart';
import 'package:tourism_app/features/home/manager/city/cubit/city_cubit.dart';

class CitySection extends StatelessWidget {
  const CitySection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CityCubit, CityState>(
      builder: (context, state) {
        if (state is CityLoading) {
          return SizedBox(
            height: 130,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is CityError) {
          return SizedBox(
            height: 130,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 40,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Error loading cities',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 4),
                  Text(
                    state.e,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.red,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        } else if (state is CitySuccess && ConstantsModels.cityModel != null && ConstantsModels.cityModel!.isNotEmpty) {
          // Show only first 4 cities
          final displayCities = ConstantsModels.cityModel!.take(4).toList();
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: displayCities.map((city) {
                  return CityCard(cityModel: city);
                }).toList(),
              ),
            ),
          );
        } else {
          // Initial state or no data - show placeholder cards
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: List.generate(3, (index) {
                  return CityCard();
                }),
              ),
            ),
          );
        }
      },
    );
  }
}

class CityCard extends StatelessWidget {
  final CityModel? cityModel;
  final bool isHorizontalScroll;

  const CityCard({
    super.key,
    this.cityModel,
    this.isHorizontalScroll = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: isHorizontalScroll ? const EdgeInsets.only(right: 10) : EdgeInsets.zero,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () => context.navigateToPage(CityDetailsView()),
            child: CacheImage(
              height: 130,
              width: isHorizontalScroll ? 300 : double.infinity,
              imageUrl: '${EndPoints.domain}${cityModel?.thumbnailUrl ?? ''}',
              errorColor: Colors.grey,
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            child: Text(
              cityModel?.name ?? 'unKnownValue',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
