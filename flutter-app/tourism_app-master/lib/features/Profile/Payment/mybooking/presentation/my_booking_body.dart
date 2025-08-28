// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:tourism_app/core/component/custom_app_bar.dart';
// import 'package:tourism_app/core/component/custom_card_image_tourguide.dart';
// import 'package:tourism_app/core/component/custom_text.dart';
// import 'package:tourism_app/core/themes/colors.dart';
// import 'package:tourism_app/core/utils/app_images.dart';
// import 'package:tourism_app/features/Profile/Payment/mybooking/data/booking_model.dart';
// import 'package:tourism_app/features/Profile/Payment/mybooking/presentation/widgets/my_booking_card.dart';

// class MyBookingBody extends StatelessWidget {
//   final List<BookingModel?> bookings = [
//     BookingModel(
//         title: "East and West Banks",
//         type: "One Ticket - Visitor",
//         location: "Egypt",
//         date: "13/10/2024",
//         validity: "13/10/2024",
//         timing: "8:00 AM - 4:00 PM",
//         barcodeData: '1234567'),
//     BookingModel(
//       title: "Pyramids Tour",
//       type: "One Ticket - Visitor",
//       location: "Egypt",
//       date: "15/10/2024",
//       validity: "15/10/2024",
//       timing: "9:00 AM - 5:00 PM",
//       barcodeData: '',
//     ),
//   ];

//    MyBookingBody({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.backgroundColor,
//       appBar: CustomAppBar(
//         title: 'My Booking',
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             ListView.builder(
//               physics: NeverScrollableScrollPhysics(),
//               shrinkWrap: true,
//               itemCount: bookings.length,
//               itemBuilder: (context, index) {
//                 final booking = bookings[index];
//                 return Padding(
//                   padding: EdgeInsets.only(bottom: 20.h),
//                   child: MyBookingCard(booking: booking),
//                 );
//               },
//             ),
//             CustomText(
//               text: "Tour guide | booked with",
//               fontWeight: FontWeight.bold,
//               color: AppColors.black,
//             ),
//             SizedBox(height: 8.h),
//             Row(
//               children: [
//                 Flexible(
//                   child: CustomCardImageTourguide(
//                     image: AppImages.groupTourguide,
//                     language1: 'English',
//                     language2: 'Japanese',
//                     name: 'Ahmed fathy',
//                     rate: 1,
//                     price: 500,
//                   ),
//                 ),
//                 Flexible(
//                   child: CustomCardImageTourguide(
//                     image: AppImages.groupTourguide,
//                     language1: 'English',
//                     language2: 'Japanese',
//                     name: 'Ahmed fathy',
//                     rate: 1,
//                     price: 500,
//                   ),
//                 ),
//               ],
//             ),
//             //     );
//             // GridView.builder(
//             //   physics: NeverScrollableScrollPhysics(),
//             //   shrinkWrap: true,
//             //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             //     crossAxisCount: 2,
//             //     crossAxisSpacing: 16.w,
//             //     mainAxisSpacing: 16.h,
//             //     childAspectRatio: 3 / 4,
//             //   ),
//             //   itemCount: 1,
//             //   itemBuilder: (context, index) {
//             //     return CustomCardImageTourguide(
//             //       image: 'assets/images/Group1.png',
//             //       language1: 'English',
//             //       language2: 'Japanese',
//             //       name: 'Ahmed fathy',
//             //       rate: 1,
//             //       price: 500,
//             //     );
//             //   },

//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }
