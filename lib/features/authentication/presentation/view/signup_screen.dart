import 'dart:convert';
import 'package:flutter_mindmed_project/core/const/user_type_selection.dart';
import 'package:flutter_mindmed_project/generated/l10n.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/colors.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _isPasswordVisible = false;
  bool _isPressed = false;
  bool isPatientSelected = true;
  bool isDoctorSelected = false;
  final ValueNotifier<String?> _selectedGender = ValueNotifier<String?>(null);
  bool _isLoading = false;

  Color _containerColor = primaryColor;

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _genderFocusNode = FocusNode();
  final FocusNode _dateFocusNode = FocusNode();
  final FocusNode _nationalityFocusNode = FocusNode();
  final FocusNode _fluentLanguageFocusNode = FocusNode();
  final FocusNode _currentResidenceFocusNode = FocusNode();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _nationalityController = TextEditingController();
  final TextEditingController _fluentLanguageController =
      TextEditingController();
  final TextEditingController _currentResidenceController =
      TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _genderFocusNode.dispose();
    _dateFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    _phoneController.dispose();
    _dateController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _nationalityController.dispose();
    _fluentLanguageController.dispose();
    _currentResidenceController.dispose();
    _selectedGender.dispose();
    super.dispose();
  }

  Future<void> _validateAndSubmit() async {
    setState(() {
      _isLoading = true;
    });

    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();
    String phone = _phoneController.text.trim();
    String date = _dateController.text.trim();

    if (name.isEmpty) {
      _showErrorToast("Please enter your name");
      return;
    }

    if (email.isEmpty ||
        !RegExp(r"^[a-zA-Z0-9._-]+@[a-zA-Z0-9._-]+\.[a-zA-Z]+")
            .hasMatch(email)) {
      _showErrorToast("Please enter a valid email");
      return;
    }

    if (password.isEmpty || password.length < 6) {
      _showErrorToast("Password must be at least 6 characters");
      return;
    }

    if (confirmPassword.isEmpty || confirmPassword != password) {
      _showErrorToast("Passwords do not match");
      return;
    }

    if (phone.isEmpty || phone.length < 10) {
      _showErrorToast("Please enter a valid phone number");
      return;
    }

    if (date.isEmpty) {
      _showErrorToast("Please enter a valid date");
      return;
    }

    try {
      // First register with Firebase
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // If Firebase registration is successful, proceed with your backend registration
      if (userCredential.user != null) {
        await _registerToBackend(userCredential.user!.uid);
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (e.code == 'weak-password') {
        _showErrorToast('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        _showErrorToast('The account already exists for that email.');
      } else {
        _showErrorToast('Firebase error: ${e.message}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorToast('An error occurred. Please try again.');
    }
  }

  void _showErrorToast(String message) {
    setState(() {
      _isLoading = false;
    });
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  Future<void> _registerToBackend(String firebaseUid) async {
    final url =
        Uri.parse('https://abdokh.pythonanywhere.com/api/register/patient/');

    try {
      // Create a multipart request
      var request = http.MultipartRequest('POST', url);

      // Add headers
      request.headers['accept'] = 'application/json';
      request.headers['X-CSRFToken'] =
          'zQmFjmYkVkVsRqzuTGkw9jf12qiOKT6GCCJEpCyS2JV0CEX51fUcZW4Rt0Yr6zU3';

      // Add form fields including the Firebase UID
      request.fields['username'] = _nameController.text.trim();
      request.fields['first_name'] = _firstNameController.text.trim();
      request.fields['last_name'] = _lastNameController.text.trim();
      request.fields['email'] = _emailController.text.trim();
      request.fields['password'] = _passwordController.text;
      request.fields['password2'] = _confirmPasswordController.text;
      request.fields['phone_number'] = _phoneController.text.trim();
      request.fields['birth_date'] = _dateController.text.trim();
      request.fields['gender'] = _genderController.text.trim();
      request.fields['nationality'] = _nationalityController.text.trim();
      request.fields['fluent_languages'] =
          _fluentLanguageController.text.trim();
      request.fields['current_residence'] =
          _currentResidenceController.text.trim();
      request.fields['firebase_uid'] = firebaseUid;

      // Send the request
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        final responseData = jsonDecode(responseBody);
        print('SUCCESS: Registration successful');
        _showSuccessDialog(context);
      } else {
        // If backend registration fails, delete the Firebase user to maintain consistency
        if (_auth.currentUser != null) {
          await _auth.currentUser!.delete();
        }

        final responseData = jsonDecode(responseBody);
        String errorMessage = 'Registration failed';

        if (responseData is Map) {
          errorMessage +=
              ': ${responseData['error'] ?? responseData['message'] ?? 'Please check your input'}';
        }

        _showErrorToast(errorMessage);
      }
    } catch (error, stackTrace) {
      // If backend registration fails, delete the Firebase user to maintain consistency
      if (_auth.currentUser != null) {
        await _auth.currentUser!.delete();
      }

      print('\n=== EXCEPTION ===');
      print('Error: $error');
      print('Stack Trace: $stackTrace');
      print('================\n');

      _showErrorToast('Network error. Please try again.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _containerColor = Color.fromARGB(255, 91, 255, 219);
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _containerColor = primaryColor;
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
            padding: EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Replace Icon with the GIF
                SizedBox(
                  width: 80,
                  height: 80,
                  child: Image.asset(
                    'assets/images/Logo.png',
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Success!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 0, 255, 8),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "You have successfully signed up.",
                  style: TextStyle(fontSize: 16, color: Colors.green),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed(
                        AppRoutes.signinScreen); // Navigate to SigninScreen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
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
    final localizations = S.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double getWidth(double width) {
      return screenWidth * (width / 392.72727272727275);
    }

    double getHeight(double height) {
      return screenHeight * (height / 777.4545454545455);
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        title:
            Text(localizations.signUp, style: TextStyle(color: primaryColor)),
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
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              UserTypeSelection(
                isPatientSelected: isPatientSelected,
                isDoctorSelected: isDoctorSelected,
                onPatientSelected: (value) {
                  setState(() {
                    isPatientSelected = value;
                    isDoctorSelected = !value;
                  });
                },
                onDoctorSelected: (value) {
                  setState(() {
                    isDoctorSelected = value;
                    isPatientSelected = !value;
                  });
                },
                onPatientSelectedNavigation: () {},
                onDoctorSelectedNavigation: () {
                  Navigator.pushReplacementNamed(
                      context, AppRoutes.DoctorRegistration);
                },
              ),
              SizedBox(height: 20),
              Text(
                localizations.signUp,
                style: TextStyle(
                  fontSize: getWidth(30),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                height: 500,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      _buildTextField(_nameController, _nameFocusNode,
                          localizations.username, Icons.person),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _customTextField(
                            controller: _firstNameController,
                            focusNode: _firstNameFocusNode,
                            labelText: localizations.firstName,
                            icon: Icons.person_outline,
                          ),
                          SizedBox(width: 10),
                          _customTextField(
                            controller: _lastNameController,
                            focusNode: _lastNameFocusNode,
                            labelText: localizations.lastName,
                            icon: Icons.person_outline,
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      _buildTextField(_emailController, _emailFocusNode,
                          localizations.email, Icons.email),
                      SizedBox(height: 20),
                      _buildTextField(_phoneController, _phoneFocusNode,
                          localizations.phone, Icons.phone),
                      SizedBox(height: 20),
                      _buildBirthDateSelection(),
                      SizedBox(height: 20),
                      _buildPasswordField(),
                      SizedBox(height: 20),
                      _buildTextField(
                          _confirmPasswordController,
                          _confirmPasswordFocusNode,
                          localizations.confirmPassword,
                          Icons.lock),
                      SizedBox(height: 20),
                      _buildGenderSelection(),
                      SizedBox(height: 20),
                      _newCustomTextField(
                        controller: _nationalityController,
                        focusNode: _nationalityFocusNode,
                        labelText: localizations.nationality,
                        icon: Icons.flag,
                      ),
                      SizedBox(height: 20),
                      _newCustomTextField(
                        controller: _fluentLanguageController,
                        focusNode: _fluentLanguageFocusNode,
                        labelText: localizations.fluentLanguage,
                        icon: Icons.language,
                      ),
                      SizedBox(height: 20),
                      _newCustomTextField(
                        controller: _currentResidenceController,
                        focusNode: _currentResidenceFocusNode,
                        labelText: localizations.currentResidence,
                        icon: Icons.home,
                      ),
                      SizedBox(height: 20),
                      _isLoading
                          ? CircularProgressIndicator(color: primaryColor)
                          : ElevatedButton(
                              onPressed: _validateAndSubmit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                              ),
                              child: Text(
                                localizations.submit,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, FocusNode focusNode,
      String label, IconData icon) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Theme(
        data: Theme.of(context).copyWith(
          textSelectionTheme: TextSelectionThemeData(
            selectionColor: primaryColor.withOpacity(0.5),
            selectionHandleColor: primaryColor,
          ),
        ),
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          cursorColor: primaryColor,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(
              color: focusNode.hasFocus ? primaryColor : Colors.black,
            ),
            prefixIcon: Icon(
              icon,
              color: focusNode.hasFocus ? primaryColor : Colors.black,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: primaryColor, width: 2.0),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }

  Widget _customTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String labelText,
    required IconData icon,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.39,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        cursorColor: primaryColor,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
            color: focusNode.hasFocus ? primaryColor : Colors.black,
          ),
          prefixIcon: Icon(
            icon,
            color: focusNode.hasFocus ? primaryColor : Colors.black,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: primaryColor, width: 2.0),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    final localizations = S.of(context);
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Theme(
        data: Theme.of(context).copyWith(
          textSelectionTheme: TextSelectionThemeData(
            selectionColor: primaryColor.withOpacity(0.5),
            selectionHandleColor: primaryColor,
          ),
        ),
        child: TextField(
          controller: _passwordController,
          focusNode: _passwordFocusNode,
          obscureText: !_isPasswordVisible,
          cursorColor: primaryColor,
          decoration: InputDecoration(
            labelText: localizations.password,
            labelStyle: TextStyle(
              color: _passwordFocusNode.hasFocus ? primaryColor : Colors.black,
            ),
            prefixIcon: Icon(
              Icons.lock,
              color: _passwordFocusNode.hasFocus ? primaryColor : Colors.black,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: primaryColor, width: 2.0),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: _isPasswordVisible ? primaryColor : Colors.black,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGenderSelection() {
    final localizations = S.of(context);
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: ValueListenableBuilder<String?>(
        valueListenable: _selectedGender,
        builder: (context, selectedGender, _) {
          if (selectedGender != null &&
              _genderController.text != selectedGender) {
            _genderController.text = selectedGender;
          }

          return DropdownButtonFormField<String>(
            value: selectedGender,
            focusNode: _genderFocusNode,
            decoration: InputDecoration(
              labelText: localizations.gender,
              labelStyle: TextStyle(
                color: _genderFocusNode.hasFocus ? primaryColor : Colors.black,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.black,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: primaryColor,
                  width: 2.0,
                ),
              ),
            ),
            items: ['male', 'female', 'other'].map((gender) {
              return DropdownMenuItem<String>(
                value: gender,
                child: Text(
                  gender,
                  style: TextStyle(
                    color:
                        _genderFocusNode.hasFocus ? primaryColor : Colors.black,
                  ),
                ),
              );
            }).toList(),
            onChanged: (value) {
              _selectedGender.value = value;
              _genderController.text = value ?? '';
            },
          );
        },
      ),
    );
  }

  Widget _buildBirthDateSelection() {
    final localizations = S.of(context);
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextField(
        controller: _dateController,
        focusNode: _dateFocusNode,
        readOnly: true,
        decoration: InputDecoration(
          labelText: localizations.birthdate,
          labelStyle: TextStyle(
            color: _dateFocusNode.hasFocus ? primaryColor : Colors.black,
          ),
          prefixIcon: Icon(
            Icons.calendar_month_outlined,
            color: _dateFocusNode.hasFocus ? primaryColor : Colors.black,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: primaryColor,
              width: 2.0,
            ),
          ),
        ),
        style: TextStyle(
          color: _dateFocusNode.hasFocus ? primaryColor : Colors.black,
        ),
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
            builder: (context, child) {
              return Theme(
                data: ThemeData(
                  primaryColor: primaryColor,
                  colorScheme: ColorScheme.light(
                    primary: primaryColor,
                    onPrimary: Colors.white,
                    onSurface: primaryColor,
                  ),
                  dialogBackgroundColor: Colors.white,
                ),
                child: child!,
              );
            },
          );

          if (pickedDate != null) {
            String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
            setState(() {
              _dateController.text = formattedDate;
            });
          }
        },
      ),
    );
  }

  Widget _newCustomTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String labelText,
    required IconData icon,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        cursorColor: primaryColor,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
            color: focusNode.hasFocus ? primaryColor : Colors.black,
          ),
          prefixIcon: Icon(
            icon,
            color: focusNode.hasFocus ? primaryColor : Colors.black,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: primaryColor,
              width: 2.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
