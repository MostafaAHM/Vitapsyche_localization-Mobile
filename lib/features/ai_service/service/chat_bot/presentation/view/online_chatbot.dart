import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_mindmed_project/core/theme/colors.dart';
import 'package:flutter_mindmed_project/features/ai_service/service/chat_bot/data/chat_provider.dart';
import 'package:flutter_mindmed_project/features/ai_service/service/chat_bot/presentation/view/custom_drawer.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart' as stt;

class OnlineChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  @override
  _OnlineChatScreenState createState() => _OnlineChatScreenState();
}

class _OnlineChatScreenState extends State<OnlineChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _isSending = false;
  String _fullResponse = '';
  String _animatedResponse = '';
  Timer? _typingTimer;
  int _typingIndex = 0;
  final GlobalKey _animatedTextKey = GlobalKey();
  bool _showStopButton = false;

  late stt.SpeechToText _speechToText;
  bool _isListening = false;
  bool _showWelcomeAnimation = false;
  // bool _shouldScrollToTop = false;

  @override
  void initState() {
    super.initState();
    _speechToText = stt.SpeechToText();
    _controller.addListener(() {
      setState(() {});
    });
    _loadPreviousMessages();
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _startTypingAnimation(String fullResponse) {
    _fullResponse = fullResponse;
    _animatedResponse = '';
    _typingIndex = 0;
    _showStopButton = true;

    setState(() {
      _isLoading = true;
      // _shouldScrollToTop = false; // Don't scroll to top for responses
    });

    _typingTimer = Timer.periodic(Duration(milliseconds: 20), (timer) {
      if (_typingIndex < _fullResponse.length) {
        setState(() {
          _animatedResponse = _fullResponse.substring(0, _typingIndex + 1);
          _typingIndex++;
        });

        Timer(Duration(milliseconds: 10), () {
          _scrollToAnimatedText();
        });
      } else {
        timer.cancel();
        setState(() {
          _isLoading = false;
          _isSending = false;
          _showStopButton = false;
        });
        // _scrollToBottom();
      }
    });
  }

  void _stopResponse() {
    _typingTimer?.cancel();
    setState(() {
      _isLoading = false;
      _isSending = false;
      _showStopButton = false;
      _animatedResponse = _fullResponse;
    });
  }

  void _scrollToAnimatedText() {
    final context = _animatedTextKey.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
        alignment: 0.1,
      );
    }
  }

  // void _scrollToBottom() {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     if (_scrollController.hasClients) {
  //       _scrollController.animateTo(
  //         _scrollController.position.maxScrollExtent,
  //         duration: const Duration(milliseconds: 300),
  //         curve: Curves.easeOut,
  //       );
  //     }
  //   });
  // }

  // void _scrollToTop() {
  //   if (_shouldScrollToTop) {
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       if (_scrollController.hasClients) {
  //         _scrollController.animateTo(
  //           0,
  //           duration: const Duration(milliseconds: 300),
  //           curve: Curves.easeOut,
  //         );
  //       }
  //     });
  //   }
  // }

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

  Future<String> _callDeepSeekApi(String userInput) async {
    final url = Uri.parse('https://openrouter.ai/api/v1/chat/completions');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'Bearer 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',
    };
    final body = jsonEncode({
      "model": "deepseek/deepseek-r1:free",
      "messages": [
        {"role": "system", "content": "You are a helpful assistant."},
        {"role": "user", "content": userInput}
      ],
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return data['choices'][0]['message']['content'];
      } else {
        print('API Error Response: ${response.body}');
        throw Exception(
            'Failed to load response from DeepSeek API. Status code: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('API Call Error: $e');
      print('Stack trace: $stackTrace');
      return "Sorry, I couldn't process your request. Please try again.";
    }
  }

  Future<void> _sendMessage(String message) async {
    setState(() {
      _isSending = true;
      _isLoading = true;
      _showWelcomeAnimation = false;
      // _shouldScrollToTop = true; // Only scroll to top for user messages
    });

    // Scroll to top when sending a new message
    // _scrollToTop();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');
    int? sessionId = prefs.getInt('session_id');

    if (accessToken == null || sessionId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                "Authentication token or session ID not found. Please log in again.")),
      );
      setState(() {
        _isLoading = false;
        _isSending = false;
      });
      return;
    }

    try {
      final chatProvider = Provider.of<ChatProvider>(context, listen: false);
      chatProvider.addMessage(role: 'user', content: message);

      await http.post(
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

      final botResponse = await _callDeepSeekApi(message);
      chatProvider.addMessage(role: 'bot', content: botResponse);

      await http.post(
        Uri.parse('https://abdokh.pythonanywhere.com/chatbot_api/messages/'),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'chat_session': sessionId,
          'sender': 'bot',
          'text': botResponse,
        }),
      );

      _startTypingAnimation(botResponse);
    } catch (e) {
      print("❌ Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred. Please try again.")),
      );
      setState(() {
        _isLoading = false;
        _isSending = false;
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
            _showWelcomeAnimation = true;
          });
          _startWelcomeAnimation();
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
            Expanded(
              child: CustomScrollView(
                controller: _scrollController,
                reverse: true, // This makes new messages appear at the bottom
                slivers: [
                  SliverPadding(
                    padding:
                        EdgeInsets.only(bottom: 80), // Space for input field
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          // Reverse the index to show newest messages at bottom
                          final reversedIndex =
                              chatProvider.currentChat.length - 1 - index;
                          final message =
                              chatProvider.currentChat[reversedIndex];

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
                                  Stack(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        radius: 24,
                                        backgroundImage: AssetImage(
                                          'assets/images/Logo.png',
                                        ),
                                      ),
                                      if (_isLoading &&
                                          chatProvider.currentChat.last ==
                                              message &&
                                          message.role == 'bot')
                                        Positioned(
                                          right: 0,
                                          bottom: 0,
                                          child: Container(
                                            padding: EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: Color(0xFF2A2A40),
                                              shape: BoxShape.circle,
                                            ),
                                            child: SizedBox(
                                              width: 16,
                                              height: 16,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                if (message.role != 'user')
                                  const SizedBox(width: 10),
                                if (message.role == 'user')
                                  const SizedBox(width: 10),
                                Flexible(
                                  child: Container(
                                    key: (chatProvider.currentChat.last ==
                                                message &&
                                            _isLoading &&
                                            message.role == 'bot')
                                        ? _animatedTextKey
                                        : null,
                                    padding: const EdgeInsets.all(12),
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.7,
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
                                      (chatProvider.currentChat.last ==
                                                  message &&
                                              _isLoading &&
                                              message.role == 'bot')
                                          ? _animatedResponse
                                          : message.content,
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
                        },
                        childCount: chatProvider.currentChat.length,
                      ),
                    ),
                  ),
                  if (_showWelcomeAnimation ||
                      (!hasMessages && !_showWelcomeAnimation))
                    SliverToBoxAdapter(
                      child: _buildWelcomeSection(),
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
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: 'Type your message...',
                  hintStyle: const TextStyle(
                    color: Colors.white54,
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: const Color(0xFF1A1A2E),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: primaryColor,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
            if (_showStopButton)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: ClipOval(
                  child: Material(
                    color: Colors.red,
                    child: InkWell(
                      splashColor: Colors.white,
                      onTap: _stopResponse,
                      child: SizedBox(
                        width: 42,
                        height: 42,
                        child: Icon(
                          Icons.stop,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(width: 8),
            ClipOval(
              child: Material(
                color: primaryColor,
                child: InkWell(
                  splashColor: Colors.white,
                  onTap: _controller.text.isNotEmpty
                      ? () {
                          FocusScope.of(context).unfocus();
                          _sendMessage(_controller.text);
                          _controller.clear();
                        }
                      : _startListening,
                  child: SizedBox(
                    width: 42,
                    height: 42,
                    child: _isSending
                        ? Padding(
                            padding: EdgeInsets.all(10),
                            child: CircularProgressIndicator(
                              strokeWidth: 1.5,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Icon(
                            _controller.text.isNotEmpty
                                ? Icons.send
                                : (_isListening ? Icons.mic : Icons.mic_off),
                            size: 20,
                            color: Colors.white,
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
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
