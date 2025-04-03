import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_mindmed_project/features/ai_service/service/chat_bot/data/message_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChatProvider with ChangeNotifier {
  final String _chatSessionApiUrl =
      'https://abdokh.pythonanywhere.com/chatbot_api/chat_sessions/';

  List<Map<String, dynamic>> _chatSessions = [];
  List<MessageModel> _currentChat = [];
  bool _isSaved = false;
  String _currentLanguage = 'en';
  int? _lastSessionId; // Variable to store the last session ID

  List<Map<String, dynamic>> get chatSessions => _chatSessions;
  List<MessageModel> get currentChat => _currentChat;
  String get currentLanguage => _currentLanguage;
  int? get lastSessionId => _lastSessionId;

  /// Fetch chat sessions from the API
  Future<void> fetchChatSessions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');

    if (accessToken == null) {
      throw Exception('Access token not found. Please log in again.');
    }

    try {
      final response = await http.get(
        Uri.parse(_chatSessionApiUrl),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData =
            jsonDecode(utf8.decode(response.bodyBytes));
        _chatSessions = responseData.cast<Map<String, dynamic>>();

        // Update the last session ID from the latest session in the list
        if (_chatSessions.isNotEmpty) {
          _lastSessionId = _chatSessions.last['id'];
          await prefs.setInt(
              'session_id', _lastSessionId!); // Save the last session ID
        }

        notifyListeners();
      } else {
        throw Exception(
            'Failed to fetch chat sessions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch chat sessions: $e');
    }
  }

  Future<void> fetchMessagesForSession(String sessionStringId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');

    if (accessToken == null) {
      print('❌ Error: Access token not found. Please log in again.');
      throw Exception('Access token not found. Please log in again.');
    }

    try {
      final url =
          'https://abdokh.pythonanywhere.com/chatbot_api/chat_sessions/$sessionStringId/messages/';
      print('🌐 Fetching messages from: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      print('🔵 Response Status Code: ${response.statusCode}');
      print('🔵 Response Body: ${response.body}');
      print('🔵 Response Body: ${accessToken}');

      if (response.statusCode == 200) {
        final List<dynamic> responseData =
            jsonDecode(utf8.decode(response.bodyBytes));
        print('🟢 Successfully fetched messages: $responseData');

        _currentChat = responseData.map((message) {
          return MessageModel(
            role: message['sender'] == 'user' ? 'user' : 'bot',
            content: message['text'],
          );
        }).toList();
        notifyListeners();
      } else {
        print(
            '❌ Error: Failed to fetch messages. Status Code: ${response.statusCode}');
        throw Exception('Failed to fetch messages: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error: Exception occurred while fetching messages: $e');
      throw Exception('Failed to fetch messages: $e');
    }
  }

  /// Add a new message to the current chat session
  void addMessage({required String role, required String content}) {
    _currentChat.add(MessageModel(role: role, content: content));
    notifyListeners();
  }

  /// Send a message and handle both request and response
  Future<void> sendMessage(String message) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');
    int? sessionId = prefs.getInt('session_id');

    if (accessToken == null || sessionId == null) {
      throw Exception(
          'Access token or session ID not found. Please log in again.');
    }

    try {
      // إضافة رسالة المستخدم إلى قائمة الدردشة
      addMessage(role: 'user', content: message);

      // إرسال الرسالة إلى السيرفر
      final response = await http.post(
        Uri.parse('https://abdokh.pythonanywhere.com/chatbot_api/messages/'),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'chat_session': sessionId,
          'sender': 'user',
          'text': message,
        }),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        print("✅ Message sent successfully: $responseData");

        // استخراج رد الروبوت من استجابة السيرفر
        String botResponse =
            responseData['bot_response'] ?? "No response from bot.";

        // إضافة رد الروبوت إلى قائمة الدردشة
        addMessage(role: 'bot', content: botResponse);
      } else {
        throw Exception('Failed to send message: ${response.statusCode}');
      }
    } catch (e) {
      print("❌ API Error: $e");
      throw Exception('Failed to send message: $e');
    }
  }

  /// Format the date to dd/mm/yyyy
  String _formatDate(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}';
  }

  /// Group chat sessions by date
  Map<String, List<Map<String, dynamic>>> get groupedChatSessions {
    Map<String, List<Map<String, dynamic>>> groupedSessions = {};

    for (var session in _chatSessions) {
      String date = _formatDate(session['created_at']);
      if (!groupedSessions.containsKey(date)) {
        groupedSessions[date] = [];
      }
      groupedSessions[date]!.add(session);
    }

    return groupedSessions;
  }

  /// Clear the current chat session
  void clearCurrentChat() {
    _currentChat.clear();
    notifyListeners();
  }

  /// Change the current language
  void changeLanguage(String newLanguage) {
    _currentLanguage = newLanguage;
    notifyListeners();
  }

  void updateLastSessionId(int sessionId) {
    _lastSessionId = sessionId;
    notifyListeners();
  }
}
