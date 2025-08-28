import 'package:easy_localization/easy_localization.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tourism_app/core/utils/utils.dart';

Future<LatLng?> getCurrentLocation() async {
  await Geolocator.requestPermission();
  final LocationPermission permission = await Geolocator.checkPermission();
  final LatLng? currentLocation;
  if (permission == LocationPermission.denied ||
      permission == LocationPermission.deniedForever ||
      permission == LocationPermission.unableToDetermine) {
    Utils.showToast(title: 'please_enable_location'.tr(), state: UtilState.error);
    return null;
  } else {
    final location = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    currentLocation = LatLng(location.latitude, location.longitude);
    return currentLocation;
  }
}
