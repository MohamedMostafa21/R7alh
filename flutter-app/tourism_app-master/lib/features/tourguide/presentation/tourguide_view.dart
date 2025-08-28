import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourism_app/core/component/app_bar_sharred.dart';
import 'package:tourism_app/core/utils/constants_models.dart';
import 'package:tourism_app/core/utils/navigate.dart';
import 'package:tourism_app/features/home/manager/tourGuid/cubit/tour_guides_cubit.dart';
import 'package:tourism_app/features/tourguide/presentation/tourguide_details_view.dart';
import 'package:tourism_app/features/tourguide/presentation/widgets/tourguide_card.dart';

class TourGuideView extends StatefulWidget {
  const TourGuideView({super.key});

  @override
  State<TourGuideView> createState() => _TourGuideViewState();
}

class _TourGuideViewState extends State<TourGuideView> {
  @override
  void initState() {
    super.initState();
    // Load tour guides when the page initializes
    TourGuidesCubit.of(context).getTourGuides(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: shareAppBar(
        context,
        nameAppBar: 'Tour Guides',
        hideBack: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Tour Guides List
            Expanded(
              child: BlocBuilder<TourGuidesCubit, TourGuidesState>(
                builder: (context, state) {
                  if (state is TourGuidesLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is TourGuidesError) {
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
                            'Error loading tour guides',
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
                              TourGuidesCubit.of(context).getTourGuides(context: context);
                            },
                            child: Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  } else if (state is TourGuidesSuccess && ConstantsModels.tourGuidModel != null && ConstantsModels.tourGuidModel!.isNotEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: ConstantsModels.tourGuidModel!.length,
                        itemBuilder: (context, index) {
                          final tourGuide = ConstantsModels.tourGuidModel![index];
                          return TourGuideCard(
                            tourGuide: tourGuide,
                            onTap: () {
                              context.navigateToPage(
                                TourGuideDetailsView(tourGuide: tourGuide),
                              );
                            },
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
                            Icons.person_search,
                            size: 60,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No tour guides available',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Check back later for available guides',
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
          ],
        ),
      ),
    );
  }
}
