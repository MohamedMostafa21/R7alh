import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tourism_app/core/component/buttons/favorite_icon.dart';
import 'package:tourism_app/core/component/cache_image.dart';
import 'package:tourism_app/core/network/end_points.dart';
import 'package:tourism_app/core/utils/app_icons.dart';
import 'package:tourism_app/core/utils/navigate.dart';
import 'package:tourism_app/features/home/data/models/place_mode.dart';
import 'package:tourism_app/features/home/manager/places/cubit/place_cubit.dart';
import 'package:tourism_app/features/home/manager/plans/cubit/plans_cubit.dart';
import 'package:tourism_app/features/home/manager/events/cubit/event_cubit.dart';
import 'package:tourism_app/features/home/manager/city/cubit/city_cubit.dart';
import 'package:tourism_app/features/home/presentation/all_places_view.dart';
import 'package:tourism_app/features/home/presentation/all_cities_view.dart';
import 'package:tourism_app/features/home/presentation/all_plans_view.dart';
import 'package:tourism_app/features/home/presentation/place_details_view.dart';
import 'package:tourism_app/features/home/presentation/widgets/city_section.dart';
import 'package:tourism_app/features/home/presentation/widgets/event_list.dart';
import 'package:tourism_app/features/home/presentation/widgets/header_page.dart';
import 'package:tourism_app/features/home/presentation/widgets/place_section.dart';
import 'package:tourism_app/features/home/presentation/widgets/plan_section.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    // Initialize all data when the page loads
    PlaceCubit.of(context).getPlaces(context: context);
    PlansCubit.of(context).getPlans(context: context);
    EventCubit.of(context).getEvents(context: context);
    CityCubit.of(context).getCities(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              HeaderHomePage(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(
                  children: [
                    Text(
                      'Events',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
              EventList(),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
              //   child: CategoryList(),
              // ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    Text(
                      'Popular',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        context.navigateToPage(AllPlacesView());
                      },
                      child: Text(
                        'View All',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey),
                      ),
                    )
                  ],
                ),
              ),
              PlaceSection(),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    Text(
                      'Cites',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        context.navigateToPage(AllCitiesView());
                      },
                      child: Text(
                        'View All',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              CitySection(),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    Text(
                      'Plans',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        context.navigateToPage(AllPlansView());
                      },
                      child: Text(
                        'View All',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey),
                      ),
                    )
                  ],
                ),
              ),

              PlansSection(),
              SizedBox(
                height: 100,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PlaceCard extends StatelessWidget {
  final PlaceModel? placeModel;
  final bool isHorizontalScroll;

  const PlaceCard({
    super.key,
    this.placeModel,
    this.isHorizontalScroll = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.navigateToPage(PlaceDetailsView(placeId:placeModel?.id?.toInt()??-1));
      },
      child: Container(
        width: isHorizontalScroll ? 150 : null,
        margin: isHorizontalScroll ? EdgeInsets.only(left: 10) : EdgeInsets.zero,
        padding: EdgeInsets.all(10),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CacheImage(
                  height: 150,
                  width: isHorizontalScroll ? 130 : double.infinity,
                  imageUrl: '${EndPoints.domain} ${placeModel?.thumbnailUrl}',
                  errorColor: Colors.grey,
                ),
                Positioned(
                  bottom: 7,
                  left: 5,
                  right: 5,
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          placeModel != null ? '${placeModel!.country ?? ''}, ${placeModel!.city ?? ''}' : 'Egypt,Cairo',
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        placeModel?.name ?? 'Pyramids',
                        style: Theme.of(context).textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SvgPicture.asset(AppIcons.starList),
                    ],
                  ),
                ),
                FavoriteIcon()
              ],
            )
          ],
        ),
      ),
    );
  }
}
