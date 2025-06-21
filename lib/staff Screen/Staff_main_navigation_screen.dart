import 'package:flutter/material.dart';
import 'package:flutter_mindmed_project/core/theme/colors.dart';
import 'package:flutter_mindmed_project/generated/l10n.dart';
import 'package:flutter_mindmed_project/staff%20Screen/Doctor_home.dart';
import 'package:flutter_mindmed_project/staff%20Screen/accepted_appointments_screen.dart';
import 'package:flutter_mindmed_project/staff%20Screen/doctor_availability_screen.dart';
import 'package:flutter_mindmed_project/staff%20Screen/doctor_messages_screen.dart';
import 'package:flutter_mindmed_project/staff%20Screen/request_screen.dart';
import 'package:flutter_mindmed_project/staff%20Screen/doctor_service_screen.dart'; // Import the new screen
import '../../../../core/const/image_app.dart';

class StaffMainNavigationScreen extends StatefulWidget {
  const StaffMainNavigationScreen({super.key});
  static const id = 'custemButtonBar';

  @override
  State<StaffMainNavigationScreen> createState() =>
      _StaffMainNavigationScreenState();
}

class _StaffMainNavigationScreenState extends State<StaffMainNavigationScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late PageController _pageController;

  // List of pages corresponding to each navigation item
  final List<Widget> _pages = [
    const DoctorHomeScreen(),
    const DoctorServiceScreen(),
    const DoctorMessagesScreen(),
    const RequestScreen(),
    const AcceptedAppointmentsScreen(),
    const DoctorAvailabilityScreen(),
  ];
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Bottom navigation bar items
  List<BottomNavigationBarItem> _bottomBar() {
    final localizations = S.of(context);
    return [
      BottomNavigationBarItem(
          label: localizations.home, icon: Icon(Icons.home)),
      BottomNavigationBarItem(
          label: localizations.specialty, icon: Icon(Icons.add_circle_outline)),
      BottomNavigationBarItem(
          // Add this item for messages
          label: localizations.message,
          icon: Icon(Icons.message)),
      BottomNavigationBarItem(
          label: localizations.request, icon: Icon(Icons.request_page)),
      BottomNavigationBarItem(
          label: localizations.appointments, icon: Icon(Icons.event_available)),
      BottomNavigationBarItem(
          label: localizations.availability, icon: Icon(Icons.calendar_today)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final localizations = S.of(context);
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
        title: Column(
          children: [
            Text(
              localizations.appName,
              style: TextStyle(
                  fontSize: 25,
                  color: primaryColor,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              localizations.appTagline,
              style: TextStyle(
                  fontSize: 8,
                  color: mainBlueColor,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          // Personal Icon inside a circular border
          GestureDetector(
            onTap: () {
              // Navigate to the profile screen
              Navigator.pushNamed(context, '/DoctorProfileScreen');
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
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: textMainColor,
        selectedItemColor: primaryColor,
        backgroundColor: secoundryColor,
        items: _bottomBar(),
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
    );
  }
}
