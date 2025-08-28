
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:tourism_app/core/themes/colors.dart';
// import 'package:tourism_app/core/themes/styles.dart';
// import 'package:tourism_app/core/utils/app_icons.dart';
// import 'package:tourism_app/core/utils/constants.dart';
// import 'package:tourism_app/core/utils/extensions.dart';

// class EstatesCardWidget extends StatefulWidget {
//   const EstatesCardWidget({super.key});

//   @override
//   State<EstatesCardWidget> createState() => _EstatesCardWidgetState();
// }

// class _EstatesCardWidgetState extends State<EstatesCardWidget> {
//   bool isAdded = false;
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       // onTap: () => context.navigateToPage(const EstateRentalDetailsScreen()),
//       child: Container(
//         decoration: ShapeDecoration(
//           color: AppColors.white,
//           shape: RoundedRectangleBorder(
//             side: const BorderSide(color: AppColors.cBorderTextFormField),
//             borderRadius: BorderRadius.circular(15),
//           ),
//         ),
//         child: Column(
//           children: [
//             Stack(
//               children: [
//                 // Image.asset(
//                 //   AppImages.projectsTemporary,
//                 //   fit: BoxFit.fill,
//                 //   width: context.screenWidth,
//                 // ),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 12.0, right: 12, left: 12),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
//                         decoration: ShapeDecoration(
//                           color: AppColors.greenWarm,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                         ),
//                         child: Text(
//                           'متاح للبيع',
//                           textAlign: TextAlign.right,
//                           style: Styles.style12300.copyWith(color: AppColors.white),
//                         ),
//                       ),
//                       const Spacer(),
//                       Container(
//                         padding: const EdgeInsets.all(6),
//                         decoration: ShapeDecoration(
//                           color: AppColors.white,
//                           shape: RoundedRectangleBorder(
//                             side: const BorderSide(color: AppColors.cBorderTextFormField),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           //    shadows: const [Utils.boxShadow],
//                         ),
//                         // child: SvgPicture.asset(
//                         //   AppIcons.share,
//                         //   colorFilter: const ColorFilter.mode(AppColors.primaryColor, BlendMode.srcIn),
//                         //   width: context.screenWidth * .06,
//                         // ),
//                       ),
//                       const SizedBox(
//                         width: 10,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(
//               height: 12,
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Unit Name'.tr(),
//                     textAlign: TextAlign.right,
//                     style: Styles.style14500,
//                   ),
//                   Text(
//                     'Project Name'.tr(),
//                     style: Styles.style12400,
//                   )
//                 ],
//               ),
//             ),
//             Divider(
//               color: AppColors.black.withOpacity(0.1),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                      // SvgPicture.asset(AppIcons.room),
//                       const SizedBox(
//                         width: 4,
//                       ),
//                       Text(
//                         '${'Room'.tr()}:3',
//                         textAlign: TextAlign.right,
//                         style: Styles.style12300,
//                       ),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                    //   SvgPicture.asset(AppIcons.toilets),
//                       const SizedBox(
//                         width: 4,
//                       ),
//                       Text(
//                         '${'bathrooms'.tr()}:2',
//                         textAlign: TextAlign.right,
//                         style: Styles.style12300,
//                       ),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                   //    SvgPicture.asset(AppIcons.space),
//                       const SizedBox(
//                         width: 4,
//                       ),
//                       FittedBox(
//                         fit: BoxFit.scaleDown,
//                         child: Text(
//                           'Area'.tr(),
//                           textAlign: TextAlign.right,
//                           style: Styles.style12300,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             Divider(
//               color: AppColors.black.withOpacity(0.1),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12),
//               child: Row(
//                 children: [
//                   Text(
//                     'Price: '.tr(),
//                     style: Styles.style12400.copyWith(color: AppColors.thirdTextColor),
//                   ),
//                   Row(
//                     children: [
//                       Text(
//                         '58,000 ',
//                         style: Styles.style16600.copyWith(color: AppColors.primaryColor, fontFamily: Constants.fontFamily),
//                       ),
//                       Text(
//                         'Rial'.tr(),
//                         style: Styles.style12400.copyWith(color: AppColors.thirdTextColor),
//                       )
//                     ],
//                   ),
//                   const Spacer(),
//                   const SizedBox(
//                     width: 40,
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         isAdded = !isAdded;
//                       });
//                     },
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: isAdded ? Colors.black : Colors.white,
//                         borderRadius: BorderRadius.circular(20),
//                         border: Border.all(width: 1.5, color: Colors.black),
//                       ),
//                       padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
//                       child: Row(
//                         children: [
//                           Text(
//                             'Add'.tr(),
//                             style: TextStyle(color: isAdded ? Colors.white : Colors.black),
//                           ),
//                           const SizedBox(
//                             width: 5,
//                           ),
//                           Container(
//                             height: 14,
//                             width: 14,
//                             // padding: const EdgeInsets.all(8),
//                             decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
//                             child: isAdded
//                                 ? Center(
//                                     child: Icon(
//                                     Icons.done,
//                                     size: 11.sp,
//                                   ))
//                                 : SvgPicture.asset('assets/images/svg/add2.svg'),
//                           )
//                         ],
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             const SizedBox(
//               height: 12,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
