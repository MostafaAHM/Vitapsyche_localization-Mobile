import 'package:flutter/material.dart';
import 'package:flutter_mindmed_project/generated/l10n.dart';


void massgeSuccessfully(BuildContext context) {
  final localizations = S.of(context)!;
  
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.green[400],
      content: Text(localizations.addedToCartSuccessfully),
      duration: const Duration(milliseconds: 300),
    ),
  );
}