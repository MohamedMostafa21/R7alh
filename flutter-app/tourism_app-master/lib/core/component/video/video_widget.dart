// import 'dart:io';
//
// import 'package:chewie/chewie.dart';
// import 'package:flutter/material.dart';
// // ignore: depend_on_referenced_packages
// import 'package:video_player/video_player.dart';
//
// class ChewieDemo extends StatefulWidget {
//   const ChewieDemo({
//     super.key,
//     required this.path,
//     required this.file,
//     this.showControls,
//     this.allowMuting,
//     this.allowFullScreen,
//   });
//
//   final String path;
//   final bool file;
//   final bool? showControls;
//   final bool? allowMuting;
//   final bool? allowFullScreen;
//
//   @override
//   State<StatefulWidget> createState() {
//     return _ChewieDemoState();
//   }
// }
//
// class _ChewieDemoState extends State<ChewieDemo> {
//  // TargetPlatform? _platform;
//   late VideoPlayerController _videoPlayerController1;
//   late VideoPlayerController _videoPlayerController2;
//   ChewieController? _chewieController;
//   int? bufferDelay;
//
//   @override
//   void initState() {
//     super.initState();
//     initializePlayer();
//   }
//
//   @override
//   void dispose() {
//     _videoPlayerController1.dispose();
//     _videoPlayerController2.dispose();
//     _chewieController?.dispose();
//     super.dispose();
//   }
//
//   Future<void> initializePlayer() async {
//     _videoPlayerController1 = widget.file ? VideoPlayerController.file(File(widget.path)) : VideoPlayerController.networkUrl(Uri.parse(widget.path));
//     _videoPlayerController2 = widget.file ? VideoPlayerController.file(File(widget.path)) : VideoPlayerController.networkUrl(Uri.parse(widget.path));
//
//     await Future.wait([
//       _videoPlayerController1.initialize(),
//     ]);
//     _createChewieController();
//     setState(() {});
//   }
//
//   void _createChewieController() {
//     // final subtitles = [
//     //     Subtitle(
//     //       index: 0,
//     //       start: Duration.zero,
//     //       end: const Duration(seconds: 10),
//     //       text: 'Hello from subtitles',
//     //     ),
//     //     Subtitle(
//     //       index: 0,
//     //       start: const Duration(seconds: 10),
//     //       end: const Duration(seconds: 20),
//     //       text: 'Whats up? :)',
//     //     ),
//     //   ];
//
//     _chewieController = ChewieController(
//       videoPlayerController: _videoPlayerController1,
//       allowMuting: widget.showControls ?? true,
//       allowFullScreen: widget.allowFullScreen ?? true,
//       allowPlaybackSpeedChanging: false,
//       showControls: widget.showControls ?? true,
//       //draggableProgressBar: true,
//       progressIndicatorDelay: bufferDelay != null ? Duration(milliseconds: bufferDelay!) : null,
//       hideControlsTimer: const Duration(seconds: 1),
//       errorBuilder: (context, errorMessage) {
//         return Center(
//           child: Text(
//             errorMessage,
//             style: const TextStyle(color: Colors.white),
//           ),
//         );
//       },
//       /*additionalOptions: (context) {
//         return <OptionItem>[
//           OptionItem(
//             onTap: toggleVideo,
//             iconData: Icons.live_tv_sharp,
//             title: 'Toggle Video Src',
//           ),
//         ];
//       },*/
//       /*  subtitleBuilder: (context, dynamic subtitle) => Container(
//         padding: const EdgeInsets.all(10.0),
//         child: subtitle is InlineSpan
//             ? RichText(
//                 text: subtitle,
//               )
//             : Text(
//                 subtitle.toString(),
//                 style: const TextStyle(color: Colors.black),
//               ),
//       ),*/
//
//       // Try playing around with some of these other options:
//
//       // showControls: false,
//       // materialProgressColors: ChewieProgressColors(
//       //   playedColor: Colors.red,
//       //   handleColor: Colors.blue,
//       //   backgroundColor: Colors.grey,
//       //   bufferedColor: Colors.lightGreen,
//       // ),
//       // placeholder: Container(
//       //   color: Colors.grey,
//       // ),
//       // autoInitialize: true,
//     );
//   }
//
//   Future<void> toggleVideo() async {
//     await _videoPlayerController1.pause();
//
//     await initializePlayer();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_chewieController != null && _chewieController!.videoPlayerController.value.isInitialized) {
//       return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         home: Scaffold(
//           backgroundColor: Colors.black,
//           body: Chewie(
//             controller: _chewieController!,
//           ),
//         ),
//       );
//     } else {
//       return const Center(
//         child: CircularProgressIndicator(),
//       );
//     }
//   }
// }
//
// class DelaySlider extends StatefulWidget {
//   const DelaySlider({super.key, required this.delay, required this.onSave});
//
//   final int? delay;
//   final void Function(int?) onSave;
//
//   @override
//   State<DelaySlider> createState() => _DelaySliderState();
// }
//
// class _DelaySliderState extends State<DelaySlider> {
//   int? delay;
//   bool saved = false;
//
//   @override
//   void initState() {
//     super.initState();
//     delay = widget.delay;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     const int max = 1000;
//     return ListTile(
//       title: Text(
//         "Progress indicator delay ${delay != null ? "$delay MS" : ""}",
//       ),
//       subtitle: Slider(
//         value: delay != null ? (delay! / max) : 0,
//         onChanged: (value) async {
//           delay = (value * max).toInt();
//           setState(() {
//             saved = false;
//           });
//         },
//       ),
//       trailing: IconButton(
//         icon: const Icon(Icons.save),
//         onPressed: saved
//             ? null
//             : () {
//                 widget.onSave(delay);
//                 setState(() {
//                   saved = true;
//                 });
//               },
//       ),
//     );
//   }
// }
