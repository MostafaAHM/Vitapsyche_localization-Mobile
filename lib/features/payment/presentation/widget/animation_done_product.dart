import 'package:flutter/material.dart';
import 'package:flutter_mindmed_project/generated/l10n.dart';
import '../../../../core/theme/colors.dart';

Future<void> _simulateLoading() async {
  await Future.delayed(const Duration(seconds: 5));
}

Widget loadingProdcutBuy(BuildContext context) {
  final localizations = S.of(context)!;
  
  return FutureBuilder(
    future: _simulateLoading(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              localizations.pleaseWait,
              style: const TextStyle(
                color: mainBlueColor, 
                fontSize: 16
              ),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator.adaptive(
              backgroundColor: primaryColor,
              valueColor: AlwaysStoppedAnimation(grayColor),
            ),
          ],
        );
      } else if (snapshot.connectionState == ConnectionState.done) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Future.delayed(const Duration(seconds: 3), () {
            Navigator.pop(context);
            Navigator.pop(context);
          });
        });
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle, 
              color: Colors.green, 
              size: 50
            ),
            const SizedBox(height: 10),
            Text(
              localizations.processCompleted,
              style: const TextStyle(
                color: Colors.green,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );
      }
      return const SizedBox();
    },
  );
}