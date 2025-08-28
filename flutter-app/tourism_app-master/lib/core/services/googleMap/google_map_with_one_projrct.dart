import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tourism_app/core/services/googleMap/utils/constants_google_map.dart';
import 'package:tourism_app/core/services/googleMap/utils/utils_google_map.dart';
import 'package:tourism_app/core/themes/colors.dart';
import 'package:tourism_app/core/themes/styles.dart';
import 'package:tourism_app/core/utils/constants.dart';
import 'package:tourism_app/core/utils/extensions.dart';

class GoogleMapWithScaffoldAndOneProject extends StatefulWidget {
  final double? height;
  final bool? locationName;
  final bool? detectLocationName;
  final LatLng customLocation;
  final String nameProjectOrUnit;

  const GoogleMapWithScaffoldAndOneProject({
    super.key,
    this.height,
    this.locationName,
    this.detectLocationName,
    required this.customLocation,
    required this.nameProjectOrUnit,
  });

  @override
  State<GoogleMapWithScaffoldAndOneProject> createState() => _GoogleMapWithScaffoldAndOneProjectState();
}

class _GoogleMapWithScaffoldAndOneProjectState extends State<GoogleMapWithScaffoldAndOneProject> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  @override
  void initState() {
    //requestLocation();
    // _getLocation();
    // ConstantsGoogleMap.markers.add(
    //   Marker(
    //     markerId: const MarkerId('myMarker'),
    //     position: widget.customLocation,
    //   ),
    // );
    super.initState();
  }

  Future<void> _moveCameraToMyLocation() async {
    LatLng currentLocation = const LatLng(0, 0);

    currentLocation = widget.customLocation;
    final cameraUpdate = CameraUpdate.newLatLngZoom(
      currentLocation,
      16.0, // adjust zoom level as needed
    );
    UtilsGoogleMap.addUpdateCustomMarker(latLng: LatLng(currentLocation.latitude, currentLocation.longitude));

    final GoogleMapController googleMapController = await _controller.future;
    googleMapController.animateCamera(cameraUpdate);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.nameProjectOrUnit,
          style: Styles.style16400,
        ),
        centerTitle: true,
      ),
      body: Container(
        height: widget.height != null ? context.screenHeight * (widget.height ?? .36) : null,
        decoration: BoxDecoration(border: Border.all(color: AppColors.grey)),
        child: GoogleMap(
          style: ConstantsGoogleMap.mapOptions,
          markers: Set.from(ConstantsGoogleMap.markers),
          initialCameraPosition: CameraPosition(
            target: Constants.saudiLatLng,
            zoom: 10,
          ),
          onTap: (argument) async {
            //   _markers[0] = Marker(markerId: const MarkerId('myMarker'), position: LatLng(argument.latitude, argument.longitude));
            //   await _getLocation(currentLocation: argument);
            //_moveCameraToMyLocation();
            setState(() {});
          },
          onCameraMove: (position) {
            //  _markers[0] = Marker(markerId: const MarkerId('myMarker'), position: LatLng(position.target.latitude, position.target.longitude));
            setState(() {});
          },
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            _moveCameraToMyLocation();
            setState(() {});
          },
        ),
      ),
    );
  }
}
/*
Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.locationName ?? false)
          Text(
            'Location: ${Constants.locationCache}',
            style: Styles.style14700.copyWith(color: AppColors.black),
          ),
        Container(
          height: widget.height != null ? context.screenHeight * (widget.height ?? .36) : null,
          decoration: BoxDecoration(border: Border.all(color: AppColors.grey)),
          child: GoogleMap(
            mapType: MapType.terrain,
            markers: Set.from(_markers),
            initialCameraPosition: CameraPosition(
              target: Constants.cairoLatLng,
              zoom: 11,
            ),
            onTap: (argument) async {
              _markers[0] = Marker(markerId: const MarkerId('myMarker'), position: LatLng(argument.latitude, argument.longitude));
              await _getLocation(currentLocation: argument);
              setState(() {});
            },
            onCameraMove: (position) {
              _markers[0] = Marker(markerId: const MarkerId('myMarker'), position: LatLng(position.target.latitude, position.target.longitude));
              setState(() {});
            },
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              setState(() {});
            },
          ),
        ),
        if (widget.detectLocationName ?? false)
          CustomTextButton(
            backgroundColor: AppColors.primaryColor,
            borderColor: AppColors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  Assets.location,
                  colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
                ),
                5.ESW(),
                Text(
                  'Detect my location',
                  style: Styles.style16700.copyWith(color: AppColors.white),
                ),
              ],
            ),
            onPress: () => _moveCameraToMyLocation(),
          ),
      ],
    )
 */
