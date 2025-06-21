import 'package:flutter/material.dart';
import 'package:flutter_mindmed_project/core/theme/colors.dart';
import 'package:flutter_mindmed_project/generated/l10n.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaymentTestInfoWidget extends StatefulWidget {
  final String testName;
  final double price;

  const PaymentTestInfoWidget({
    super.key,
    required this.testName,
    required this.price,
  });

  @override
  _PaymentTestInfoWidgetState createState() => _PaymentTestInfoWidgetState();
}

class _PaymentTestInfoWidgetState extends State<PaymentTestInfoWidget> {
  final TextEditingController _couponController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final localizations = S.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.premiumTestDetails,
          style: TextStyle(
            color: mainBlueColor,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5.h),
        RichText(
          text: TextSpan(
            style: TextStyle(fontSize: 16.sp, color: Colors.black),
            children: [
              TextSpan(
                text: "${localizations.testName}: ",
                style: TextStyle(
                  fontWeight: FontWeight.w500, 
                  color: mainBlueColor,
                  fontSize: 16.sp,
                ),
              ),
              TextSpan(
                text: widget.testName,
                style: TextStyle(fontSize: 16.sp),
              ),
            ],
          ),
        ),
        SizedBox(height: 5.h),
        RichText(
          text: TextSpan(
            style: TextStyle(fontSize: 16.sp, color: Colors.black),
            children: [
              TextSpan(
                text: "${localizations.price}: ",
                style: TextStyle(
                  fontWeight: FontWeight.w500, 
                  color: mainBlueColor,
                  fontSize: 16.sp,
                ),
              ),
              TextSpan(
                text: "${localizations.currencySymbol}${widget.price.toStringAsFixed(2)}",
                style: TextStyle(fontSize: 16.sp),
              ),
            ],
          ),
        ),
        SizedBox(height: 15.h),
        Text(
          localizations.couponCode,
          style: TextStyle(
            fontSize: 16.sp, 
            fontWeight: FontWeight.w500
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _couponController,
                decoration: InputDecoration(
                  hintText: localizations.enterCouponCode,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.w, 
                    vertical: 10.h
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            ElevatedButton(
              onPressed: () {
                // Apply coupon logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor.withOpacity(.8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r)
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w, 
                  vertical: 14.h
                ),
              ),
              child: Text(
                localizations.apply,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}