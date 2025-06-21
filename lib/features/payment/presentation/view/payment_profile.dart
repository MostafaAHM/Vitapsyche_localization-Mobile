import 'dart:convert';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mindmed_project/generated/l10n.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/theme/colors.dart';
import '../../data/data_payment.dart';
import '../widget/payment_method_selection.dart';

class PaymentProfile extends StatefulWidget {
  const PaymentProfile({super.key});

  @override
  State<PaymentProfile> createState() => _PaymentProfileState();
}

class _PaymentProfileState extends State<PaymentProfile> {
  String selectedPayment = 'VitaPsyche Wallet';

  File? _image;
  final ImagePicker _picker = ImagePicker();
  Map<String, dynamic> userDetails = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails(); // Fetch user details when the screen loads
    _loadImageFromPrefs(); // Load saved image when the screen loads
  }

  Future<void> _loadImageFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString('profile_image');

    if (imagePath != null) {
      setState(() {
        _image = File(imagePath);
      });
    }
  }

  Future<void> _fetchUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');

    if (accessToken == null) {
      print('Access token not found. Please log in again.');
      setState(() {
        isLoading = false;
      });
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

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          userDetails = data;
          isLoading = false;
        });
      } else {
        print(
            'Failed to load user details. Status Code: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching user details: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _saveImageToPrefs(String imagePath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_image', imagePath);
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      // Save the image path to SharedPreferences
      await _saveImageToPrefs(pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = S.of(context);
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: grayColor,
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Stack(
                              alignment: AlignmentDirectional.bottomStart,
                              children: [
                                Container(
                                  width: 160, // custom width
                                  height: 160, // custom height
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: primaryColor,
                                  ),
                                  child: ClipOval(
                                    child: _image != null
                                        ? Image.file(
                                            _image!,
                                            fit: BoxFit.cover,
                                            width: 160,
                                            height: 160,
                                          )
                                        : const Icon(Icons.person_2_sharp,
                                            size: 140, color: secoundryColor),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: _pickImage, // Open image picker
                                    child: Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                        color:
                                            primaryColor, // Background color of the + icon
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: secoundryColor,
                                            width: 2), // White border
                                      ),
                                      child: const Icon(
                                        Icons.add, // + icon
                                        color: secoundryColor,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              localizations.addPhoto,
                              style: TextStyle(
                                fontSize: 16,
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                            width: 20), // Space between avatar and user info
                        Padding(
                          padding: const EdgeInsets.only(bottom: 50),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.person, // Icon next to user name
                                    color: primaryColor,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    userDetails['username'] ??
                                        localizations
                                            .userName, // User name text
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.email, // Email icon
                                    color: primaryColor,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    userDetails['email'] ??
                                        localizations
                                            .userEmail, // User email text
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Container(
                    height: 400,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          PaymentMethodSelectionWidget(
                            paymentMethods: paymentMethods,
                            selectedPayment: selectedPayment,
                            onPaymentSelected: (value) {
                              setState(() {
                                selectedPayment = value;
                              });
                            },
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              elevation: 2,
                              backgroundColor: primaryColor,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 72, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              localizations.continueText,
                              style: TextStyle(
                                  color: secoundryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 21),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
  // Dummy user details for demonstration