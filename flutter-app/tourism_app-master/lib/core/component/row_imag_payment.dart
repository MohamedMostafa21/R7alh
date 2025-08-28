import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RowImagPayment extends StatelessWidget {
  const RowImagPayment({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          'assets/images/visa.png',
          width: 40.w,
          height: 30.h,
        ),
        Image.asset(
          'assets/images/paypal.png',
          width: 40.w,
          height: 30.h,
        ),
        Image.asset(
          'assets/images/mastercard.png',
          width: 40.w,
          height: 30.h,
        ),
        Image.asset(
          'assets/images/Gpay.png',
          width: 40.w,
          height: 30.h,
        ),
        Image.asset(
          'assets/images/applepay.png',
          width: 60.w,
          height: 30.h,
        ),
        Image.asset(
          'assets/images/amazonpay.png',
          width: 40.w,
          height: 30.h,
        ),
      ],
    );
  }
}
