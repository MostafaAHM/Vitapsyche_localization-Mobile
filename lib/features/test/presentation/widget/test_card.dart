import 'package:flutter/material.dart';
import 'package:flutter_mindmed_project/core/routes/app_routes.dart';
import 'package:flutter_mindmed_project/features/test/data/test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/const/image_app.dart';
import '../../../../core/theme/colors.dart';

class TestCard extends StatefulWidget {
  final String title;
  final int questionCount;
  final bool isPayment;
  final Test test;
  const TestCard({
    super.key,
    required this.title,
    required this.questionCount,
    required this.isPayment,
    required this.test,
  });

  @override
  State<TestCard> createState() => _TestCardState();
}

class _TestCardState extends State<TestCard> {
  bool hasAccessToken = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAccessToken();
  }

  Future<void> _checkAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');
    setState(() {
      hasAccessToken = accessToken != null;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Don't show payment cards if no access token exists
    if (widget.isPayment && !hasAccessToken) {
      return const SizedBox.shrink();
    }

    // Show loading indicator while checking auth status
    // if (isLoading) {
    //   return const Center(child: CircularProgressIndicator());
    // }

    return Card(
      elevation: widget.isPayment ? 10 : 5,
      color: secoundryColor,
      margin: EdgeInsets.symmetric(vertical: 8.h),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  ImageApp.test,
                  height: 50,
                  width: 50,
                ),
                Expanded(
                  child: Text(
                    widget.title,
                    softWrap: true,
                    style: TextStyle(
                      color: mainBlueColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  '${widget.questionCount} Questions',
                  style: TextStyle(
                    color: textThirdColor,
                    fontSize: 14.sp,
                  ),
                ),
                Text(
                  'Every 2week',
                  style: TextStyle(
                    color: textThirdColor,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
            _buildButton(
              () {
                widget.isPayment
                    ? Navigator.of(context)
                        .pushNamed(AppRoutes.paymenttestScreen, arguments: {
                        'nameTest': widget.title,
                        'price': 100.0,
                        'test': widget.test
                      })
                    : Navigator.of(context)
                        .pushNamed(AppRoutes.doTest, arguments: widget.test);
              },
              widget.isPayment,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildButton(void Function() onTap, bool isPayment) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: isPayment ? mainBlueColor : primaryColor,
          borderRadius: BorderRadius.circular(12.5),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10).w,
        child: Text(
          isPayment ? 'payment the test' : 'take the test',
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: secoundryColor, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}
