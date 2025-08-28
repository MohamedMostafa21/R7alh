// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:barcode_widget/barcode_widget.dart';
// import 'package:tourism_app/features/Profile/Payment/mybooking/data/booking_model.dart';

// class MyBookingCard extends StatelessWidget {
//   final BookingModel? booking;

//   const MyBookingCard({this.booking, super.key});

//   @override
//   Widget build(BuildContext context) {
//     if (booking == null) {
//       return Center(
//         child: Text(
//           "No booking data available",
//           style: TextStyle(fontSize: 16.sp, color: Colors.grey),
//         ),
//       );
//     }

//     return Container(
//       padding: EdgeInsets.all(16.0),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.black, width: 0.5),
//         color: Colors.white,
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           if (booking!.barcodeData != null)
//             SizedBox(
//               height: 120.h,
//               width: 30.w,
//               child: Transform.rotate(
//                 angle: 0.0208,
//                 child: BarcodeWidget(
//                   barcode: Barcode.code128(),
//                   data: booking!.barcodeData!,
//                   drawText: false,
//                   width: 200,
//                   height: 60,
//                 ),
//               ),
//             ),
//           SizedBox(
//             width: 20.w,
//           ),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   booking!.title,
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16.sp,
//                   ),
//                 ),
//                 Text("Type: ${booking!.type}"),
//                 Text("Location: ${booking!.location}"),
//                 Text("Date: ${booking!.date}"),
//                 Text("Validity: ${booking!.validity}"),
//                 Text("Timing: ${booking!.timing}"),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
