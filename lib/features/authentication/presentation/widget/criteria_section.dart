
import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';

class CriteriaSection extends StatelessWidget {
  final String title;
  final List<String> criteria;

  const CriteriaSection({super.key, required this.title, required this.criteria});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: mainBlueColor,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          ...criteria.map(
            (text) => Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('•',
                      style: TextStyle(color: mainBlueColor, fontSize: 16)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      text,
                      style: const TextStyle(
                        color: mainBlueColor,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
