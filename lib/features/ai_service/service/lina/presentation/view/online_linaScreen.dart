import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For Clipboard
import 'package:flutter_mindmed_project/core/theme/colors.dart';
import 'package:flutter_mindmed_project/generated/l10n.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:share_plus/share_plus.dart'; // Updated share package
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:http/http.dart' as http; // For making HTTP requests
import 'package:shimmer/shimmer.dart'; // For shimmer effect

class OnlineLynaModel extends StatefulWidget {
  const OnlineLynaModel({super.key, required this.title});

  static const String id = 'LynaScreen';

  final String title;

  @override
  State<OnlineLynaModel> createState() => _OnlineLynaModelState();
}

class _OnlineLynaModelState extends State<OnlineLynaModel>
    with SingleTickerProviderStateMixin {
  late stt.SpeechToText _speechToText;
  late FlutterTts _flutterTts;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation; // Scaling animation
  late ScrollController
      _scrollController; // ScrollController for auto-scrolling

  bool _isListening = false;
  bool _isLoading = false; // Track loading state
  String _userInput = '';
  String _response = '';
  String _displayedResponse = '';
  bool _showResponse = false;
  final TextEditingController _textController = TextEditingController();
  String _selectedLanguage = 'en'; // Default language is English
  double _pitch = 1.0; // Default pitch value (1.0 is normal pitch)
  bool _isModelLoading = true; // Track model loading state

  // Single model path
  final String _modelPath = 'assets/LinaModel/Linaaanimation.gltf';

  // Timer for text animation
  Timer? _textAnimationTimer;
  bool _isTextAnimating = false;
  bool _isTtsSpeaking = false;

  @override
  void initState() {
    super.initState();
    _speechToText = stt.SpeechToText();
    _flutterTts = FlutterTts();
    _scrollController = ScrollController(); // Initialize ScrollController
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

    // Simulate model loading with a delay
    _simulateModelLoading();
  }

  // Simulate model loading with a delay
  void _simulateModelLoading() async {
    await Future.delayed(
        const Duration(seconds: 3)); // Simulate 3 seconds loading
    setState(() {
      _isModelLoading = false; // Mark model as loaded
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _textAnimationTimer?.cancel();
    _flutterTts.stop();
    _scrollController.dispose(); // Dispose ScrollController
    super.dispose();
  }

  // Helper method to build a ModelViewer widget
  Widget _buildModelViewer() {
    return ModelViewer(
      src: _modelPath,
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
      // Set the TTS engine to Google TTS (if available)
      await _flutterTts.setEngine("com.google.android.tts");

      // Set the language based on the selected language
      await _flutterTts
          .setLanguage(_selectedLanguage == 'en' ? "en-US" : "ar-SA");
      await _flutterTts.setPitch(_pitch); // Use current pitch value
      await _flutterTts.setSpeechRate(0.32); // Adjust speech rate
      print(
          "TTS Initialized with language: ${_selectedLanguage == 'en' ? 'English' : 'Arabic'} and pitch: $_pitch");
    } catch (e) {
      print("TTS Initialization Error: $e");
    }
  }

  Future<void> _updateTtsPitch(double newPitch) async {
    try {
      await _flutterTts.setPitch(newPitch); // Update pitch
      print("TTS Pitch updated to: $newPitch");
    } catch (e) {
      print("Error updating TTS pitch: $e");
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
    } catch (e, stackTrace) {
      print('I/flutter ( 9092): Speech Recognition Error: $e');
      print('I/flutter ( 9092): Stack trace: $stackTrace');
      _showSnackBar("Error starting speech recognition. Please try again.");
    }
  }

  Future<void> _stopListening() async {
    try {
      setState(() => _isListening = false);
      await _speechToText.stop();
    } catch (e, stackTrace) {
      print('I/flutter ( 9092): Error stopping listening: $e');
      print('I/flutter ( 9092): Stack trace: $stackTrace');
      _showSnackBar("Error stopping speech recognition. Please try again.");
    }
  }

  void _startScaling() {
    setState(() {
      _animationController.forward(); // Start the scaling animation
    });
  }

  Future<void> _generateResponse() async {
    _startScaling(); // Trigger the scaling effect
    setState(() {
      _isLoading = true; // Start loading
    });

    try {
      final response = await _callDeepSeekApi(_userInput);

      setState(() {
        _response = response;
        _showResponse = true;
        _displayedResponse = '';
      });

      _animateResponseText();
      await _speakResponse();
    } catch (e, stackTrace) {
      // Print detailed error message and stack trace
      print('I/flutter ( 9092): Error generating response: $e');
      print('I/flutter ( 9092): Stack trace: $stackTrace');
      _showSnackBar("Error generating response. Please try again.");
    } finally {
      setState(() {
        _isLoading = false; // Stop loading
      });
    }
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
        final data = jsonDecode(
            utf8.decode(response.bodyBytes)); // Ensure UTF-8 decoding
        return data['choices'][0]['message']['content'];
      } else {
        // Print the API response body for debugging
        print('I/flutter ( 9092): API Error Response: ${response.body}');
        throw Exception(
            'Failed to load response from DeepSeek API. Status code: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      // Print detailed error message and stack trace
      print('I/flutter ( 9092): API Call Error: $e');
      print('I/flutter ( 9092): Stack trace: $stackTrace');
      rethrow; // Rethrow the error to be caught by the caller
    }
  }

  void _animateResponseText() {
    int index = 0;
    _isTextAnimating = true;
    _textAnimationTimer?.cancel();
    _textAnimationTimer =
        Timer.periodic(const Duration(milliseconds: 50), (Timer timer) {
      if (index < _response.length && _isTextAnimating) {
        setState(() {
          _displayedResponse += _response[index];
          index++;
        });

        // Scroll to the bottom after updating the text
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController
                .jumpTo(_scrollController.position.maxScrollExtent);
          }
        });
      } else {
        timer.cancel();
        _isTextAnimating = false;
      }
    });
  }

  // Helper method to remove symbols from the response for TTS
  String _cleanResponseForTts(String response) {
    // Define a list of symbols to remove or replace
    final symbolsToRemove = [
      '*',
      '_',
      '-',
      '~',
      '`',
      '^',
      '#',
      '|',
      '\\',
      '/',
      '=',
      '+',
      '<',
      '>',
      '{',
      '}',
      '[',
      ']',
      '(',
      ')',
      '!',
      '@',
      '\$',
      '%',
      '&',
      ';',
      ':',
      '"',
      "'",
      ',',
      '.',
      '?',
    ];

    // Remove or replace symbols
    String cleanedResponse = response;
    for (var symbol in symbolsToRemove) {
      cleanedResponse = cleanedResponse.replaceAll(symbol, ' ');
    }

    // Remove extra spaces
    // cleanedResponse = cleanedResponse.replaceAll(RegExp(r'\s+'), ' ').trim();

    return cleanedResponse;
  }

  Future<void> _speakResponse() async {
    try {
      setState(() {
        _isTtsSpeaking = true;
      });

      // Clean the response for TTS
      final cleanedResponse = _cleanResponseForTts(_response);

      // Set TTS language dynamically based on selected language
      await _flutterTts
          .setLanguage(_selectedLanguage == 'en' ? "en-US" : "ar-SA");
      await _flutterTts.setPitch(_pitch); // Use current pitch value
      await _flutterTts.speak(cleanedResponse);
    } catch (e, stackTrace) {
      print('I/flutter ( 9092): TTS Speak Error: $e');
      print('I/flutter ( 9092): Stack trace: $stackTrace');
      _showSnackBar("Error speaking the response. Please try again.");
    } finally {
      setState(() {
        _isTtsSpeaking = false;
      });
    }
  }

  void _stopTtsAndTextAnimation() {
    _flutterTts.stop();
    _textAnimationTimer?.cancel();
    setState(() {
      _isTtsSpeaking = false;
      _isTextAnimating = false;
    });
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
      backgroundColor: Colors.grey,
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
              key: ValueKey<String>(_modelPath), // Unique key for the model
              padding: const EdgeInsets.only(bottom: 160, right: 60),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: _isModelLoading
                    ? _buildShimmerEffect() // Show shimmer while loading
                    : _buildModelViewer(),
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
                        controller: _scrollController, // Add ScrollController
                        child: Directionality(
                          textDirection: _selectedLanguage == 'ar'
                              ? TextDirection.rtl
                              : TextDirection.ltr,
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
                  _buildPitchControlSlider(), // Add pitch control slider
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

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
      ),
    );
  }

  Widget _buildLanguageSelector() {
    final localizations = S.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("${localizations.languages}: "),
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
    final localizations = S.of(context);
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
          hintText: localizations.typeYourMessage,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
              vertical: 20, horizontal: 20), // Increased vertical padding
          suffixIcon: Container(
            padding:
                const EdgeInsets.only(right: 8), // Padding for the suffix icons
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Stop Icon (Conditional)
                if (_isTtsSpeaking || _isTextAnimating)
                  Container(
                    width: 40, // Fixed width for the stop icon container
                    height: 40, // Fixed height for the stop icon container
                    decoration: BoxDecoration(
                      color:
                          Colors.red.withOpacity(0.2), // Light red background
                      shape: BoxShape.circle, // Circular shape
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.stop,
                          color: Colors.red, size: 20), // Smaller icon size
                      onPressed: _stopTtsAndTextAnimation,
                      padding: EdgeInsets.zero, // Remove default padding
                    ),
                  ),
                const SizedBox(width: 8), // Spacing between icons
                // Send Icon
                Container(
                  width: 40, // Fixed width for the send icon container
                  height: 40, // Fixed height for the send icon container
                  decoration: BoxDecoration(
                    color: primaryColor
                        .withOpacity(0.2), // Light primary color background
                    shape: BoxShape.circle, // Circular shape
                  ),
                  child: IconButton(
                    icon: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: primaryColor,
                              strokeWidth: 2,
                            ),
                          )
                        : Icon(Icons.send,
                            color: primaryColor, size: 20), // Smaller icon size
                    onPressed: () {
                      if (_textController.text.isNotEmpty) {
                        _userInput = _textController.text;
                        _startScaling(); // Trigger scaling effect
                        _generateResponse();
                      } else {
                        _showSnackBar(localizations.pleaseEnterSomeText);
                      }
                    },
                    padding: EdgeInsets.zero, // Remove default padding
                  ),
                ),
              ],
            ),
          ),
        ),
        style: TextStyle(
          color: Colors.blueGrey[900],
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildPitchControlSlider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const Text("Pitch Control"),
          // Slider(
          //   value: _pitch,
          //   min: 0.5, // Minimum pitch value
          //   max: 2.0, // Maximum pitch value
          //   divisions: 10, // Number of steps
          //   label: _pitch.toStringAsFixed(1), // Display current pitch
          //   onChanged: (newPitch) {
          //     setState(() {
          //       _pitch = newPitch; // Update pitch value
          //     });
          //     _updateTtsPitch(newPitch); // Update TTS pitch
          //   },
          // ),
        ],
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
