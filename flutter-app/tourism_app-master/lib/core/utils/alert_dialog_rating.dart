// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:user_workers/core/component/buttons/custom_text_button.dart';
// import 'package:user_workers/core/component/custom_text_form_field.dart';
// import 'package:user_workers/core/themes/colors.dart';
// import 'package:user_workers/core/themes/styles.dart';
// import 'package:user_workers/core/utils/assets.dart';
// import 'package:user_workers/core/utils/constants.dart';
// import 'package:user_workers/core/utils/custom_alert_dialog.dart';
// import 'package:user_workers/core/utils/extensions.dart';
// import 'package:user_workers/core/utils/utils.dart';
//
// Future<void> alertDialogRating(
//   BuildContext context, {
//   required String nameRequest,
// }) async {
//   showDialog(
//     context: context,
//     builder: (context) => AlertDialog(
//       backgroundColor: AppColors.white,
//       insetPadding: const EdgeInsets.symmetric(horizontal: 20),
//       title: Column(
//         children: [
//           Text.rich(
//             TextSpan(
//               text: 'Evaluate the service provided for your request'.tr(),
//               style: Styles.style18300.copyWith(fontWeight: FontWeight.w500, fontFamily: Constants.fontFamily),
//               children: [
//                 TextSpan(
//                   text: '"',
//                   style: Styles.style18300.copyWith(fontWeight: FontWeight.w500, fontFamily: Constants.fontFamily),
//                 ),
//                 TextSpan(
//                   text: nameRequest.tr(),
//                   style: Styles.style18300.copyWith(fontWeight: FontWeight.w500, fontFamily: Constants.fontFamily),
//                 ),
//                 TextSpan(
//                   text: '"',
//                   style: Styles.style18300.copyWith(fontWeight: FontWeight.w500, fontFamily: Constants.fontFamily),
//                 ),
//               ],
//             ),
//           ),
//           RatingBar.builder(
//             allowHalfRating: true,
//             itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
//             itemBuilder: (context, _) => SvgPicture.asset(Assets.star),
//             glowColor: AppColors.white,
//             unratedColor: AppColors.white,
//             onRatingUpdate: (rating) {
//               printDM('$rating');
//             },
//           ),
//           CustomTextFormField(
//             controller: TextEditingController(),
//             hintText: 'hintText',
//             nameField: 'Your comment about the service',
//             maxLines: 5,
//             outPadding: EdgeInsets.zero,
//             contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           ),
//         ].paddingDirectional(bottom: 24),
//       ),
//       actions: [
//         Row(
//           children: [
//             Expanded(
//               child: CustomTextButton(
//                 height: .06,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Submit evaluation'.tr(),
//                       textAlign: TextAlign.center,
//                       style: Styles.style16400.copyWith(fontWeight: FontWeight.w500, color: AppColors.white),
//                     ),
//                   ],
//                 ),
//                 onPress: () {
//                   Navigator.pop(context);
//                   customAlertDialog(context, name: 'Evaluation has been sent successfully!', subTitle: 'Thank you', onPress: () {});
//                 },
//               ),
//             ),
//           ],
//         ),
//       ],
//     ),
//   );
// }
