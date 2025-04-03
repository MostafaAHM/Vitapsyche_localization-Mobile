// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_mindmed_project/features/payment/presentation/widget/animation_done_doctor.dart';

import '../../../../core/theme/colors.dart';
import '../../data/data_payment.dart';
import '../widget/payment_doctor_info_widget.dart';
import '../widget/payment_method_selection.dart';

class PaymentDoctorScreen extends StatefulWidget {
  const PaymentDoctorScreen({
    super.key,
    required this.price,
    required this.imageDoctor,
    required this.nameDoctor,
    required this.timeDoctor,
  });

  final double price;
  final String imageDoctor, nameDoctor, timeDoctor;

  @override
  _PaymentDoctorScreenState createState() => _PaymentDoctorScreenState();
}

class _PaymentDoctorScreenState extends State<PaymentDoctorScreen> {
  String selectedPayment = 'VitaPsyche Wallet';

  void _confirmDeleteDone(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing while loading
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: loadingDoctorBuy(),
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
            '-${widget.price.toStringAsFixed(2)} EGP',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: redColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: secoundryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
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
                  _confirmDeleteDone(context);
                },
                child: const Text(
                  'Done',
                  style: TextStyle(
                    color: secoundryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
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
              PaymentDoctorInfoWidget(
                imageDoctor: widget.imageDoctor,
                nameDoctor: widget.nameDoctor,
                timeDoctor: widget.timeDoctor,
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
