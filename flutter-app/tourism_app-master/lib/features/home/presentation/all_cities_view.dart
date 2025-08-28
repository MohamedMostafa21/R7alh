import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourism_app/core/component/app_bar_sharred.dart';
import 'package:tourism_app/core/utils/constants_models.dart';
import 'package:tourism_app/features/home/data/models/city_model.dart';
import 'package:tourism_app/features/home/manager/city/cubit/city_cubit.dart';
import 'package:tourism_app/features/home/presentation/widgets/city_section.dart';

class AllCitiesView extends StatelessWidget {
  const AllCitiesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: shareAppBar(
        context,
        nameAppBar: 'All Cities',
      ),
      body: SafeArea(
        child: BlocBuilder<CityCubit, CityState>(
          builder: (context, state) {
            if (state is CityLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is CityError) {
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
                      'Error loading cities',
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
                        CityCubit.of(context).getCities(context: context);
                      },
                      child: Text('Retry'),
                    ),
                  ],
                ),
              );
            } else if (state is CitySuccess && ConstantsModels.cityModel != null && ConstantsModels.cityModel!.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 2.3,
                  ),
                  itemCount: ConstantsModels.cityModel!.length,
                  itemBuilder: (context, index) {
                    final city = ConstantsModels.cityModel![index];
                    return CityCard(
                      cityModel: city,
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
                      Icons.location_city,
                      size: 60,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No cities available',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Check back later for new cities',
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
