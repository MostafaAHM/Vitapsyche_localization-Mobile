import 'package:flutter/material.dart';
import 'package:flutter_mindmed_project/generated/l10n.dart';
import '../../../../core/theme/colors.dart';

class AddressSelectionWidget extends StatelessWidget {
  final List<Map<String, String>> addresses;
  final String selectedAddress;
  final ValueChanged<String> onAddressSelected;

  const AddressSelectionWidget({
    super.key,
    required this.addresses,
    required this.selectedAddress,
    required this.onAddressSelected,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = S.of(context)!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.shippingTo,
          style: const TextStyle(
            color: mainBlueColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        ...addresses.map((address) {
          return Card(
            color: secoundryColor,
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: Text(
                address['title']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(address['phone']!),
                  Text(address['address']!),
                ],
              ),
              leading: Radio<String>(
                value: address['title']!,
                groupValue: selectedAddress,
                onChanged: (value) {
                  if (value != null) onAddressSelected(value);
                },
              ),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // Handle edit logic
                },
              ),
            ),
          );
        }),
      ],
    );
  }
}