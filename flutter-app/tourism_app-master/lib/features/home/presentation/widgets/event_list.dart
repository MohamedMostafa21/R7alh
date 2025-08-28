import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourism_app/core/component/cache_image.dart';
import 'package:tourism_app/core/network/end_points.dart';
import 'package:tourism_app/core/utils/app_images.dart';
import 'package:tourism_app/core/utils/constants_models.dart';
import 'package:tourism_app/features/home/data/models/event_model.dart';
import 'package:tourism_app/features/home/manager/events/cubit/event_cubit.dart';

class EventList extends StatefulWidget {
  const EventList({super.key});

  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  @override
  void initState() {
    EventCubit.of(context).getEvents(context: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventCubit, EventState>(
      builder: (context, state) {
        if (state is EventLoading) {
          return SizedBox(
            height: 170,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is EventError) {
          return SizedBox(
            height: 170,
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
                    'Error loading events',
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
        } else if (state is EventSuccess &&
            ConstantsModels.eventModel != null &&
            ConstantsModels.eventModel!.data != null &&
            ConstantsModels.eventModel!.data!.isNotEmpty) {
          return _EventSlider(events: ConstantsModels.eventModel!.data!);
        } else {
          // Initial state or no data - show placeholder with default images
          return _EventSlider(events: null);
        }
      },
    );
  }
}

class _EventSlider extends StatefulWidget {
  final List<EventData>? events;

  const _EventSlider({this.events});

  @override
  _EventSliderState createState() => _EventSliderState();
}

class _EventSliderState extends State<_EventSlider> {
  late PageController _pageController;
  int _currentPage = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // Set up PageController with viewportFraction for peeking effect
    _pageController = PageController(
      initialPage: _currentPage,
      viewportFraction: 0.85, // Adjust the fraction to control the peeking size
    );

    // Set up the timer for automatic scrolling
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      final itemCount = widget.events?.length ?? sliderImages.length;
      if (_currentPage < itemCount - 1) {
        _currentPage++;
      } else {
        _currentPage = 0; // Restart to the first item
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer to avoid memory leaks
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemCount = widget.events?.length ?? sliderImages.length;

    return Container(
      margin: EdgeInsets.only(right: 10),
      height: 170,
      child: PageView.builder(
        padEnds: false,
        pageSnapping: true,
        controller: _pageController,
        itemCount: itemCount,
        itemBuilder: (context, index) {
          String imageUrl = '';

          if (widget.events != null && widget.events!.isNotEmpty) {
            // Use real event data
            final event = widget.events![index];
            imageUrl = event.thumbnailUrl ?? '';
            log('test===>$imageUrl');
          }

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: CacheImage(
              imageUrl: '${EndPoints.domain}$imageUrl',
              errorColor: Colors.grey,
            ),
          );
        },
      ),
    );
  }
}

List<String> sliderImages = [
  AppImages.posterTow,
  AppImages.posterTow,
  AppImages.posterTow,
  // AppImages.posterOne,
  // AppImages.posterThree,
];
