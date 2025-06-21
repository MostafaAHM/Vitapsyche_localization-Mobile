import 'package:flutter/material.dart';
import 'package:flutter_mindmed_project/generated/l10n.dart';
import '../../../../core/theme/colors.dart';

class PaymentMethodSelectionWidget extends StatelessWidget {
  final List<Map<String, String>> paymentMethods;
  final String selectedPayment;
  final ValueChanged<String> onPaymentSelected;

  const PaymentMethodSelectionWidget({
    super.key,
    required this.paymentMethods,
    required this.selectedPayment,
    required this.onPaymentSelected,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = S.of(context)!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.paymentMethod,
          style: const TextStyle(
            color: mainBlueColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        ...paymentMethods.map((method) {
          final bool isSelected = method['name'] == selectedPayment;
          return Card(
            color: secoundryColor,
            elevation: isSelected ? 6 : 2,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Image.asset(
                method['icon']!,
                width: 40,
                height: 40,
                fit: BoxFit.contain,
              ),
              title: Text(
                method['name']!,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? primaryColor : mainBlueColor,
                ),
              ),
              trailing: Radio<String>(
                value: method['name']!,
                groupValue: selectedPayment,
                onChanged: (value) {
                  if (value != null) onPaymentSelected(value);
                },
              ),
            ),
          );
        }),
      ],
    );
  }
}