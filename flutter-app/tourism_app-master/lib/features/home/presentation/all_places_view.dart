import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourism_app/core/component/app_bar_sharred.dart';
import 'package:tourism_app/core/utils/constants_models.dart';
import 'package:tourism_app/features/home/data/models/place_mode.dart';
import 'package:tourism_app/features/home/manager/places/cubit/place_cubit.dart';
import 'package:tourism_app/features/home/presentation/home_view.dart';

class AllPlacesView extends StatelessWidget {
  const AllPlacesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: shareAppBar(
        context,
        nameAppBar: 'All Places',
      ),
      body: SafeArea(
        child: BlocBuilder<PlaceCubit, PlaceState>(
          builder: (context, state) {
            if (state is PlaceLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is PlaceError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Error loading places',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        state.e,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.red,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        PlaceCubit.of(context).getPlaces(context: context);
                      },
                      child: Text('Retry'),
                    ),
                  ],
                ),
              );
            } else if (state is PlaceSuccess && ConstantsModels.placeModel != null && ConstantsModels.placeModel!.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: ConstantsModels.placeModel!.length,
                  itemBuilder: (context, index) {
                    final place = ConstantsModels.placeModel![index] as PlaceModel?;
                    return PlaceCard(
                      placeModel: place ?? PlaceModel(),
                      isHorizontalScroll: false,
                    );
                  },
                ),
              );
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_off,
                      size: 60,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No places available',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Check back later for new places',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
