// import 'package:camera/camera.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:user_workers/core/themes/colors.dart';
// import 'package:user_workers/core/utils/assets.dart';
// import 'package:user_workers/core/utils/extensions.dart';
//
// class CameraPage extends StatefulWidget {
//   final List<CameraDescription>? cameras;
//
//   const CameraPage({super.key, required this.cameras});
//
//   @override
//   State<CameraPage> createState() => _CameraPageState();
// }
//
// class _CameraPageState extends State<CameraPage> {
//   late CameraController _cameraController;
//   bool _isRearCameraSelected = true;
//   bool onFlash = true;
//
//   Future initCamera(CameraDescription cameraDescription) async {
// // create a CameraController
//     _cameraController = CameraController(
//       cameraDescription,
//       ResolutionPreset.high,
//     );
// // Next, initialize the controller. This returns a Future.
//     try {
//       await _cameraController.initialize().then((_) {
//         if (!mounted) return;
//         setState(() {});
//       });
//     } on CameraException catch (e) {
//       debugPrint('camera error $e');
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     // initialize the rear camera
//     initCamera(widget.cameras![0]);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           if (_cameraController.value.isInitialized)
//             SizedBox(
//               height: context.screenHeight,
//               child: CameraPreview(
//                 _cameraController,
//               ),
//             )
//           else
//             Container(color: Colors.black, child: const Center(child: CircularProgressIndicator())),
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Container(
//               padding: EdgeInsets.symmetric(vertical: 20.h),
//               decoration: const BoxDecoration(
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//               ),
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       IconButton(
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         icon: const Icon(
//                           Icons.close,
//                           color: AppColors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const Spacer(),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: IconButton(
//                           padding: EdgeInsets.zero,
//                           iconSize: 30,
//                           icon: Icon(_isRearCameraSelected ? CupertinoIcons.switch_camera : CupertinoIcons.switch_camera_solid, color: Colors.white),
//                           onPressed: () {
//                             setState(() => _isRearCameraSelected = !_isRearCameraSelected);
//                             initCamera(widget.cameras![_isRearCameraSelected ? 0 : 1]);
//                           },
//                         ),
//                       ),
//                       Expanded(
//                         child: IconButton(
//                           onPressed: takePicture,
//                           iconSize: 50,
//                           padding: EdgeInsets.zero,
//                           constraints: const BoxConstraints(),
//                           icon: SvgPicture.asset(Assets.takePicture),
//                         ),
//                       ),
//                       Expanded(
//                         child: IconButton(
//                           padding: EdgeInsets.zero,
//                           iconSize: 30,
//                           icon: SvgPicture.asset(onFlash ? Assets.flashOn : Assets.flashOff),
//                           onPressed: () {
//                             _cameraController.setFlashMode(onFlash ? FlashMode.always : FlashMode.off);
//                             onFlash = !onFlash;
//                             setState(() {});
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   ///                           Take Picture
//   ///
//   Future takePicture() async {
//     if (!_cameraController.value.isInitialized) {
//       return null;
//     }
//     if (_cameraController.value.isTakingPicture) {
//       return null;
//     }
//     try {
//       await _cameraController.setFlashMode(FlashMode.off);
//     //  final XFile picture = await _cameraController.takePicture();
//       //PostingCubit.of(context).selectedImages.add(picture);
//       //  context.navigateToPageWithReplacement(const CreatePostScreen());
//     } on CameraException catch (e) {
//       debugPrint('Error occured while taking picture: $e');
//       return null;
//     }
//   }
//
//   @override
//   void dispose() {
//     // Dispose of the controller when the widget is disposed.
//     _cameraController.dispose();
//     super.dispose();
//   }
// }
