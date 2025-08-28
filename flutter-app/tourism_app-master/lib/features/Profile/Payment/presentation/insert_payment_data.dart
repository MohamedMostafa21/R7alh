import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tourism_app/core/component/custom_text.dart';
import 'package:tourism_app/core/component/row_imag_payment.dart';
import 'package:tourism_app/features/Profile/Payment/data/radio_list_tile_data.dart';

class InsertPaymentData extends StatelessWidget {
  InsertPaymentData({super.key, required this.radioTile});
  final RadioListTileData radioTile;
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: Column(
        children: [
          RowImagPayment(),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey, // لون الـ Border
                  width: 1.5, // سماكة الـ Border
                ),
                borderRadius: BorderRadius.circular(8.r), // زوايا دائرية
              ),
              child: ListTile(
                leading: Image.asset(
                  radioTile.image!,
                  width: 50.w,
                  height: 50.h,
                ),
                title: Text(
                  radioTile.title,
                  style: TextStyle(fontSize: 23.sp),
                ),
                trailing: Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 23.sp,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: 'Please insert your data',
                  fontSize: 25.sp,
                  color: const Color(0xff25161A),
                  fontWeight: FontWeight.w400,
                ),
                SizedBox(
                  height: 15,
                ),
                CustomText(
                  text: 'CardNumber',
                  fontSize: 22.sp,
                  // color: const Color(0xff25161A),
                  fontWeight: FontWeight.w400,
                ),
                SizedBox(
                  height: 3,
                ),
                // CustomTextfield(
                //   hintText: '1234 1234 1234 1234',
                //   controller: cardNumberController,
                // ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: 'Expiry',
                            fontSize: 22.sp,
                            //    color: const Color(0xff25161A),
                            fontWeight: FontWeight.w400,
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          // CustomTextfield(
                          //     hintText: 'MM / YY',
                          //     controller: expiryController),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: 'CVV',
                            fontSize: 22.sp,
                            //     color: Color(0xff25161A),
                            fontWeight: FontWeight.w400,
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          // CustomTextfield(
                          //     hintText: 'cvv', controller: cvvController),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(top: 110, right: 10, left: 10),
          //   child: CustomButton(
          //       text: 'Submit',
          //       backgroundColor: const Color(0xff46A0DB),
          //       color: const Color(0xffffffff),
          //       height: 70.h,
          //       onPressed: () {
          //         context.navigateToPage(MyBookingBody());
          //       }),
          // ),
        ],
      ),
    );
  }
}
