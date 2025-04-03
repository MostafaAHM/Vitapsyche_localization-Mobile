import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For Clipboard
import 'package:flutter_mindmed_project/core/theme/colors.dart';
import 'package:flutter_mindmed_project/features/ai_service/service/lina/data/questions_and_answers.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:share_plus/share_plus.dart'; // Updated share package
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class LynaModel extends StatefulWidget {
  const LynaModel({super.key, required this.title});

  static const String id = 'LynaScreen';

  final String title;

  @override
  State<LynaModel> createState() => _LynaModelState();
}

class _LynaModelState extends State<LynaModel>
    with SingleTickerProviderStateMixin {
  late stt.SpeechToText _speechToText;
  late FlutterTts _flutterTts;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation; // Scaling animation

  bool _isListening = false;
  String _userInput = '';
  String _response = '';
  String _displayedResponse = '';
  bool _showResponse = false;
  final TextEditingController _textController = TextEditingController();
  String _selectedLanguage = 'en'; // Default language is English
  String _currentModel =
      'assets/LinaModel/Linaaanimation.gltf'; // Initial model

  // List of model paths
  final List<String> _modelPaths = [
    'assets/LinaModel/Linaaanimation.gltf',
    'assets/LinaModel/Linaaanimation.gltf',
    // Add more model paths here
  ];

  // Cache for preloaded models
  final Map<String, Widget> _modelCache = {};

  @override
  void initState() {
    super.initState();
    _speechToText = stt.SpeechToText();
    _flutterTts = FlutterTts();
    _initializeTts();
    _speakWelcomeMessage();

    // Initialize the animation controller for scaling effect
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // Animation duration
    );

    // Define the scaling animation
    _scaleAnimation = Tween<double>(begin: 2, end: 2.5).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut, // Smooth easing curve
      ),
    );

    // Keep the model scaled after animation completes
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Stop the animation at the scaled position
        _animationController.stop();
      }
    });

    // Preload all models into cache
    _preloadModels();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Preload all models into cache
  void _preloadModels() {
    for (var modelPath in _modelPaths) {
      _modelCache[modelPath] = _buildModelViewer(modelPath);
    }
  }

  // Helper method to build a ModelViewer widget
  Widget _buildModelViewer(String modelPath) {
    return ModelViewer(
      src: modelPath,
      alt: 'Lina 3D Model',
      ar: false,
      autoRotate: false,
      cameraControls: false,
      scale: '3 14 9',
      cameraOrbit: '90deg 90deg 0%',
      autoPlay: true, // Enable autoplay
      animationName: 'Idle',
    );
  }

  Future<void> _initializeTts() async {
    try {
      await _flutterTts
          .setLanguage(_selectedLanguage == 'en' ? "en-US" : "ar-SA");
      await _flutterTts.setPitch(0.6);
      await _flutterTts.setSpeechRate(0.5);
    } catch (e) {
      print("TTS Initialization Error: $e");
    }
  }

  Future<void> _speakWelcomeMessage() async {
    try {
      await _flutterTts.setLanguage("en-US"); // Set language
      await _flutterTts.speak(
          "Hi, I am Lina. I am here to help you at any time. Let's get started.");
    } catch (e) {
      print("TTS Speak Error: $e");
    }
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
              _userInput = result.recognizedWords;
              _textController.text = _userInput;
            });
          },
          localeId: _selectedLanguage == 'en' ? "en_US" : "ar_SA",
        );
      } else {
        setState(() => _isListening = false);
        _showSnackBar("Speech recognition not available.");
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

  void _startScaling() {
    setState(() {
      _animationController.forward(); // Start the scaling animation
    });
  }

  Future<void> _generateResponse() async {
    _startScaling(); // Trigger the scaling effect
    try {
      String matchedResponse =
          "Sorry, I don't have an answer for that."; // Default response

      // Declare and initialize the variable for the highest match score
      int highestMatchScore = 0;

      // Preprocess user input
      List<String> userInputWords = _preprocessInput(_userInput);

      for (var qa in qaData) {
        // Preprocess the question
        List<String> questionWords = _preprocessInput(qa['question']!);

        // Calculate the number of matching words
        int matchScore =
            userInputWords.where((word) => questionWords.contains(word)).length;

        // Update the response if this question has a higher match score
        if (matchScore > highestMatchScore) {
          highestMatchScore = matchScore;
          matchedResponse = qa['answer']!;
        }
      }

      setState(() {
        _response = matchedResponse;
        _showResponse = true;
        _displayedResponse = '';
        _currentModel = _modelPaths[1]; // Switch to the second model
      });

      _animateResponseText();
      await _speakResponse();
    } catch (e) {
      print("Error generating response: $e");
    }
  }

  List<String> _preprocessInput(String input) {
    String cleanedInput =
        input.replaceAll(RegExp(r'[?.,!;]'), '').toLowerCase();
    Set<String> ignoreWords = {
      'what',
      'how',
      'when',
      'where',
      'why',
      'who',
      'is',
      'are',
      'am',
      'he',
      'she',
      'they',
      'i',
      'we',
      'you',
      'it',
      'a',
      'an',
      'the',
      'of',
      'and',
      'or',
      'to',
      'in',
      'on',
      'with',
      'tell',
      'me',
      'about'
    };
    return cleanedInput
        .split(' ')
        .where((word) => !ignoreWords.contains(word) && word.isNotEmpty)
        .toList();
  }

  void _animateResponseText() {
    int index = 0;
    Timer.periodic(const Duration(milliseconds: 50), (Timer timer) {
      if (index < _response.length) {
        setState(() {
          _displayedResponse += _response[index];
          index++;
        });
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _speakResponse() async {
    try {
      await _flutterTts
          .setLanguage(_selectedLanguage == 'en' ? "en-US" : "ar-SA");
      await _flutterTts.speak(_response);
    } catch (e) {
      print("TTS Speak Error: $e");
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showResponseMenu(BuildContext context) {
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(100, 100, 100, 100),
      items: [
        const PopupMenuItem<String>(
          value: 'Option 1',
          child: Text('Copy Response'),
        ),
        const PopupMenuItem<String>(
          value: 'Option 2',
          child: Text('Share Response'),
        ),
      ],
    ).then((value) {
      if (value != null) {
        // Handle the selected option
        switch (value) {
          case 'Option 1':
            // Copy the response to the clipboard
            Clipboard.setData(ClipboardData(text: _displayedResponse));
            _showSnackBar("Response copied to clipboard!");
            break;
          case 'Option 2':
            // Share the response
            _shareResponse();
            break;
          default:
            break;
        }
      }
    });
  }

  Future<void> _shareResponse() async {
    try {
      await Share.share(_displayedResponse); // Use Share.share from share_plus
    } catch (e) {
      print("Error sharing response: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the keyboard height
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      body: Stack(
        children: [
          // AnimatedSwitcher for model transition
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500), // Animation duration
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            child: Container(
              key: ValueKey<String>(_currentModel), // Unique key for each model
              padding: const EdgeInsets.only(bottom: 160, right: 60),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: _modelCache[_currentModel] ??
                    _buildModelViewer(_currentModel),
              ),
            ),
          ),

          // Response Text
          if (_showResponse)
            Positioned(
              right: MediaQuery.of(context).size.width * 0.01,
              bottom: keyboardHeight > 0
                  ? keyboardHeight +
                      0 // Add extra spacing when keyboard is open
                  : MediaQuery.of(context).size.height *
                      0.6, // Default position
              child: AnimatedOpacity(
                opacity: _showResponse ? 1.0 : 0.0,
                duration: const Duration(seconds: 3),
                child: GestureDetector(
                  onTap: () => _showResponseMenu(context),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight:
                          200, // Set the maximum height for the container
                      minHeight: 50, // Set the minimum height for the container
                    ),
                    child: Container(
                      width: 150,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: primaryColor, width: 1),
                      ),
                      child: SingleChildScrollView(
                        child: Text(
                          _displayedResponse,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 5.0,
                                color: Colors.black,
                                offset: Offset(2.0, 2.0),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // Input Section
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: EdgeInsets.only(
                left: 12,
                right: 12,
                top: 12,
                bottom: keyboardHeight > 0 ? 8 : 12, // Adjust bottom padding
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 15,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildLanguageSelector(),
                  const SizedBox(height: 5),
                  _buildTextInputField(),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildMicButton(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Language: "),
        DropdownButton<String>(
          value: _selectedLanguage,
          items: const [
            DropdownMenuItem(value: 'en', child: Text("English")),
            DropdownMenuItem(value: 'ar', child: Text("Arabic")),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedLanguage = value;
                _initializeTts();
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildTextInputField() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: _textController,
        onChanged: (value) {
          _userInput = value;
        },
        decoration: InputDecoration(
          hintText: "Type your input or use the mic...",
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          suffixIcon: IconButton(
            icon: Icon(Icons.send, color: primaryColor),
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                _userInput = _textController.text;
                _startScaling(); // Trigger scaling effect
                _generateResponse();
              } else {
                _showSnackBar("Please enter some text or use the mic.");
              }
            },
          ),
        ),
        style: TextStyle(
          color: Colors.blueGrey[900],
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildMicButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: IconButton(
        onPressed: _isListening ? _stopListening : _startListening,
        icon: Icon(
          _isListening ? Icons.mic : Icons.mic_off,
          color: Colors.white,
        ),
        iconSize: 30,
      ),
    );
  }
}
