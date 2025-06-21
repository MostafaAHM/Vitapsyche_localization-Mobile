import 'package:flutter/material.dart';
import 'package:flutter_mindmed_project/features/doctor/presentation/view/constService_doctor_book_screen.dart';
import 'package:flutter_mindmed_project/generated/l10n.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/theme/colors.dart';
import '../../data/doctor_model.dart';
import '../widget/doctor_list_item.dart';
import '../widget/search_bar_widget.dart';
import 'doctor_profile_details.dart';
import 'doctor_chat_screen.dart';

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
  String? _userEmail;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _fetchDoctors();
    _loadUserEmail();
  }

  Future<void> _loadUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userEmail = prefs.getString('user_email');
    });
  }

  Future<void> _fetchDoctors() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString('access_token');

    try {
      final response = await http.get(
        Uri.parse('https://abdokh.pythonanywhere.com/api/doctors/'),
        headers: {
          'accept': 'application/json',
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

  void _navigateToChatScreen(BuildContext context, DoctorModel doctor) async {
    // Use the authenticated user's email if available, otherwise generate anonymous ID
    final userId =
        _userEmail ?? 'anonymous_${DateTime.now().millisecondsSinceEpoch}';
    final userName = _userEmail?.split('@').first ?? 'User';

    // Create chat room between user and doctor
    final chatRoomId = _getChatRoomId(userId, doctor.id.toString());

    await _firestore.collection('chat_rooms').doc(chatRoomId).set({
      'participants': {
        userId: true,
        'doctor_${doctor.id}': true,
      },
      'participantNames': {
        userId: userName,
        'doctor_${doctor.id}': 'Dr. ${doctor.firstName} ${doctor.lastName}',
      },
      'lastMessage': '',
      'lastMessageTime': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
      'userEmail': _userEmail,
    }, SetOptions(merge: true));

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DoctorChatScreen(
          doctor: doctor,
          chatRoomId: chatRoomId,
          currentUserId: userId,
          currentUserName: userName,
        ),
      ),
    );
  }

  String _getChatRoomId(String userId, String doctorId) {
    List<String> ids = [userId, 'doctor_$doctorId'];
    ids.sort();
    return ids.join('_');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          SearchBarWidget(onSearchChanged: _onSearchChanged),
          Expanded(
            child:
                isLoading ? _buildShimmerLoading() : _buildDoctorsList(context),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      itemCount: 6,
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
                          Container(
                            width: 150,
                            height: 20,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: 100,
                            height: 16,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: 80,
                            height: 16,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
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

  PreferredSizeWidget _buildAppBar() {
    final localizations = S.of(context);
    return AppBar(
      backgroundColor: Colors.white,
      title: Text(
        localizations.ourTherapists,
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
    final localizations = S.of(context);
    return filteredDoctors.isEmpty && searchQuery.isNotEmpty
        ? Center(
            child: Text(
              '${localizations.noDoctorsFound} "$searchQuery"',
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
              onChat: () =>
                  _navigateToChatScreen(context, filteredDoctors[index]),
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
