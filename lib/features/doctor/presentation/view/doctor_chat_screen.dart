import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_mindmed_project/core/theme/colors.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../data/doctor_model.dart';

class DoctorChatScreen extends StatefulWidget {
  final DoctorModel doctor;
  final String chatRoomId;
  final String currentUserId;
  final String currentUserName;
  final String? patientName;
  final String? patientImageUrl;

  const DoctorChatScreen({
    required this.doctor,
    required this.chatRoomId,
    required this.currentUserId,
    required this.currentUserName,
    this.patientName,
    this.patientImageUrl,
    Key? key,
  }) : super(key: key);

  @override
  _DoctorChatScreenState createState() => _DoctorChatScreenState();
}

class _DoctorChatScreenState extends State<DoctorChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ScrollController _scrollController = ScrollController();
  late Stream<QuerySnapshot> _messagesStream;
  final Color primaryColor = Color.fromARGB(255, 32, 192, 172);
  final Color grayColor = Color.fromARGB(255, 32, 192, 172);
  String? _userEmail;
  List<DoctorModel> _doctors = [];
  bool _isLoadingDoctors = false;
  String? _patientName;
  String? _patientImageUrl;
  bool _isDoctorView = false;

  @override
  void initState() {
    super.initState();
    _isDoctorView = widget.currentUserId.startsWith('doctor_');
    _loadUserEmail();
    _initializeChat();
    _fetchDoctors();
    _loadPatientInfo();
  }

  Future<void> _fetchDoctors() async {
    setState(() {
      _isLoadingDoctors = true;
    });

    try {
      final response = await http.get(
        Uri.parse('https://abdokh.pythonanywhere.com/api/doctors/'),
        headers: {
          'accept': 'application/json',
          'X-CSRFToken':
              'Q9vtzGUAyHLdcXmZpSYaWcSN7Lnzz62cTVSsFWu8F6LLXbKAxryQMPHDyl3cVMQz',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _doctors =
              data.map((doctor) => DoctorModel.fromJson(doctor)).toList();
        });
      } else {
        throw Exception('Failed to load doctors');
      }
    } catch (e) {
      print('Error fetching doctors: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load doctors list'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoadingDoctors = false;
      });
    }
  }

  Future<void> _loadUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userEmail = prefs.getString('user_email');
    });
  }

  Future<void> _loadPatientInfo() async {
    if (!_isDoctorView) return;

    try {
      final chatRoom = await _firestore
          .collection('chat_rooms')
          .doc(widget.chatRoomId)
          .get();
      if (chatRoom.exists) {
        final participants =
            chatRoom.data()!['participantNames'] as Map<String, dynamic>;
        final userEmail = participants.keys.firstWhere(
          (key) => !key.startsWith('doctor_'),
          orElse: () => '',
        );

        setState(() {
          _patientName = widget.patientName ??
              participants[userEmail] as String? ??
              'Patient';
          _patientImageUrl = widget.patientImageUrl;
        });
      }
    } catch (e) {
      print('Error loading patient info: $e');
    }
  }

  Future<void> _initializeChat() async {
    final currentUserId = _userEmail ?? widget.currentUserId;
    final currentUserName =
        _userEmail?.split('@').first ?? widget.currentUserName;

    if (_userEmail != null) {
      await _firestore.collection('chat_rooms').doc(widget.chatRoomId).set({
        'participants': {
          currentUserId: true,
          'doctor_${widget.doctor.id}': true,
        },
        'participantNames': {
          currentUserId: currentUserName,
          'doctor_${widget.doctor.id}':
              'Dr. ${widget.doctor.firstName} ${widget.doctor.lastName}',
        },
        'lastMessage': '',
        'lastMessageTime': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
        'userEmail': _userEmail,
        'doctorEmail': widget.doctor.email,
      }, SetOptions(merge: true));
    }

    _messagesStream = _firestore
        .collection('chat_rooms')
        .doc(widget.chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();

    await _markMessagesAsRead();
  }

  Future<void> _markMessagesAsRead() async {
    try {
      final currentUserId = _userEmail ?? widget.currentUserId;

      final messages = await _firestore
          .collection('chat_rooms')
          .doc(widget.chatRoomId)
          .collection('messages')
          .where('senderId', isNotEqualTo: currentUserId)
          .where('read', isEqualTo: false)
          .get();

      for (var doc in messages.docs) {
        await doc.reference.update({'read': true});
      }
    } catch (e) {
      print('Error marking messages as read: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/chat_bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: _messagesStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                      ),
                    );
                  }

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToBottom();
                  });

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        _isDoctorView
                            ? 'Start conversation with $_patientName'
                            : 'Start the conversation with Dr. ${widget.doctor.firstName}',
                        style: TextStyle(color: grayColor),
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.only(top: 16, bottom: 8),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return _buildMessageBubble(snapshot.data!.docs[index]);
                    },
                  );
                },
              ),
            ),
          ),
          _buildInputField(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(DocumentSnapshot doc) {
    final message = doc['message'] as String;
    final senderId = doc['senderId'] as String;
    final timestamp = doc['timestamp'] as Timestamp?;
    final timeString = timestamp != null
        ? DateFormat('hh:mm a').format(timestamp.toDate())
        : '';
    final isRead = doc['read'] as bool? ?? false;
    final isMe = senderId == (_userEmail ?? widget.currentUserId);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!isMe && !_isDoctorView)
            Padding(
              padding: EdgeInsets.only(left: 8, bottom: 4),
              child: Text(
                'Dr. ${widget.doctor.firstName}',
                style: TextStyle(
                  fontSize: 12,
                  color: grayColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: isMe ? primaryColor : Colors.grey[100],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(isMe ? 16 : 4),
                topRight: Radius.circular(isMe ? 4 : 16),
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: TextStyle(
                    color: isMe ? Colors.white : Colors.black,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      timeString,
                      style: TextStyle(
                        fontSize: 10,
                        color: isMe ? Colors.white70 : grayColor,
                      ),
                    ),
                    if (isMe)
                      Padding(
                        padding: EdgeInsets.only(left: 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.done,
                              size: 16,
                              color: isRead ? Colors.blue : Colors.white70,
                            ),
                            Icon(
                              Icons.done,
                              size: 16,
                              color: isRead ? Colors.blue : Colors.white70,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final titleName = _isDoctorView
        ? _patientName ?? 'Patient'
        : 'Dr. ${widget.doctor.firstName} ${widget.doctor.lastName}';
    final titleImageUrl = _isDoctorView
        ? _patientImageUrl
        : widget.doctor.image != null
            ? 'https://abdokh.pythonanywhere.com${widget.doctor.image!}'
            : null;

    return AppBar(
      backgroundColor: const Color.fromARGB(255, 38, 133, 130),
      elevation: 1,
      title: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage:
                titleImageUrl != null ? NetworkImage(titleImageUrl) : null,
            child: titleImageUrl == null
                ? Text(
                    titleName[0].toUpperCase(),
                    style: TextStyle(color: Colors.white),
                  )
                : null,
            backgroundColor: primaryColor,
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titleName,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Online',
                style: TextStyle(
                  fontSize: 12,
                  color: const Color.fromARGB(255, 3, 255, 11),
                ),
              ),
            ],
          ),
        ],
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, -4),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      maxLines: 3,
                      minLines: 1,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.attach_file, color: grayColor),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.camera_alt, color: grayColor),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primaryColor,
            ),
            child: IconButton(
              icon: Icon(Icons.send, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isNotEmpty) {
      try {
        final currentUserId = _userEmail ?? widget.currentUserId;
        final currentUserName =
            _userEmail?.split('@').first ?? widget.currentUserName;
        final isDoctor = currentUserId.startsWith('doctor_');

        await _firestore
            .collection('chat_rooms')
            .doc(widget.chatRoomId)
            .collection('messages')
            .add({
          'message': _messageController.text.trim(),
          'senderId': currentUserId,
          'senderName':
              isDoctor ? 'Dr. ${widget.doctor.firstName}' : currentUserName,
          'timestamp': FieldValue.serverTimestamp(),
          'read': false,
          'isDoctor': isDoctor,
        });

        await _firestore
            .collection('chat_rooms')
            .doc(widget.chatRoomId)
            .update({
          'lastMessage': _messageController.text.trim(),
          'lastMessageTime': FieldValue.serverTimestamp(),
          'lastMessageSender': currentUserId,
        });

        _messageController.clear();
        _scrollToBottom();
      } catch (e) {
        print('Error sending message: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send message'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
