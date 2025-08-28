// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class RadioListTileData {
//   final String title;
//   final String image;
//   final Function onchanged;
//   final String selectPayment;

//   RadioListTileData(
//       {required this.title,
//       required this.image,
//       required this.selectPayment,
//       required this.onchanged});

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//         leading: Image.asset(
//           image,
//           width: 40.w,
//           height: 40.h,
//         ),
//         title: Text(
//           title,
//           style: TextStyle(fontSize: 16.sp),
//         ),
//         trailing: Transform.scale(
//           scale: 1.5,
//           child: Radio(
//             value: title,
//             groupValue: selectPayment,
//             onChanged: onchanged(),
//           ),
//         ));
//   }
// }
