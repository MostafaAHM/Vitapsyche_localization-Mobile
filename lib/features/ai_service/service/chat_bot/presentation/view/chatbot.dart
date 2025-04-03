import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_mindmed_project/core/theme/colors.dart';
import 'package:flutter_mindmed_project/features/ai_service/service/chat_bot/data/chat_service.dart';
import 'package:flutter_mindmed_project/features/ai_service/service/chat_bot/data/chat_provider.dart';
import 'package:flutter_mindmed_project/features/ai_service/service/chat_bot/presentation/view/custom_drawer.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart' as stt;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  String _response = '';
  String _animatedResponse = '';
  Timer? _timer;

  late stt.SpeechToText _speechToText;
  bool _isListening = false;

  bool _showWelcomeAnimation = false;

  final ChatService _chatService = ChatService();

  @override
  void initState() {
    super.initState();
    _speechToText = stt.SpeechToText();
    _controller.addListener(() {
      setState(() {});
    });
    _loadPreviousMessages(); // Load messages when the screen is initialized
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _showResponse(String response) {
    _response = response;
    _animatedResponse = '';

    setState(() {
      _isLoading = true;
    });

    final lines = _response.split('\n');
    int currentLineIndex = 0;

    _timer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      if (currentLineIndex < lines.length) {
        setState(() {
          _animatedResponse += '${lines[currentLineIndex]}\n';
        });
        currentLineIndex++;
        _scrollToBottom();
      } else {
        timer.cancel();
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  void _startWelcomeAnimation() {
    setState(() {
      _showWelcomeAnimation = true;
    });

    Timer(Duration(seconds: 5), () {
      setState(() {
        _showWelcomeAnimation = false;
      });
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

 Future<void> _sendMessage(String message) async {
  setState(() {
    _isLoading = true;
    _showWelcomeAnimation = false; // Hide the welcome animation
  });

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString('access_token');
  int? sessionId = prefs.getInt('session_id'); // Retrieve the latest session ID

  if (accessToken == null || sessionId == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              "Authentication token or session ID not found. Please log in again.")),
    );
    setState(() {
      _isLoading = false;
    });
    return;
  }

  try {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    ChatService chatService = ChatService();

    // Send the user's message and get the bot's response
    final chatResponse = await chatService.sendMessage(message);

    // Add the user's message to the chat
    chatProvider.addMessage(
        role: 'user', content: chatResponse['userMessage']!);

    // Send the user's message to the backend using the latest session ID
    await http.post(
      Uri.parse('https://abdokh.pythonanywhere.com/chatbot_api/messages/'),
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'chat_session': sessionId, // Use the latest session ID
        'sender': 'user',
        'text': chatResponse['userMessage'],
      }),
    );

    // Add the bot's response to the chat
    chatProvider.addMessage(
        role: 'bot', content: chatResponse['botResponse']!);

    // Send the bot's response to the backend using the latest session ID
    await http.post(
      Uri.parse('https://abdokh.pythonanywhere.com/chatbot_api/messages/'),
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'chat_session': sessionId, // Use the latest session ID
        'sender': 'bot',
        'text': chatResponse['botResponse'],
      }),
    );
  } catch (e) {
    print("❌ Error: $e");
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}

  Future<void> _loadPreviousMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionStringId = prefs.getString('session_stringid');

    if (sessionStringId != null) {
      final chatProvider = Provider.of<ChatProvider>(context, listen: false);
      await chatProvider.fetchMessagesForSession(sessionStringId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    final hasMessages = chatProvider.currentChat.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'ChatBot Service',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      drawer: CustomDrawer(
        onNewChatStarted: () {
          setState(() {
            _showWelcomeAnimation = true; // Show the welcome animation
          });
          _startWelcomeAnimation(); // Start the timer
        },
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              primaryColor,
              Color(0xFF2A2A40),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Column(
          children: [
            if (_showWelcomeAnimation)
              _buildWelcomeSection(), // Show welcome animation
            Expanded(
              child: ListView(
                controller: _scrollController,
                children: [
                  if (!hasMessages && !_showWelcomeAnimation)
                    _buildWelcomeSection(), // Show welcome section if no messages and no animation
                  ...chatProvider.currentChat.map((message) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 12.0),
                      child: Row(
                        mainAxisAlignment: message.role == 'user'
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (message.role != 'user')
                            CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: 24,
                              backgroundImage: AssetImage(
                                'assets/images/Logo.png',
                              ),
                            ),
                          if (message.role != 'user') const SizedBox(width: 10),
                          if (message.role == 'user') const SizedBox(width: 10),
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.7,
                              ),
                              decoration: BoxDecoration(
                                color: message.role == 'user'
                                    ? primaryColor
                                    : const Color(0xFF2A2A40),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                  bottomLeft: message.role == 'user'
                                      ? Radius.circular(12)
                                      : Radius.circular(0),
                                  bottomRight: message.role == 'user'
                                      ? Radius.circular(0)
                                      : Radius.circular(12),
                                ),
                              ),
                              child: Text(
                                message.content,
                                style: TextStyle(
                                  color: message.role == 'user'
                                      ? Colors.white
                                      : Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  if (_isLoading)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 24,
                            backgroundImage: AssetImage(
                              'assets/images/Logo.png',
                            ),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2A2A40),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _animatedResponse,
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            _buildInputField(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/Logo.png',
            width: 120,
            height: 120,
          ),
          const SizedBox(height: 20),
          const Text(
            'How can I help you today?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          const Text(
            'Start typing or use the microphone to ask me anything.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, -2),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Type your message...',
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: const Color(0xFF1A1A2E),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 20,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(
                    color: primaryColor,
                    width: 2.0,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          ClipOval(
            child: Material(
              color: primaryColor,
              child: InkWell(
                splashColor: Colors.white,
                onTap: _controller.text.isNotEmpty
                    ? () {
                        FocusScope.of(context).unfocus();
                        _sendMessage(_controller.text); // Send the message
                        _controller.clear();
                        _scrollToBottom();
                      }
                    : _startListening,
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: Icon(
                    _controller.text.isNotEmpty
                        ? Icons.send
                        : (_isListening ? Icons.mic : Icons.mic_off),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _startListening() async {
    try {
      bool available = await _speechToText.initialize(
        onStatus: (status) => print('Speech status: $status'),
        onError: (error) => print('Speech error: $error'),
      );
      if (available) {
        setState(() => _isListening = true);
        await _speechToText.listen(
          onResult: (result) {
            setState(() {
              _controller.text = result.recognizedWords;
            });
          },
          localeId: "en_US",
        );
      } else {
        setState(() => _isListening = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Speech recognition not available.")),
        );
      }
    } catch (e) {
      print("Speech Recognition Error: $e");
    }
  }

  Future<void> _stopListening() async {
    try {
      setState(() => _isListening = false);
      await _speechToText.stop();
    } catch (e) {
      print("Error stopping listening: $e");
    }
  }
}
