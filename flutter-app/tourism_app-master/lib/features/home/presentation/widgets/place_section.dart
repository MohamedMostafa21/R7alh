import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourism_app/core/utils/constants_models.dart';
import 'package:tourism_app/features/home/data/models/place_mode.dart';
import 'package:tourism_app/features/home/manager/places/cubit/place_cubit.dart';
import 'package:tourism_app/features/home/presentation/home_view.dart';

class PlaceSection extends StatelessWidget {
  const PlaceSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaceCubit, PlaceState>(
      builder: (context, state) {
        if (state is PlaceLoading) {
          return SizedBox(
            height: 200,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is PlaceError) {
          return SizedBox(
            height: 200,
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
                    'Error loading places',
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
        } else if (state is PlaceSuccess && ConstantsModels.placeModel != null && ConstantsModels.placeModel!.isNotEmpty) {
          // Show only first 4 places
          final displayPlaces = ConstantsModels.placeModel!.take(4).toList();
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: displayPlaces.map((place) {
                return PlaceCard(
                  placeModel: (place as PlaceModel?) ?? PlaceModel(),
                );
              }).toList(),
            ),
          );
        } else {
          // Initial state or no data - show placeholder cards
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(3, (index) {
                return PlaceCard();
              }),
            ),
          );
        }
      },
    );
  }
}
