import 'package:flutter/material.dart';
import 'package:flutter_mindmed_project/core/theme/colors.dart';
import 'package:flutter_mindmed_project/features/ai_service/service/chat_bot/data/chat_provider.dart';
import 'package:flutter_mindmed_project/generated/l10n.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io'; // For handling file paths

class CustomDrawer extends StatefulWidget {
  final VoidCallback onNewChatStarted; // Add this callback

  const CustomDrawer({Key? key, required this.onNewChatStarted})
      : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool _isLoading = false;
  String? _userEmail; // Store user email
  File? _profileImage; // Store profile image

  @override
  void initState() {
    super.initState();
    _fetchUserDetails(); // Fetch user details when the screen loads
    _fetchChatSessions(); // Fetch chat sessions
    _loadProfileImage(); // Load profile image from SharedPreferences
  }

  // Fetch user details from the API
  Future<void> _fetchUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');

    if (accessToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text("Authentication token not found. Please log in again.")),
      );
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('https://abdokh.pythonanywhere.com/api/user/details/'),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          _userEmail = responseData['email']; // Save user email
        });
      } else {
        throw Exception('Failed to fetch user details: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching user details: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to fetch user details.")),
      );
    }
  }

  // Load profile image from SharedPreferences
  Future<void> _loadProfileImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString('profile_image');

    if (imagePath != null) {
      setState(() {
        _profileImage = File(imagePath);
      });
    }
  }

  Future<void> _createNewChatSession(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');

    if (accessToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text("Authentication token not found. Please log in again.")),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(
            'https://abdokh.pythonanywhere.com/chatbot_api/chat_sessions/'),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        print("New chat session created: $responseData");

        // Save the new session ID to SharedPreferences
        int newSessionId = responseData['id'];
        await prefs.setInt('session_id', newSessionId);

        // Ensure that 'session_id' is saved as a string
        String newSessionStringId = responseData['session_id'].toString();
        await prefs.setString('session_stringid', newSessionStringId);

        print("Session String ID saved: $newSessionStringId");

        // Clear the current chat messages
        final chatProvider = Provider.of<ChatProvider>(context, listen: false);
        chatProvider.clearCurrentChat();

        // Update the last session ID in the provider
        chatProvider.updateLastSessionId(newSessionId);

        // Notify the parent widget to start the welcome animation
        widget.onNewChatStarted(); // Call the callback here

        // Close the drawer
        Navigator.pop(context);
      } else {
        throw Exception(
            'Failed to create chat session: ${response.statusCode}');
      }
    } catch (e) {
      final chatProvider = Provider.of<ChatProvider>(context, listen: false);
      chatProvider.clearCurrentChat();

      // Notify the parent widget to start the welcome animation
      widget.onNewChatStarted(); // Call the callback here

      // Close the drawer
      Navigator.pop(context);
    }
  }

  Future<void> _fetchChatSessions() async {
    setState(() {
      _isLoading = true;
    });

    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    await chatProvider.fetchChatSessions();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    final groupedSessions = chatProvider.groupedChatSessions;
    final localizations = S.of(context);

    // Sort the dates in descending order
    final sortedDates = groupedSessions.keys.toList()
      ..sort((a, b) {
        DateTime dateA = DateTime.parse(a.split('/').reversed.join('-'));
        DateTime dateB = DateTime.parse(b.split('/').reversed.join('-'));
        return dateB.compareTo(dateA); // Sort in descending order
      });

    return Drawer(
      backgroundColor: const Color(0xFF1A1A2E),
      child: Column(
        children: [
          // Header Section
          Container(
            padding:
                const EdgeInsets.only(top: 50, bottom: 20, left: 20, right: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  primaryColor,
                  const Color(0xFF2A2A40),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Profile Image
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.5),
                            width: 2,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white.withOpacity(0.9),
                          backgroundImage: _profileImage != null
                              ? FileImage(_profileImage!) // Display saved image
                              : null, // Placeholder if no image
                          child: _profileImage == null
                              ? Icon(
                                  Icons.person,
                                  size: 35,
                                  color: primaryColor,
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            localizations.welcomeBack,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _userEmail ?? 'User', // Display user email
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Language Switcher
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.language,
                            color: Colors.white70,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            localizations.languages,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2A40),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ToggleButtons(
                          isSelected: [
                            chatProvider.currentLanguage == 'en',
                            chatProvider.currentLanguage == 'ar',
                          ],
                          onPressed: (index) {
                            final lang = index == 0 ? 'en' : 'ar';
                            chatProvider.changeLanguage(lang);
                            Navigator.pop(context);
                          },
                          borderRadius: BorderRadius.circular(20),
                          selectedColor: Colors.white,
                          fillColor: primaryColor,
                          color: Colors.white60,
                          constraints: const BoxConstraints(
                            minWidth: 60,
                            minHeight: 36,
                          ),
                          children: const [
                            Text('EN'),
                            Text('AR'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Chat History Section
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF151525),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.history,
                                color: Colors.white70,
                                size: 24,
                              ),
                              SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    localizations.chatBotService,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  Text(
                                    localizations.yourPreviousConversations,
                                    style: TextStyle(
                                      color: Colors.white60,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: sortedDates.length,
                            itemBuilder: (context, index) {
                              final date = sortedDates[index];
                              final sessions = groupedSessions[date]!;
                              return ExpansionTile(
                                title: Text(
                                  date,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                children: sessions.map((session) {
                                  return ListTile(
                                    title: Text(
                                      '${localizations.session} ${session['id']}',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                    onTap: () async {
                                      print(
                                          "🔹 Selected Session ID: ${session['id']}");

                                      // Save session id in SharedPreferences
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      await prefs.setInt(
                                          'session_id', session['id']);

                                      // Fetch messages for the selected session
                                      final chatProvider =
                                          Provider.of<ChatProvider>(context,
                                              listen: false);
                                      await chatProvider
                                          .fetchMessagesForSession(
                                              session['session_id']);

                                      // Close the drawer
                                      Navigator.pop(context);
                                    },
                                  );
                                }).toList(),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
          ),

          // New Chat Button
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xFF151525),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, -2),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    primaryColor,
                    primaryColor.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.3),
                    offset: const Offset(0, 4),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () async {
                    await _createNewChatSession(context);
                  },
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.add_circle_outline,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          localizations.startNewChat,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
