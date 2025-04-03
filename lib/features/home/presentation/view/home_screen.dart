import 'package:flutter/material.dart';
import 'package:flutter_mindmed_project/features/ai_service/service/chat_bot/presentation/view/online_chatbot.dart';
import 'package:flutter_mindmed_project/features/ai_service/service/lina/presentation/view/online_linaScreen.dart';
import 'package:flutter_mindmed_project/features/home/presentation/category_services_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/const/animation_gif.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> categories = [];
  String? accessToken;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString('access_token');

    if (accessToken == null) {
      print('Access token not found. Please log in again.');
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('https://abdokh.pythonanywhere.com/api/categories/'),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      // Print the status code
      print('Status Code: ${response.statusCode}');

      // Print the entire response body
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        setState(() {
          categories = json.decode(response.body);
        });
      } else {
        // Print an error message if the status code is not 200
        print('Failed to load categories. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      // Print any exceptions that occur during the request
      print('Error fetching categories: $e');
    }
  }

  // Function to launch WhatsApp group link
  Future<void> _launchWhatsAppGroup() async {
    final Uri url =
        Uri.parse('https://chat.whatsapp.com/IXZROVnSctd1RtsgVHuLJ2');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  // Function to call Vitapsyche Support
  Future<void> _callVitapsycheSupport() async {
    final Uri phoneUrl = Uri.parse('tel:16328');
    if (!await launchUrl(phoneUrl)) {
      throw Exception('Could not launch $phoneUrl');
    }
  }

  // Reusable Service Card Widget
  Widget _serviceCard({
    required String title,
    required String subtitle1,
    required String subtitle2,
    required String imagePath,
    VoidCallback? onTap,
    bool clipRoundedImage = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.only(right: 10, bottom: 15, top: 10).w,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15).r,
          side: const BorderSide(color: primaryColor),
        ),
        elevation: 5,
        color: secoundryColor,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0).w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: _textStyle(18.sp, mainBlueColor, FontWeight.bold)),
                  Text(subtitle1,
                      style: _textStyle(14.sp, grayColor, FontWeight.w300)),
                  Text(subtitle2,
                      style: _textStyle(14.sp, grayColor, FontWeight.w300)),
                ],
              ),
            ),
            SizedBox(width: 20.w),
            clipRoundedImage
                ? ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomRight: const Radius.circular(15).r,
                      topRight: const Radius.circular(15).r,
                    ),
                    child: Image.asset(imagePath, fit: BoxFit.cover),
                  )
                : Image.asset(imagePath, fit: BoxFit.cover),
          ],
        ),
      ),
    );
  }

  // Reusable Header Widget
  Widget _header(String title) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: _textStyle(24.sp, primaryColor, FontWeight.bold),
      ),
    );
  }

  // Reusable Text Style
  TextStyle _textStyle(double size, Color color, FontWeight weight) {
    return TextStyle(fontSize: size, color: color, fontWeight: weight);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secoundryColor,
      body: CustomScrollView(
        slivers: [
          // Header Section
          SliverToBoxAdapter(child: _header('Our Service')),

          // ChatBot and Lina Service Section
          SliverToBoxAdapter(
            child: SizedBox(
              height: 180.h,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12).w,
                scrollDirection: Axis.horizontal,
                children: [
                  _serviceCard(
                    title: 'Lina Service',
                    subtitle1: 'Click to Treat',
                    subtitle2: 'Yourself',
                    imagePath: AnimationGif.linachatBot,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            OnlineLynaModel(title: 'Lyna Screen'),
                      ),
                    ),
                    clipRoundedImage: true,
                  ),
                  _serviceCard(
                    title: 'ChatBot Service',
                    subtitle1: 'Click to Treat',
                    subtitle2: 'Yourself',
                    imagePath: AnimationGif.chatBot,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => OnlineChatScreen(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Compunet Services Section
          SliverToBoxAdapter(
            child: SizedBox(
              height: 170.h,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 8).w,
                scrollDirection: Axis.horizontal,
                children: [
                  // _compunetService('Heart Rate', AnimationGif.test,
                  //     onTap: () => Navigator.of(context)
                  //         .pushNamed(AppRoutes.heartRateMonitor)),
                  _compunetService('Test', AnimationGif.test,
                      onTap: () => Navigator.of(context)
                          .pushNamed(AppRoutes.testScreen)),
                  _compunetService('Blog', AnimationGif.blog,
                      onTap: () => Navigator.of(context)
                          .pushNamed(AppRoutes.blogScreen)),
                  _compunetService('product', AnimationGif.production,
                      onTap: () => Navigator.of(context)
                          .pushNamed(AppRoutes.productsScreen)),
                  _compunetService('FQAs', AnimationGif.fqas,
                      onTap: () => Navigator.of(context)
                          .pushNamed(AppRoutes.fqasScreen)),
                  // _compunetService('Ask Doctor', AnimationGif.askDoctor,
                  //     onTap: () =>
                  //         Navigator.of(context).pushNamed(AppRoutes.askDoctor)),
                  _compunetService('Entertainment', AnimationGif.soundAnimation,
                      onTap: () => Navigator.of(context)
                          .pushNamed(AppRoutes.intertainment_Home)),
                ],
              ),
            ),
          ),

          // Doctors Specialists Section
          if (accessToken != null) ...[
            SliverToBoxAdapter(child: _header('Doctors Specialists')),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 300.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0).w,
                    child: _doctorsSpecialistsCard(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CategoryServicesScreen(
                            categoryId: categories[index]['id'],
                            categoryName: categories[index]['name'],
                          ),
                        ),
                      ),
                      imagePath: categories[index]['image'],
                      name: categories[index]['name'],
                      description: categories[index]['description'],
                    ),
                  ),
                ),
              ),
            ),
          ],
          // Get Help Section
          SliverToBoxAdapter(child: _header('Get Help')),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _getHelpCard(
                    Icons.support_agent_sharp, 'Talk to Vitapsyche Support'),
                if (accessToken != null) ...[
                  _getHelpcall(Icons.question_answer, 'Ask Doctor',
                      onTap: () =>
                          Navigator.of(context).pushNamed(AppRoutes.askDoctor)),
                ],
                if (accessToken != null) ...[
                  _getHelpcall(Icons.phone, 'Call Vitapsyche Support',
                      onTap: _callVitapsycheSupport),
                ], // Call Function
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _doctorsSpecialistsCard({
    required String imagePath,
    required String name,
    required String description,
    required VoidCallback onTap,
  }) {
    // Split the description into three parts
    List<String> descriptionParts = _splitDescription(description);

    return InkWell(
      onTap: onTap,
      child: Card(
        color: secoundryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        elevation: 2,
        child: Column(
          children: [
            // Image Section
            Container(
              height: 180.h, // Increased height for the image
              width: 200.w, // Adjusted width for the image
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15).r),
              ),
              child: Image.network(imagePath, fit: BoxFit.cover),
            ),
            // Name Section
            Padding(
              padding: const EdgeInsets.all(8.0).w,
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: _textStyle(16.sp, mainBlueColor, FontWeight.bold),
              ),
            ),
            // Description Section
            Padding(
              padding: const EdgeInsets.all(8.0).w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: descriptionParts.map((part) {
                  return Text(
                    part,
                    textAlign: TextAlign.center,
                    style: _textStyle(12.sp, grayColor, FontWeight.w500),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to split the description into three parts
  List<String> _splitDescription(String description) {
    int splitLength = (description.length / 3).ceil();
    return [
      description.substring(0, splitLength),
      description.substring(splitLength, 2 * splitLength),
      description.substring(2 * splitLength),
    ];
  }

  Widget _compunetService(String title, String imagePath,
      {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.all(10).w,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
        elevation: 5,
        color: secoundryColor,
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Text(title,
                style: _textStyle(18.sp, mainBlueColor, FontWeight.bold)),
            SizedBox(height: 20.h),
            Image.asset(imagePath, width: 140.w, height: 80.h),
          ],
        ),
      ),
    );
  }

  Widget _getHelpCard(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0).w,
      child: Card(
        color: secoundryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
          side: const BorderSide(color: primaryColor),
        ),
        elevation: 2,
        child: ListTile(
          leading: Icon(icon, color: primaryColor, size: 35.sp),
          title: Text(title,
              style: _textStyle(16.sp, mainBlueColor, FontWeight.bold)),
          onTap: _launchWhatsAppGroup, // Launch WhatsApp group link on tap
        ),
      ),
    );
  }
}

Widget _getHelpcall(IconData icon, String title, {VoidCallback? onTap}) {
  return Padding(
    padding: const EdgeInsets.all(8.0).w,
    child: Card(
      color: secoundryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
        side: const BorderSide(color: primaryColor),
      ),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: primaryColor, size: 35.sp),
        title: Text(
          title,
          style: TextStyle(
              color: mainBlueColor, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        onTap: onTap, // Call Function on Tap
      ),
    ),
  );
}
