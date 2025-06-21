import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_mindmed_project/generated/l10n.dart';
import 'package:flutter_mindmed_project/features/doctor/data/doctor_model.dart';
import 'package:flutter_mindmed_project/features/doctor/presentation/view/doctor_chat_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DoctorMessagesScreen extends StatefulWidget {
  const DoctorMessagesScreen({Key? key}) : super(key: key);

  @override
  _DoctorMessagesScreenState createState() => _DoctorMessagesScreenState();
}

class _DoctorMessagesScreenState extends State<DoctorMessagesScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot> _chatRoomsStream;
  String? _doctorEmail;
  String? _doctorId;
  String? _doctorName;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDoctorData();
    _initializeChatRoomsStream();
  }

  Future<void> _loadDoctorData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');
    try {
      // Get doctor data from API
      final response = await http.get(
        Uri.parse('https://abdokh.pythonanywhere.com/api/user/details/'),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $accessToken',
          'X-CSRFToken':
              'zBD8l6kYVuPskQcF5BNnHMqEQuEe3N9faaem1HcxxrgHrqhJeo2ND0OF7jV8yxIg',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _doctorEmail = data['email'];
          _doctorId = data['id'].toString();
          _doctorName = '${data['first_name']} ${data['last_name']}';
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load doctor data');
      }
    } catch (e) {
      print('Error loading doctor data: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load doctor information'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _initializeChatRoomsStream() {
    _chatRoomsStream = _firestore
        .collection('chat_rooms')
        .where('doctorEmail', isEqualTo: _doctorEmail)
        .orderBy('lastMessageTime', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = S.of(context);
    if (_isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.message,
            style: TextStyle(color: Colors.white, fontSize: 24)),
        backgroundColor: const Color.fromARGB(255, 3, 190, 150),
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _chatRoomsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No messages from patients yet'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final chatRoom = snapshot.data!.docs[index];
              final userEmail = chatRoom['userEmail'] as String? ?? 'Unknown';
              final userName =
                  chatRoom['participantNames'][userEmail] as String? ??
                      'Patient';
              final lastMessage = chatRoom['lastMessage'] as String? ?? '';
              final lastMessageTime = chatRoom['lastMessageTime'] as Timestamp?;
              final timeString = lastMessageTime != null
                  ? DateFormat('MMM d, h:mm a').format(lastMessageTime.toDate())
                  : '';
              return ListTile(
                leading: CircleAvatar(
                  child: Text(userName[0].toUpperCase()),
                  backgroundColor: const Color.fromARGB(255, 3, 190, 150),
                  foregroundColor: Colors.white,
                ),
                title: Text(userName),
                subtitle: Text(
                  lastMessage,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      timeString,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 4),
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 3, 190, 150),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DoctorChatScreen(
                        doctor: DoctorModel(
                          id: int.parse(_doctorId!),
                          username:
                              _doctorName!.replaceAll(' ', '').toLowerCase(),
                          firstName: _doctorName!.split(' ').first,
                          lastName: _doctorName!.split(' ').length > 1
                              ? _doctorName!.split(' ').last
                              : '',
                          email: _doctorEmail!,
                          phoneNumber: '',
                          birthDate: '',
                          gender: '',
                          nationality: '',
                          currentResidence: '',
                          fluentLanguages: '',
                          doctorDetails: DoctorDetails(
                            id: 0,
                            email: _doctorEmail!,
                            specialization: '',
                            yearsOfExperience: 0,
                            clinicName: '',
                            availabilityForSessions: false,
                          ),
                          role: 'doctor',
                        ),
                        chatRoomId: chatRoom.id,
                        currentUserId: 'doctor_${_doctorId}',
                        currentUserName: _doctorName!,
                        patientName: userName, // Pass the patient name
                        patientImageUrl:
                            null, // You can pass image URL if available
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
