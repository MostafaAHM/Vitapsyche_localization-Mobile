import 'package:flutter/material.dart';
import 'package:flutter_mindmed_project/features/profile_user/presentation/view/profile_details.dart';
import 'package:flutter_mindmed_project/generated/l10n.dart';
import '../../../../core/theme/colors.dart';
import '../../../payment/presentation/view/payment_profile.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = S.of(context);
    
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: secoundryColor,
        appBar: AppBar(
          bottom: TabBar(
              labelStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelColor: mainBlueColor,
              labelColor: primaryColor,
              dividerColor: Colors.transparent,
              indicatorColor: primaryColor,
              tabs: [
                Tab(
                  text: localizations.profileDetails,
                ),
                Tab(text: localizations.paymentDetails),
              ]),
          foregroundColor: primaryColor,
          backgroundColor: secoundryColor,
          title: Text(
            localizations.profile,
            style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
          ),
        ),
        body: const TabBarView(
          children: [
            ProfileDetails(),
            PaymentProfile(),
          ],
        ),
      ),
    );
  }
}