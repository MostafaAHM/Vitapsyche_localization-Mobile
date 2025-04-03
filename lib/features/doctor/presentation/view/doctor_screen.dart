import 'package:flutter/material.dart';
import 'package:flutter_mindmed_project/features/doctor/presentation/view/constService_doctor_book_screen.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/colors.dart';
import '../../data/doctor_model.dart';
import '../widget/doctor_list_item.dart';
import '../widget/search_bar_widget.dart';
import 'doctor_profile_details.dart';

class DoctorScreen extends StatefulWidget {
  DoctorScreen({super.key});

  @override
  _DoctorScreenState createState() => _DoctorScreenState();
}

class _DoctorScreenState extends State<DoctorScreen> {
  List<DoctorModel> doctors = [];
  List<DoctorModel> filteredDoctors = [];
  bool isLoading = true;
  String searchQuery = '';
  String? accessToken;

  @override
  void initState() {
    super.initState();
    _fetchDoctors();
  }

  Future<void> _fetchDoctors() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString('access_token');

    if (accessToken == null) {
      print('Access token not found. Please log in again.');
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('https://abdokh.pythonanywhere.com/api/doctors/'),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          doctors = data.map((json) => DoctorModel.fromJson(json)).toList();
          filteredDoctors = doctors;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load doctors');
      }
    } catch (e) {
      print('Error fetching doctors: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      searchQuery = query;
      filteredDoctors = doctors
          .where((doctor) =>
              doctor.firstName.toLowerCase().contains(query.toLowerCase()) ||
              doctor.lastName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          if (accessToken != null) ...[
            SearchBarWidget(onSearchChanged: _onSearchChanged),
          ],
          Expanded(
            child: isLoading
                ? _buildShimmerLoading()
                : accessToken == null
                    ? _buildSignInSignUpButtons()
                    : _buildDoctorsList(context),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      itemCount: 6, // Number of shimmer items to show
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: SizedBox(
              height: 120,
              child: Row(
                children: [
                  // Doctor image placeholder
                  Container(
                    width: 80,
                    height: 80,
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Doctor name placeholder
                          Container(
                            width: 150,
                            height: 20,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 8),
                          // Specialty placeholder
                          Container(
                            width: 100,
                            height: 16,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 8),
                          // Rating placeholder
                          Container(
                            width: 80,
                            height: 16,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Book button placeholder
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      width: 80,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignInSignUpButtons() {
    return Center(
      child: Text(
        'Please log in to view therapists',
        style: TextStyle(fontSize: 14, color: mainBlueColor),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      title: const Text(
        'Our Therapists',
        style: TextStyle(
          color: primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      elevation: 0,
      automaticallyImplyLeading: false,
    );
  }

  Widget _buildDoctorsList(BuildContext context) {
    return filteredDoctors.isEmpty && searchQuery.isNotEmpty
        ? Center(
            child: Text(
              'No doctors found for "$searchQuery"',
              style: const TextStyle(color: Colors.grey),
            ),
          )
        : ListView.builder(
            itemCount: filteredDoctors.length,
            itemBuilder: (context, index) => DoctorListItem(
              doctor: filteredDoctors[index],
              onProfileView: () =>
                  _navigateToDoctorProfile(context, filteredDoctors[index]),
              onBookView: () =>
                  _navigateToDoctorBook(context, filteredDoctors[index]),
            ),
          );
  }

  void _navigateToDoctorProfile(BuildContext context, DoctorModel doctor) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DoctorProfileDetails(
          doctorName: '${doctor.firstName} ${doctor.lastName}',
          specialty: doctor.doctorDetails.specialization,
          imagePath: doctor.image != null
              ? 'https://abdokh.pythonanywhere.com${doctor.image}'
              : '',
          rating: '4.5',
          specification: doctor.doctorDetails.specialization,
          country: doctor.nationality,
          joiningDate: '2021-01-01',
          sessions: doctor.doctorDetails.yearsOfExperience.toString(),
          salary: '\$100/hr',
          firstCharacter: doctor.firstName.substring(0, 1),
          doctorDetailsId: doctor.doctorDetails.id,
        ),
      ),
    );
  }

  void _navigateToDoctorBook(BuildContext context, DoctorModel doctor) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServiceDoctorBookingScreen(
          doctor: doctor,
          doctorDetailsId: doctor.doctorDetails.id,
        ),
      ),
    );
  }
}
