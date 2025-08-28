import 'dart:convert';

import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tourism_app/core/utils/constants.dart';
import 'package:tourism_app/features/authentication/login/data/models/login_model.dart';
import 'package:tourism_app/features/home/manager/city/cubit/city_cubit.dart';
import 'package:tourism_app/features/home/manager/events/cubit/event_cubit.dart';
import 'package:tourism_app/features/booking/views/manager/cubit/my_booking_cubit.dart';
import 'package:tourism_app/features/home/manager/bookGuide/cubit/book_guide_cubit.dart';
import 'package:tourism_app/features/home/manager/favorite/cubit/favorite_cubit.dart';
import 'package:tourism_app/features/home/manager/getActivites/cubit/get_activities_cubit.dart';
import 'package:tourism_app/features/home/manager/hotel/cubit/hotel_cubit.dart';
import 'package:tourism_app/features/home/manager/places/cubit/place_cubit.dart';
import 'package:tourism_app/features/home/manager/plans/cubit/plans_cubit.dart';
import 'package:tourism_app/features/home/manager/restaurant/cubit/restaurant_cubit.dart';
import 'package:tourism_app/features/home/manager/reviews/cubit/reviews_cubit.dart';
import 'package:tourism_app/features/home/manager/tourGuid/cubit/tour_guides_cubit.dart';
import 'package:tourism_app/features/home/manager/predictaimage/cubit/predict_image_with_ai_cubit.dart';
import 'package:tourism_app/features/menu/manager/cubit/apply_guide_cubit.dart';
import 'package:tourism_app/features/splashScreen/presentation/splash_screen.dart';
import 'core/network/dio_helper.dart';
import 'core/network/local/cache.dart';
import 'core/network/local/hive_data_base.dart';
import 'core/themes/light.dart';
import 'core/utils/bloc_observe.dart';

//Widget appStartScreen = const SplashScreenOne();c
final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  EasyLocalization.logger.enableBuildModes = [];
  // Hive
  //await Hive.initFlutter();
  // dio
  await DioHelper.init();

  userCache = await openHiveBox(userCacheBoxKey);

  onBoardingValue = userCache?.get(onBoardingKey, defaultValue: true);
  userCacheValue = LoginModel.fromJson(jsonDecode(await userCache!.get(userCacheKey, defaultValue: '{}')));
  Constants.token = userCacheValue?.token ?? '';
  // Constants.user = userCacheValue?.data?.type == 'developer';
  // checkInCache = userCache?.get(checkInKey, defaultValue: false);
  //log('user id ======> ${userCacheValue?.data?.id}');
  //log('user token ======> ${userCacheValue?.data?.token}');
  Bloc.observer = MyBlocObserver();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  // await NotificationUtility.initializeAwesomeNotification();
  // try {
  //   Constants.messageGlobal = await FirebaseMessaging.instance.getInitialMessage();
  //   if (Constants.messageGlobal?.data != null) {
  //     appStartScreen = const NavBArScreens();
  //   }
  //   log('appStartScreen $appStartScreen');
  // } catch (error) {
  //   log('$error');
  // }
  // selectTokens();
  // Constants.jsonServerKey = await loadJsonFile();
  runApp(
    DevicePreview(
      // enabled: false,
      builder: (context) {
        return EasyLocalization(
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('ar', 'SA'),
          ],
          path: 'assets/translation',
          startLocale: const Locale('en', 'US'),
          child: const MyApp(),
        );
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    arabicLanguage = context.locale.toString() == 'ar_SA';
    Constants.tablet = MediaQuery.of(context).size.width > 600;
    return ScreenUtilInit(
        minTextAdapt: true,
        splitScreenMode: true,
        designSize: const Size(360, 840),
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => PlaceCubit()),
            BlocProvider(create: (_) => EventCubit()),
            BlocProvider(create: (_) => CityCubit()),
            BlocProvider(create: (_) => PlansCubit()),
            BlocProvider(create: (_) => TourGuidesCubit()),
            BlocProvider(create: (_) => ReviewsCubit()),
            BlocProvider(create: (_) => FavoriteCubit()),
            BlocProvider(create: (_) => BookGuideCubit()),
            BlocProvider(create: (_) => MyBookingCubit()),
            BlocProvider(create: (_) => ApplyGuideCubit()),
            BlocProvider(create: (_) => RestaurantCubit()),
            BlocProvider(create: (_) => HotelCubit()),
            BlocProvider(create: (_) => GetActivitiesCubit()),
            BlocProvider(create: (_) => PredictImageWithAiCubit()),
            // BlocProvider(create: (_) => BottomNavBarCubit()),
            // BlocProvider(create: (_) => ServiceDetailsCubit()),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            navigatorKey: navigatorKey,
            //locale: DevicePreview.locale(context),
            //builder: DevicePreview.appBuilder,
            theme: light,
            home: SplashScreen(),
          ),
        ));
  }
}
//updates
