import 'package:flutter/material.dart';
import 'package:flutter_mindmed_project/features/payment/presentation/widget/animation_done_test.dart';
import 'package:flutter_mindmed_project/features/test/data/test.dart';
import '../../../../core/theme/colors.dart';
import '../../data/data_payment.dart';
import '../widget/payment_method_selection.dart';
import '../widget/payment_test_info_widget.dart';

class PaymentTestScreen extends StatefulWidget {
  const PaymentTestScreen(
      {super.key,
      required this.price,
      required this.nameTest,
      required this.test});
  final double price;
  final String nameTest;
  final Test test;
  @override
  _PaymentTestScreenState createState() => _PaymentTestScreenState();
}

class _PaymentTestScreenState extends State<PaymentTestScreen> {
  String selectedPayment = 'VitaPsyche Wallet';

  void _confirmDeleteDone(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // منع الإغلاق أثناء التحميل
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: loadingTestBuy(context , widget.test),
        ),
      ),
    );
  }

  PreferredSizeWidget? _buildAppBar() {
    return AppBar(
      foregroundColor: primaryColor,
      backgroundColor: secoundryColor,
      centerTitle: true,
      title: const Text(
        'Check Out',
        style: TextStyle(
          color: primaryColor,
          fontSize: 21,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 21, horizontal: 10),
      decoration: BoxDecoration(
        color: secoundryColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '-${widget.price.toStringAsFixed(2)} EGP', //amount ---
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: redColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(12),
                    )),
                onPressed: () {
                  // Handle cancel logic
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                      color: secoundryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // Add checkout animation logic
                  _confirmDeleteDone(context);
                },
                child: const Text(
                  'Done',
                  style: TextStyle(
                      color: secoundryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PaymentTestInfoWidget(
                testName: widget.nameTest,
                price: widget.price,
              ),
              const SizedBox(height: 20),
              PaymentMethodSelectionWidget(
                paymentMethods: paymentMethods,
                selectedPayment: selectedPayment,
                onPaymentSelected: (value) {
                  setState(() {
                    selectedPayment = value;
                  });
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildFooter(),
    );
  }
}
