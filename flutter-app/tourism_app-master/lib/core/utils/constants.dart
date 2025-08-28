import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:tourism_app/core/utils/app_images.dart';
import 'package:tourism_app/features/onbording/data/models/onbording_data_model.dart';

class Constants {
  static String fontFamily = 'Montserrat';
  static bool user = true;

  // static LatLng cairoLatLng = const LatLng(30.033333, 31.233334);
  static String locationCache = '';
  static String token = '';
  static bool tablet = false;
  static String unKnownValue = 'Un Known Value'.tr();
  static String unKnown = 'Un Known'.tr();
  static String notificationChannelKey = 'channel_id2';
  static LatLng saudiLatLng = const LatLng(24.7248316, 47.152177);

  // static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String fcmToken = '';
  static String currentLanguage = 'en';
  static String passwordApi = r'#as@$#$@as#';
  static Map jsonServerKey = {};

// static RemoteMessage? messageGlobal;
}

enum StatusRequest { completed, pending, canceled }

bool arabicLanguage = true;
List<String> onboardingImages = [
  AppImages.onboardingOne,
  AppImages.onboardingTwo,
  AppImages.onboardingThree,
];
final List<OnBoardingData> onboardingData = [
  OnBoardingData(
      title: 'Start an Easy Journey through Egypt',
      description: 'Discover the best hotels, restaurants, and museums in every city with personalized recommendations tailored to your interests.'),
  OnBoardingData(
      title: 'All Information at Your Fingertips',
      description:
          'Take pictures of places to get instant details and history, while avoiding tourist scams by knowing local prices for food, transport, and services.'),
  OnBoardingData(
      title: 'Additional Services to Enhance Your Journey',
      description: 'Book a trusted tour guide with a single click and use real-time translation to easily communicate with locals.'),
];

enum ContactMethods { whatsapp, email, call, meeting, project }

enum Gender { male, female }
