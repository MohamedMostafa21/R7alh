// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart' as location_import;
// import 'package:user_workers/core/themes/colors.dart';
// import 'package:user_workers/core/utils/constants.dart';
// import 'package:user_workers/core/utils/extensions.dart';
// import 'package:user_workers/core/utils/utils.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// class GoogleMapWithoutScaffold extends StatefulWidget {
//   final double? height;
//   final bool? locationName;
//   final bool? detectLocationName;
//
//   const GoogleMapWithoutScaffold({super.key, this.height, this.locationName, this.detectLocationName});
//
//   @override
//   State<GoogleMapWithoutScaffold> createState() => _GoogleMapWithoutScaffoldState();
// }
//
// class _GoogleMapWithoutScaffoldState extends State<GoogleMapWithoutScaffold> {
//   final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
//
//   @override
//   void initState() {
//     requestLocation();
//     // _getLocation();
//     super.initState();
//   }
//
//   Future<void> _moveCameraToMyLocation() async {
//     final currentLocation = await getCurrentLocation();
//     final cameraUpdate = CameraUpdate.newLatLngZoom(
//       currentLocation,
//       11.0, // adjust zoom level as needed
//     );
//     _markers[0] = Marker(
//       markerId: const MarkerId('myMarker'),
//       position: LatLng(currentLocation.latitude, currentLocation.longitude),
//     );
//
//     final GoogleMapController googleMapController = await _controller.future;
//     googleMapController.animateCamera(cameraUpdate);
//     _getLocation();
//     setState(() {});
//   }
//
//   Future<void> _getLocation({LatLng? currentLocation}) async {
//     final location = location_import.Location();
//     List<Placemark>? placeMarks;
//     debugPrint('object');
//     try {
//       if (currentLocation == null) {
//         await location.getLocation().then((value) {
//           currentLocation = LatLng(value.latitude!, value.longitude!);
//         });
//       }
//
//       placeMarks = await placemarkFromCoordinates(
//         currentLocation!.latitude,
//         currentLocation!.longitude,
//       );
//       Constants.locationCache = '${placeMarks[0].locality}';
//       //widget.cubit.changeToCustomer();
//
//       debugPrint('currentLocation ${placeMarks[0].locality}');
//     } catch (e) {
//       debugPrint('Error getting location: $e');
//     }
//   }
//
//   Future<LatLng> getCurrentLocation() async {
//     final location = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//     debugPrint('(location.toJson() ${location.toJson()}');
//     return LatLng(location.latitude, location.longitude);
//   }
//
//   void requestLocation() async {
//     final status = await Permission.location.request();
//     if (status.isDenied) Utils.showToast(title: 'You must allow us to locate you', state: UtilState.error);
//   }
//
//   final List<Marker> _markers = [
//     Marker(
//       markerId: const MarkerId('myMarker'),
//       position: Constants.cairoLatLng,
//     ),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: widget.height != null ? context.screenHeight * (widget.height ?? .36) : null,
//       decoration: BoxDecoration(border: Border.all(color: AppColors.grey)),
//       child: GoogleMap(
//         mapType: MapType.terrain,
//         markers: Set.from(_markers),
//         initialCameraPosition: CameraPosition(
//           target: Constants.cairoLatLng,
//           zoom: 11,
//         ),
//         onTap: (argument) async {
//           _markers[0] = Marker(markerId: const MarkerId('myMarker'), position: LatLng(argument.latitude, argument.longitude));
//           await _getLocation(currentLocation: argument);
//           setState(() {});
//         },
//         onCameraMove: (position) {
//           _markers[0] = Marker(markerId: const MarkerId('myMarker'), position: LatLng(position.target.latitude, position.target.longitude));
//           setState(() {});
//         },
//         onMapCreated: (GoogleMapController controller) {
//           _controller.complete(controller);
//           setState(() {});
//         },
//       ),
//     );
//   }
// }
// Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (widget.locationName ?? false)
//           Text(
//             'Location: ${Constants.locationCache}',
//             style: Styles.style14700.copyWith(color: AppColors.black),
//           ),
//         Container(
//           height: widget.height != null ? context.screenHeight * (widget.height ?? .36) : null,
//           decoration: BoxDecoration(border: Border.all(color: AppColors.grey)),
//           child: GoogleMap(
//             mapType: MapType.terrain,
//             markers: Set.from(_markers),
//             initialCameraPosition: CameraPosition(
//               target: Constants.cairoLatLng,
//               zoom: 11,
//             ),
//             onTap: (argument) async {
//               _markers[0] = Marker(markerId: const MarkerId('myMarker'), position: LatLng(argument.latitude, argument.longitude));
//               await _getLocation(currentLocation: argument);
//               setState(() {});
//             },
//             onCameraMove: (position) {
//               _markers[0] = Marker(markerId: const MarkerId('myMarker'), position: LatLng(position.target.latitude, position.target.longitude));
//               setState(() {});
//             },
//             onMapCreated: (GoogleMapController controller) {
//               _controller.complete(controller);
//               setState(() {});
//             },
//           ),
//         ),
//         if (widget.detectLocationName ?? false)
//           CustomTextButton(
//             backgroundColor: AppColors.primaryColor,
//             borderColor: AppColors.transparent,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 SvgPicture.asset(
//                   Assets.location,
//                   colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
//                 ),
//                 5.ESW(),
//                 Text(
//                   'Detect my location',
//                   style: Styles.style16700.copyWith(color: AppColors.white),
//                 ),
//               ],
//             ),
//             onPress: () => _moveCameraToMyLocation(),
//           ),
//       ],
//     )
//
