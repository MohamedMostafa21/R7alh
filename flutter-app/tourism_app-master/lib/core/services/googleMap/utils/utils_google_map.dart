import 'dart:math';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tourism_app/core/utils/app_images.dart';

import 'constants_google_map.dart';

class UtilsGoogleMap {
  static Future<Uint8List> customizeImage({required String image, required double width}) async {
    final ByteData rowDataImage = await rootBundle.load(image);
    final addWidthImage = await instantiateImageCodec(rowDataImage.buffer.asUint8List(), targetWidth: width.round());
    final imageFrame = await addWidthImage.getNextFrame();
    final imageFormat = await imageFrame.image.toByteData(format: ImageByteFormat.png);
    return imageFormat!.buffer.asUint8List();
  }

  static Future<Marker> addMarker({
    bool myMarker = false,
    required String idMarker,
    required LatLng latLng,
    String? title,
    String? subTitle,
    required String image,
    required double width,
  }) async {
    final BitmapDescriptor customMarker = BitmapDescriptor.bytes(await customizeImage(image: image, width: width));
    return Marker(
      markerId: MarkerId(idMarker),
      position: latLng,
      infoWindow: InfoWindow(title: title, snippet: subTitle),
      icon: customMarker,
    );
  }

  static Future<void> addUpdateMyMarker({required LatLng latLng, List<Marker>? markers}) async {
    final Marker meMarker = await addMarker(
      idMarker: '-1',
      latLng: latLng,
      image: AppImages.emptyCartImage,
      title: 'انت هنا',
      width: 40.w,
    );
    (markers ?? ConstantsGoogleMap.markers).removeWhere((element) => element.markerId.value == '-1');
    (markers ?? ConstantsGoogleMap.markers).add(meMarker);
  }

  static Future<void> addUpdateCustomMarker({required LatLng latLng, List<Marker>? markers}) async {
    final Marker customMarker = await addMarker(
      idMarker: '-2',
      latLng: latLng,
      image: AppImages.emptyCartImage,
      width: 40.w,
    );
    (markers ?? ConstantsGoogleMap.markers).removeWhere((element) => element.markerId.value == '-2');
    (markers ?? ConstantsGoogleMap.markers).add(customMarker);
  }

  static double distance(double lat1, double lon1, double lat2, double lon2) {
    const r = 6372.8; // Earth radius in kilometers

    final dLat = toRadians(lat2 - lat1);
    final dLon = toRadians(lon2 - lon1);
    final lat1Radians = toRadians(lat1);
    final lat2Radians = toRadians(lat2);

    final a = haversin(dLat) + cos(lat1Radians) * cos(lat2Radians) * haversin(dLon);
    final c = 2 * asin(sqrt(a));

    return r * c;
  }

  static double toRadians(double degrees) => degrees * pi / 180;

  static double haversin(double radians) => pow(sin(radians / 2), 2).toDouble();
}
