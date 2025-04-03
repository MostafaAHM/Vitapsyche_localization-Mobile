import 'package:flutter/material.dart';
import 'package:flutter_mindmed_project/core/const/user_type_selection.dart';
import 'package:flutter_mindmed_project/generated/l10n.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/colors.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  bool _isPasswordVisible = false;
  bool _isPressed = false;
  bool _isLoading = false;

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isEmailFocused = false;
  bool _isPasswordFocused = false;

  Color _containerColor = primaryColor;

  @override
  void initState() {
    super.initState();

    _emailFocusNode.addListener(() {
      setState(() {
        _isEmailFocused = _emailFocusNode.hasFocus;
        _isPasswordFocused = _passwordFocusNode.hasFocus;
      });
    });

    _passwordFocusNode.addListener(() {
      setState(() {
        _isEmailFocused = _emailFocusNode.hasFocus;
        _isPasswordFocused = _passwordFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateAndSignIn() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (email.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please enter your email",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } else if (!_isValidEmail(email)) {
      Fluttertoast.showToast(
        msg: "Please enter a valid email",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } else if (password.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please enter your password",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } else if (password.length < 6) {
      Fluttertoast.showToast(
        msg: "Password must be at least 6 characters",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } else {
      setState(() {
        _isLoading = true;
      });

      try {
        final response = await http.post(
          Uri.parse('https://abdokh.pythonanywhere.com/api/login/'),
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'X-CSRFToken':
                'BVHx8z9HbsuwhOzIWALCnyrojC8vNdD6QvwE0kOBq9UwW4jxsHIin0eXU12DLKK7',
          },
          body: jsonEncode({
            'email': email,
            'password': password,
          }),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          Fluttertoast.showToast(
            msg: data['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );

          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('access_token', data['access_token']);

          print("Access Token: ${data['access_token']}");
          print(response.statusCode);
          print(response.body);

          // Fetch user details using the access token
          await _fetchUserDetails(data['access_token']);
        } else {
          Fluttertoast.showToast(
            msg: "Login failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        }
      } catch (e) {
        Fluttertoast.showToast(
          msg: "An error occurred",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _fetchUserDetails(String accessToken) async {
    try {
      final response = await http.get(
        Uri.parse('https://abdokh.pythonanywhere.com/api/user/details/'),
        headers: {
          'accept': 'application/json',
          'X-CSRFToken':
              'H7ozWH7ioICIk51WrSdzgHrd9b64ozy6v1wmJBrSo6V8EcxmbYwICxFLosEzK5od',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final userDetails = jsonDecode(response.body);
        final role = userDetails['role'];

        SharedPreferences prefs = await SharedPreferences.getInstance();

        if (role == 'patient') {
          // Save patient_details.id in SharedPreferences
          final patientDetailsId = userDetails['patient_details']['id'];
          await prefs.setInt('patient_details_id', patientDetailsId);
          print("Patient Details ID: $patientDetailsId");

          // Navigate to the patient screen
          Navigator.of(context)
              .pushReplacementNamed(AppRoutes.mainNavigationScreen);
        } else if (role == 'doctor') {
          // Save doctor_details.id in SharedPreferences
          final doctorDetailsId = userDetails['doctor_details']['id'];
          await prefs.setInt('doctor_details_id', doctorDetailsId);
          print("Doctor Details ID: $doctorDetailsId");

          // Navigate to the doctor screen
          Navigator.of(context).pushReplacementNamed(AppRoutes.StaffScreen);
        } else {
          Fluttertoast.showToast(
            msg: "Unknown role",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: "Failed to fetch user details",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "An error occurred while fetching user details",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  bool _isValidEmail(String email) {
    // Basic email regex for validation
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return regex.hasMatch(email);
  }

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _containerColor =
          const Color.fromARGB(255, 91, 255, 219); // Change color when pressed
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _containerColor = primaryColor; // Revert color when released
    });
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevent closing the dialog by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 16,
          child: Container(
            padding: const EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Replace Icon with the GIF
                SizedBox(
                  width: 80,
                  height: 80,
                  child: Image.asset(
                    'assets/animation/Animation - 1726443797305 (1).gif',
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Success!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 255, 8),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "You have successfully signed in.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.green,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'OK',
                    style: TextStyle(color: secoundryColor),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = S.of(context); // Renamed from S to localizations
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: primaryColor),
              onPressed: () => Navigator.of(context).pop(),
            ),
            backgroundColor: Colors.white,
            title: Text(localizations.signIn,
                style: TextStyle(color: primaryColor)),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Image.asset(
                  'assets/images/Logo.png',
                  width: 50,
                  height: 50,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    // Top Section with Image and Back Button
                    Stack(
                      children: [
                        SizedBox(
                          height: 30,
                        ),

                        // Positioned(
                        //   right: 0.1,
                        //   child: Image.asset(
                        //     'assets/animation/Animation - 1725391690653.gif',
                        //     width: screenWidth * 0.3, // Reduced size
                        //     height: screenWidth * 0.3, // Reduced size
                        //     fit: BoxFit.contain,
                        //   ),
                        // ),

                        // Positioned(
                        //   top: 30,
                        //   child: GestureDetector(
                        //     onTap: () {
                        //       Navigator.of(context)
                        //           .pushNamed(AppRoutes.authentication);
                        //     },
                        //     onTapDown: _onTapDown,
                        //     onTapUp: _onTapUp,
                        //     child: Container(
                        //       height: 50,
                        //       decoration: BoxDecoration(
                        //         shape: BoxShape.circle,
                        //         color: _containerColor,
                        //       ),
                        //       padding: const EdgeInsets.only(left: 10),
                        //       child: const Icon(
                        //         Icons.arrow_back,
                        //         color: Colors.white,
                        //         size: 28,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),

                    // User Type Selection
                    Padding(
                      padding: EdgeInsets.only(top: screenHeight * 0.05),
                      child: UserTypeSelection(
                        isPatientSelected: false,
                        isDoctorSelected: false,
                        onPatientSelected: (value) {
                          setState(() {
                            // Handle patient selection
                          });
                        },
                        onDoctorSelected: (value) {
                          setState(() {
                            // Handle doctor selection
                          });
                        },
                        onPatientSelectedNavigation: () {
                          // Navigator.pushReplacementNamed(
                          //     context, AppRoutes.signupScreen);
                        },
                        onDoctorSelectedNavigation: () {
                          // Navigator.pushReplacementNamed(
                          //     context, AppRoutes.DoctorRegistration);
                        },
                      ),
                    ),

                    SizedBox(
                      height: 30,
                    ),

                    // Sign In Section
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                      child: Column(
                        children: [
                          Text(
                            localizations.signIn,
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 30),

                          // Email Field
                          TextField(
                            controller: _emailController,
                            focusNode: _emailFocusNode,
                            cursorColor: primaryColor,
                            decoration: InputDecoration(
                              labelText: localizations.email,
                              labelStyle: TextStyle(
                                color: _isEmailFocused
                                    ? primaryColor
                                    : Colors.black,
                              ),
                              prefixIcon: Icon(
                                Icons.email,
                                color: _isEmailFocused
                                    ? primaryColor
                                    : Colors.black,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Colors.grey, width: 2.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: primaryColor, width: 2.0),
                              ),
                              filled: true,
                              fillColor: secoundryColor.withOpacity(0.8),
                            ),
                          ),
                          const SizedBox(height: 25),

                          // Password Field
                          TextField(
                            controller: _passwordController,
                            focusNode: _passwordFocusNode,
                            obscureText: !_isPasswordVisible,
                            cursorColor: primaryColor,
                            decoration: InputDecoration(
                              labelText: localizations.password,
                              labelStyle: TextStyle(
                                color: _isPasswordFocused
                                    ? primaryColor
                                    : Colors.black,
                              ),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: _isPasswordFocused
                                    ? primaryColor
                                    : Colors.black,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: _isPasswordVisible
                                      ? primaryColor
                                      : Colors.black,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Colors.grey, width: 2.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: primaryColor, width: 2.0),
                              ),
                              filled: true,
                              fillColor: secoundryColor.withOpacity(0.8),
                            ),
                          ),
                          const SizedBox(height: 25),

                          // Sign In Button
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _validateAndSignIn,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                elevation: 5,
                                shadowColor: Colors.black,
                              ).copyWith(
                                overlayColor:
                                    MaterialStateProperty.resolveWith<Color?>(
                                  (Set<MaterialState> states) {
                                    if (states
                                        .contains(MaterialState.pressed)) {
                                      return const Color.fromARGB(
                                          255, 91, 255, 219);
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              child: Text(
                                localizations.signIn,
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Sign Up Prompt
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                localizations.signIntext,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTapDown: (_) {
                                  setState(() {
                                    _isPressed = true;
                                  });
                                },
                                onTapUp: (_) {
                                  setState(() {
                                    _isPressed = false;
                                  });
                                  Navigator.of(context)
                                      .pushNamed(AppRoutes.signupScreen);
                                },
                                child: Text(
                                  localizations.signIn,
                                  style: TextStyle(
                                    color:
                                        _isPressed ? primaryColor : Colors.red,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Loading Indicator
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                  ),
                ),
            ],
          ),
        ));
  }
}
