import 'package:flutter/material.dart';
import 'package:flutter_mindmed_project/core/routes/app_routes.dart';
import 'package:flutter_mindmed_project/core/theme/colors.dart';
import 'package:flutter_mindmed_project/features/doctor/presentation/view/doctor_screen.dart';
import 'package:flutter_mindmed_project/features/home/appointmentsScreen.dart';
import 'package:flutter_mindmed_project/features/home/presentation/view/home_screen.dart';
import 'package:flutter_mindmed_project/features/more/presentation/view/more.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/const/image_app.dart';
import '../../../ai_service/view/ai_service_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});
  static const id = 'custemButtonBar';

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late PageController _pageController;
  String? accessToken; // Variable to hold the access token

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    _checkToken(); // Check if the token exists
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Check if the token exists
  Future<void> _checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      accessToken = prefs.getString('access_token');
    });
  }

  // List of pages corresponding to each navigation item
  List<Widget> get _pages {
    if (accessToken == null) {
      return [
        const HomeScreen(), // Home
        const AiServiceScreen(), // AI Service
        const More(), // More
      ];
    } else {
      return [
        const HomeScreen(), // Home
        DoctorScreen(), // Doctor
        const AppointmentsScreen(), // Appointments
        const AiServiceScreen(), // AI Service
        const More(), // More
      ];
    }
  }

  // Bottom navigation bar items
  List<BottomNavigationBarItem> get _bottomBar {
    if (accessToken == null) {
      return const [
        BottomNavigationBarItem(label: 'Home', icon: Icon(Icons.home)),
        BottomNavigationBarItem(label: 'Online AI', icon: Icon(Icons.chat)),
        BottomNavigationBarItem(
            label: 'More', icon: Icon(Icons.more_horiz_sharp)),
      ];
    } else {
      return const [
        BottomNavigationBarItem(label: 'Home', icon: Icon(Icons.home)),
        BottomNavigationBarItem(
            label: 'Doctor', icon: Icon(Icons.person_4_outlined)),
        BottomNavigationBarItem(
            label: 'Appointments', icon: Icon(Icons.event_available)),
        BottomNavigationBarItem(label: 'Online AI', icon: Icon(Icons.chat)),
        BottomNavigationBarItem(
            label: 'More', icon: Icon(Icons.more_horiz_sharp)),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secoundryColor,
      appBar: AppBar(
        backgroundColor: secoundryColor,
        scrolledUnderElevation: 0,
        elevation: 0,
        toolbarHeight: 70,
        leading: Image.asset(
          logoApp,
          cacheHeight: 90,
          cacheWidth: 80,
        ),
        titleSpacing: 0,
        title: const Column(
          children: [
            Text(
              'Vitapsyche',
              style: TextStyle(
                  fontSize: 25,
                  color: primaryColor,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              'clear your mind, calm your heart',
              style: TextStyle(
                  fontSize: 8,
                  color: mainBlueColor,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          if (accessToken != null)
            // Personal Icon inside a circular border (only shown if token is not null)
            GestureDetector(
              onTap: () {
                // Navigate to the profile screen
                Navigator.pushNamed(context, '/profile');
              },
              child: Container(
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: primaryColor, // Border color
                    width: 2, // Border width
                  ),
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 15, // Size of the circular icon
                  backgroundImage: AssetImage(
                      'assets/images/User_fill@3x.png'), // Your personal icon
                ),
              ),
            ),
          if (accessToken == null)
            // Sign In and Sign Up Buttons (only shown if token is null)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed(AppRoutes.signinScreen),
                    child: Text(
                      'Sign In',
                      style: _textStyle(12, Colors.white, FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainBlueColor,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  ElevatedButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed(AppRoutes.signupScreen),
                    child: Text(
                      'Sign Up',
                      style: _textStyle(12, Colors.white, FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: textMainColor,
        selectedItemColor: primaryColor,
        backgroundColor: secoundryColor,
        items: _bottomBar,
        currentIndex: _currentIndex,
        onTap: (int newValue) {
          setState(() {
            _currentIndex = newValue;
            _pageController.animateToPage(
              newValue,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          });
        },
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: _pages,
      ),
    );
  }

  // Reusable Text Style
  TextStyle _textStyle(double size, Color color, FontWeight weight) {
    return TextStyle(fontSize: size, color: color, fontWeight: weight);
  }
}
