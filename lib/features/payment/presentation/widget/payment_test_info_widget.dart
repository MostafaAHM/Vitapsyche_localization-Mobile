import 'package:flutter/material.dart';
import 'package:flutter_mindmed_project/core/theme/colors.dart';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Premium Test Details",
          style: TextStyle(
            color: mainBlueColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5.h),
        RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 16, color: Colors.black),
            children: [
              const TextSpan(
                text: "Test Name: ",
                style: TextStyle(
                    fontWeight: FontWeight.w500, color: mainBlueColor),
              ),
              TextSpan(text: widget.testName),
            ],
          ),
        ),
        const SizedBox(height: 5),
        RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 16, color: Colors.black),
            children: [
              const TextSpan(
                text: "Price: ",
                style: TextStyle(
                    fontWeight: FontWeight.w500, color: mainBlueColor),
              ),
              TextSpan(text: "\$${widget.price.toStringAsFixed(2)}"),
            ],
          ),
        ),
        const SizedBox(height: 15),
        const Text(
          "Coupon Code",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _couponController,
                decoration: InputDecoration(
                  hintText: "Enter coupon code",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                // Apply coupon logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor.withOpacity(.8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              ),
              child: const Text(
                "Apply",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
