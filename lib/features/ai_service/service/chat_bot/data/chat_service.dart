import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  static const String backendUrl =
      'http://10.0.2.2:8000/chatbot/'; // استبدل بالـ backend الفعلي

  Future<Map<String, String>> sendMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse(backendUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'message': message}),
      );

      print("🔹 ChatService Response:");
      print("🔹 Status Code: ${response.statusCode}");
      print("🔹 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'userMessage': message,
          'botResponse': data['response'] ?? 'No response from the server.'
        };
      } else {
        return {
          'userMessage': message,
          'botResponse': 'Error: Server responded with status code ${response.statusCode}'
        };
      }
    } catch (e) {
      return {
        'userMessage': message,
        'botResponse': 'Error: $e'
      };
    }
  }
}
