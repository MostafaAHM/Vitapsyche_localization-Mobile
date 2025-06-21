import 'package:flutter/material.dart';
import 'package:flutter_mindmed_project/generated/l10n.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/colors.dart';

class ProfileDetails extends StatefulWidget {
  const ProfileDetails({super.key});

  @override
  _ProfileDetailsState createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  bool isUserInfoSelected = true;
  Map<String, dynamic> userDetails = {};
  bool isLoading = true;
  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
    _loadImageFromPrefs();
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

  Future<void> _loadImageFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString('profile_image');

    if (imagePath != null) {
      setState(() {
        _image = File(imagePath);
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
      await _saveImageToPrefs(pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = S.of(context)!;
    final bool isRTL = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Column(
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 20),
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
                                        width: 160,
                                        height: 160,
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
                                              : Icon(Icons.person_2_sharp,
                                                  size: 140,
                                                  color: secoundryColor),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: GestureDetector(
                                          onTap: _pickImage,
                                          child: Container(
                                            height: 30,
                                            width: 30,
                                            decoration: BoxDecoration(
                                              color: primaryColor,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: secoundryColor,
                                                  width: 2),
                                            ),
                                            child: const Icon(
                                              Icons.add,
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
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 20),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 50),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.person,
                                          color: primaryColor,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          userDetails['username'] ??
                                              localizations.userName,
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
                                          Icons.email,
                                          color: primaryColor,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          userDetails['email'] ??
                                              localizations.userEmail,
                                          style: const TextStyle(
                                              fontSize: 14,
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
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      localizations.myProfile,
                      style: const TextStyle(
                          fontSize: 30,
                          color: primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                    Container(
                      height: 380,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  _buildInfoItem(
                                      localizations.name,
                                      Icons.person,
                                      userDetails['username'] ??
                                          localizations.notAvailable),
                                  _buildInfoItem(
                                      localizations.email,
                                      Icons.email,
                                      userDetails['email'] ??
                                          localizations.notAvailable),
                                  _buildInfoItem(
                                      localizations.phone,
                                      Icons.phone,
                                      userDetails['phone_number'] ??
                                          localizations.notAvailable),
                                  _buildInfoItem(
                                      localizations.gender,
                                      Icons.male_outlined,
                                      userDetails['gender'] ??
                                          localizations.notAvailable),
                                  _buildInfoItem(
                                      localizations.birthday,
                                      Icons.cake,
                                      userDetails['birth_date'] ??
                                          localizations.notAvailable),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: _signOut,
                                    style: ElevatedButton.styleFrom(
                                      side: const BorderSide(
                                          color: Colors.red, width: 2),
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.red,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.logout,
                                          color: Colors.red,
                                        ),
                                        const SizedBox(width: 8.0),
                                        Text(localizations.signOut,
                                            style: const TextStyle(
                                                color: Colors.red,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 150),
                  child: Align(
                    alignment: isRTL ? Alignment.topLeft : Alignment.topRight,
                    child: Image.asset(
                      'assets/animation/profile.gif',
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildInfoItem(String label, IconData icon, String data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: textMainColor),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3)),
            ],
            border: Border.all(
              color: secoundryColor,
              width: 2,
            ),
            color: secoundryColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                data,
                style: const TextStyle(
                  color: grayColor,
                  fontSize: 18,
                ),
              ),
              Icon(
                icon,
                color: grayColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    Fluttertoast.showToast(
      backgroundColor: primaryColor,
      msg: S.of(context).logoutSuccess,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
    Navigator.of(context).pushReplacementNamed(AppRoutes.authentication);
  }
}
