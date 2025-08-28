import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tourism_app/core/component/row_imag_payment.dart';
import 'package:tourism_app/core/themes/colors.dart';
import 'package:tourism_app/features/Profile/Payment/data/radio_list_tile_data.dart';

class PaymentBody extends StatefulWidget {
  const PaymentBody({super.key});

  @override
  State<PaymentBody> createState() => _PaymentBodyState();
}

class _PaymentBodyState extends State<PaymentBody> {
  List<RadioListTileData> radioListTileData = [
    RadioListTileData(image: 'assets/images/visa.png', title: 'Visa'),
    RadioListTileData(image: 'assets/images/paypal.png', title: 'PayPal'),
    RadioListTileData(
        image: 'assets/images/mastercard.png', title: 'Master Card'),
    RadioListTileData(image: 'assets/images/Gpay.png', title: 'Google Pay'),
    RadioListTileData(image: 'assets/images/applepay.png', title: 'Apple Pay'),
    RadioListTileData(
        image: 'assets/images/amazonpay.png', title: 'Amazon Pay'),
  ];
  String? selectedPayment;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: CustomAppBar(
      //   title: 'Payment Method',
      // ),
      appBar: AppBar(),
      backgroundColor: AppColors.backgroundColor,
      body: Directionality(
        textDirection: TextDirection.ltr,
        child: Column(
          children: [
            RowImagPayment(),
            SizedBox(
              height: 20,
            ),
            Expanded(
              flex: 2,
              child: ListView.builder(
                  itemCount: radioListTileData.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: ListTile(
                          leading: Image.asset(
                            radioListTileData[index].image ??
                                'assets/images/whats-app.png',
                            width: 40.w,
                            height: 40.h,
                          ),
                          title: Text(
                            radioListTileData[index].title,
                            style: TextStyle(fontSize: 16.sp),
                          ),
                          trailing: Transform.scale(
                            scale: 1.5,
                            child: Radio(
                                value: radioListTileData[index].title,
                                groupValue: selectedPayment,
                                onChanged: (value) {
                                  setState(() {
                                    selectedPayment = value;
                                  });
                                }),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(bottom: 170, left: 10, right: 10),
            //   child: CustomButton(
            //     text: 'Confirme',
            //     backgroundColor: const Color(0xff46A0DB),
            //     color: const Color(0xffffffff),
            //     height: 70.h,
            //     onPressed: () {
            //       if (selectedPayment != null) {
            //         final selectedData = radioListTileData.firstWhere(
            //           (data) => data.title == selectedPayment,
            //         );

            //         Navigator.of(context).push(
            //           MaterialPageRoute(
            //             builder: (context) =>
            //                 InsertPaymentData(radioTile: selectedData),
            //           ),
            //         );
            //       } else {
            //         ScaffoldMessenger.of(context).showSnackBar(
            //           const SnackBar(
            //               content: Text('Please select a payment method!')),
            //         );
            //       }
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
