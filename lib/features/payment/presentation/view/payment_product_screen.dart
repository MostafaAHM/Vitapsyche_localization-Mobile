import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mindmed_project/generated/l10n.dart';
import '../../../../core/theme/colors.dart';
import '../../../products/presentation/cubit/cart_cubit.dart';
import '../../data/data_payment.dart';
import '../widget/address_selection.dart';
import '../widget/animation_done_product.dart';
import '../widget/payment_method_selection.dart';

class PaymentProductScreen extends StatefulWidget {
  const PaymentProductScreen({super.key, required this.price});
  final double price;

  @override
  _PaymentProductScreenState createState() => _PaymentProductScreenState();
}

class _PaymentProductScreenState extends State<PaymentProductScreen> {
  String selectedAddress = 'Home';
  String selectedPayment = 'VitaPsyche Wallet';

  void _confirmDeleteDone(BuildContext context) {
    final cartCubit = context.read<CartCubit>();
    cartCubit.removeAllCart();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: loadingProdcutBuy(context),
        ),
      ),
    );
  }

  PreferredSizeWidget? _buildAppBar(BuildContext context) {
    final localizations = S.of(context)!;
    return AppBar(
      foregroundColor: primaryColor,
      backgroundColor: secoundryColor,
      centerTitle: true,
      title: Text(
        localizations.checkOut,
        style: const TextStyle(
          color: primaryColor,
          fontSize: 21,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final localizations = S.of(context)!;
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
            '-${widget.price.toStringAsFixed(2)} ${localizations.egpCurrency}',
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
                  Navigator.of(context).pop();
                },
                child: Text(
                  localizations.cancel,
                  style: const TextStyle(
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
                  _confirmDeleteDone(context);
                },
                child: Text(
                  localizations.done,
                  style: const TextStyle(
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
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AddressSelectionWidget(
                addresses: addresses,
                selectedAddress: selectedAddress,
                onAddressSelected: (value) {
                  setState(() {
                    selectedAddress = value;
                  });
                },
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
      bottomNavigationBar: _buildFooter(context),
    );
  }
}
