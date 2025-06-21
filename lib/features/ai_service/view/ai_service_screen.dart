import 'package:flutter/material.dart';
import 'package:flutter_mindmed_project/core/routes/app_routes.dart';
import 'package:flutter_mindmed_project/features/ai_service/service/chat_bot/presentation/view/online_chatbot.dart';
import 'package:flutter_mindmed_project/features/ai_service/service/lina/presentation/view/online_linaScreen.dart';
import 'package:flutter_mindmed_project/generated/l10n.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/const/animation_gif.dart';
import '../../../core/theme/colors.dart';

class AiServiceScreen extends StatelessWidget {
  const AiServiceScreen({super.key});

  TextStyle _textStyle(double size, Color color, FontWeight weight) {
    return TextStyle(fontSize: size, color: color, fontWeight: weight);
  }

  Widget _serviceCard({
    required String title,
    required String subtitle1,
    required String subtitle2,
    required String imagePath,
    required VoidCallback onTap,
    bool clipRoundedImage = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
          side: const BorderSide(color: primaryColor),
        ),
        elevation: 5,
        color: secoundryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment
              .spaceBetween, // Ensure spacing between text and image
          crossAxisAlignment:
              CrossAxisAlignment.center, // Center-align content vertically
          children: [
            // Text Section
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: _textStyle(18.sp, mainBlueColor, FontWeight.bold),
                  ),
                  SizedBox(height: 5.h), // Add spacing between texts
                  Text(
                    subtitle1,
                    style: _textStyle(14.sp, grayColor, FontWeight.w300),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle2,
                    style: _textStyle(14.sp, grayColor, FontWeight.w300),
                  ),
                ],
              ),
            ),
            // Image Section
            Container(
              margin: EdgeInsets.only(
                  right: 10.w), // Add spacing to separate image from card edge
              child: clipRoundedImage
                  ? ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.r),
                        bottomLeft: Radius.circular(15.r),
                      ),
                      child: Image.asset(
                        imagePath,
                        // fit: BoxFit.cover,
                        height: 85.h, // Consistent image size
                        width: 100.w,
                      ),
                    )
                  : Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      height: 100.h, // Consistent image size
                      width: 100.w,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = S.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          localizations.aiSupport,
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _serviceCard(
            title: localizations.onlineChatService,
            subtitle1: localizations.clickToTreat,
            subtitle2: localizations.yourself,
            imagePath: AnimationGif.chatBot,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => OnlineChatScreen(),
              ),
            ),
          ),
          // _serviceCard(
          //   title: 'Lina Service',
          //   subtitle1: 'Click to Treat',
          //   subtitle2: 'Yourself',
          //   imagePath: AnimationGif.linachatBot,
          //   onTap: () => Navigator.of(context).pushNamed(AppRoutes.linaScreen),
          //   clipRoundedImage: true,
          // ),
          _serviceCard(
            title: localizations.onlineLinaService,
            subtitle1: localizations.clickToTreat,
            subtitle2: localizations.yourself,
            imagePath: AnimationGif.linachatBot,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => OnlineLynaModel(title: 'Lyna Screen'),
              ),
            ),
            clipRoundedImage: true,
          ),
        ],
      ),
    );
  }
}
