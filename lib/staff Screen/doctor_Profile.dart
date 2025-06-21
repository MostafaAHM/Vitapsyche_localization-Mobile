import 'package:flutter/material.dart';
import 'package:flutter_mindmed_project/generated/l10n.dart';
import 'package:flutter_mindmed_project/staff%20Screen/editDoctorProfileScreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart'; // For picking images
import 'dart:io'; // For handling file paths
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/colors.dart'; // Assuming primaryColor is defined here

class DoctorProfileScreen extends StatefulWidget {
  const DoctorProfileScreen({super.key});

  @override
  _DoctorProfileScreenState createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  bool isUserInfoSelected = true; // To track which text is selected
  Map<String, dynamic> userDetails = {}; // Store user details
  bool isLoading = true; // Track loading state
  File? _image; // Store the selected image file
  final ImagePicker _picker = ImagePicker(); // For picking images

  @override
  void initState() {
    super.initState();
    _fetchUserDetails(); // Fetch user details when the screen loads
    _loadImageFromPrefs(); // Load saved image when the screen loads
  }

  // Fetch user details from the API
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
          'X-CSRFToken':
              'aeuMNSRzr8t8rMuMjsNsAJijbrqIiABvS6CUX1aKx377OvA7TmyMyj4BYxfBv2Tj',
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

        // Print user details and image URL
        print('User Details: $data');
        print('User Image URL: ${data['image']}');

        // Save doctor details ID to SharedPreferences
        if (data['doctor_details'] != null &&
            data['doctor_details']['id'] != null) {
          int doctorDetailsId = data['doctor_details']['id'];
          await prefs.setInt('doctor_details_id', doctorDetailsId);
          print(
              'Doctor Details ID saved to SharedPreferences: $doctorDetailsId');
        }
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

  // Load saved image from SharedPreferences
  Future<void> _loadImageFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString('profile_image');

    if (imagePath != null) {
      setState(() {
        _image = File(imagePath);
      });
    }
  }

  // Save image path to SharedPreferences
  Future<void> _saveImageToPrefs(String imagePath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_image', imagePath);
  }

  // Pick an image from the gallery
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor, // Set the AppBar color
        title: Text(
          localizations.profile,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop(); // Go back to the previous screen
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        height: 300,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(200)),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // GestureDetector(
                                  //   onTap: () {
                                  //     setState(() {
                                  //       isUserInfoSelected = true;
                                  //     });
                                  //   },
                                  //   child: Column(
                                  //     children: [
                                  //       Text(
                                  //         'Doctor Information',
                                  //         style: TextStyle(
                                  //           color: isUserInfoSelected
                                  //               ? const Color.fromARGB(
                                  //                   255, 1, 255, 1)
                                  //               : secoundryColor,
                                  //           fontSize: 18,
                                  //           fontWeight: FontWeight.bold,
                                  //         ),
                                  //       ),
                                  //       if (isUserInfoSelected)
                                  //         Container(
                                  //           margin:
                                  //               const EdgeInsets.only(top: 4),
                                  //           height: 2,
                                  //           width: 150,
                                  //           color: const Color.fromARGB(
                                  //               255, 1, 255, 1),
                                  //         ),
                                  //     ],
                                  //   ),
                                  // ),
                                  // const SizedBox(width: 30),
                                  // GestureDetector(
                                  //   onTap: () {
                                  //     setState(() {
                                  //       isUserInfoSelected = false;
                                  //     });
                                  //   },
                                  //   child: Column(
                                  //     children: [
                                  //       Text(
                                  //         'Payment Information',
                                  //         style: TextStyle(
                                  //           color: !isUserInfoSelected
                                  //               ? const Color.fromARGB(
                                  //                   255, 1, 255, 1)
                                  //               : secoundryColor,
                                  //           fontSize: 18,
                                  //           fontWeight: FontWeight.bold,
                                  //         ),
                                  //       ),
                                  //       if (!isUserInfoSelected)
                                  //         Container(
                                  //           margin:
                                  //               const EdgeInsets.only(top: 4),
                                  //           height: 2,
                                  //           width: 180,
                                  //           color: const Color.fromARGB(
                                  //               255, 1, 255, 1),
                                  //         ),
                                  //     ],
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            // CircleAvatar for the user photo with + icon
                            Padding(
                              padding: const EdgeInsets.only(left: 20, top: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      Stack(
                                        alignment:
                                            AlignmentDirectional.bottomStart,
                                        children: [
                                          CircleAvatar(
                                            radius: 80, // Size of the avatar
                                            backgroundImage: userDetails[
                                                        'image'] !=
                                                    null
                                                ? NetworkImage(
                                                    'https://abdokh.pythonanywhere.com${userDetails['image']}')
                                                : null, // Show nothing if no network image is available
                                            backgroundColor:
                                                primaryColor, // Background color
                                            child: userDetails['image'] == null
                                                ? const Icon(
                                                    Icons
                                                        .person, // Fallback icon if no image is available
                                                    size: 80,
                                                    color: primaryColor,
                                                  )
                                                : null, // No child if the image is available
                                          ),
                                          // Positioned(
                                          //   bottom: 0,
                                          //   right: 0,
                                          //   child: GestureDetector(
                                          //     onTap:
                                          //         _pickImage, // Open image picker
                                          //     child: Container(
                                          //       height: 30,
                                          //       width: 30,
                                          //       decoration: BoxDecoration(
                                          //         color:
                                          //             primaryColor, // Background color of the + icon
                                          //         shape: BoxShape.circle,
                                          //         border: Border.all(
                                          //             color: secoundryColor,
                                          //             width: 2), // White border
                                          //       ),
                                          //       child: const Icon(
                                          //         Icons.add, // + icon
                                          //         color: secoundryColor,
                                          //         size: 20,
                                          //       ),
                                          //     ),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        localizations.doctorPhoto,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                      width:
                                          20), // Space between avatar and user info
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 50),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons
                                                  .person, // Icon next to user name
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
                                            const SizedBox(width: 5),
                                            Text(
                                              userDetails['email'] ??
                                                  localizations
                                                      .userEmail, // User email text
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: primaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Container(
                                          height: 35,
                                          decoration: BoxDecoration(
                                            color:
                                                primaryColor, // Background color of the button
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                              color: Colors
                                                  .white, // White border color
                                              width: 2, // Border width
                                            ),
                                          ),
                                          child: TextButton(
                                            // Inside the DoctorProfileScreen, update the "Edit Info" button's onPressed:
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditDoctorProfileScreen(
                                                    userDetails: userDetails,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              localizations.editInfo,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: secoundryColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        localizations.myProfile,
                        style: TextStyle(
                            fontSize: 30,
                            color: primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            _buildInfoItem(localizations.email, Icons.email,
                                userDetails['email'] ?? 'N/A'),
                            _buildInfoItem(localizations.phone, Icons.phone,
                                userDetails['phone_number'] ?? 'N/A'),
                            _buildInfoItem(
                                localizations.gender,
                                Icons.male_outlined,
                                userDetails['gender'] ?? 'N/A'),
                            _buildInfoItem(localizations.birthDate, Icons.cake,
                                userDetails['birth_date'] ?? 'N/A'),
                            _buildInfoItem(
                                localizations.password, Icons.lock, '********'),
                            if (userDetails['doctor_details'] != null) ...[
                              _buildInfoItem(
                                  localizations.specialization,
                                  Icons.work,
                                  userDetails['doctor_details']
                                          ['specialization'] ??
                                      'N/A'),
                              _buildInfoItem(
                                  localizations.yearOfExperience,
                                  Icons.timeline,
                                  userDetails['doctor_details']
                                              ['years_of_experience']
                                          ?.toString() ??
                                      'N/A'),
                              _buildInfoItem(
                                  localizations.clinicName,
                                  Icons.business,
                                  userDetails['doctor_details']
                                          ['clinic_name'] ??
                                      'N/A'),
                            ],
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // ElevatedButton(
                            //   onPressed: () {
                            //     // Handle change password logic
                            //   },
                            //   style: ElevatedButton.styleFrom(
                            //     side: const BorderSide(
                            //         color: primaryColor,
                            //         width: 2), // Border only
                            //     backgroundColor:
                            //         Colors.white, // Transparent background
                            //     foregroundColor:
                            //         primaryColor, // Icon and text color
                            //     elevation: 0, // No shadow
                            //     shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(50),
                            //     ),
                            //   ),
                            //   child: const Row(
                            //     mainAxisAlignment: MainAxisAlignment.center,
                            //     children: [
                            //       Icon(
                            //         Icons.lock_outline,
                            //         color: primaryColor,
                            //       ),
                            //       SizedBox(width: 8.0),
                            //       Text('Change Password',
                            //           style: TextStyle(
                            //               color: primaryColor,
                            //               fontSize: 14,
                            //               fontWeight: FontWeight.bold)),
                            //     ],
                            //   ),
                            // ),
                            // const SizedBox(width: 0),
                            ElevatedButton(
                              onPressed: _signOut, // Call sign out function
                              style: ElevatedButton.styleFrom(
                                side: const BorderSide(
                                    color: Colors.red, width: 2), // Border only
                                backgroundColor:
                                    Colors.white, // Transparent background
                                foregroundColor:
                                    Colors.red, // Icon and text color
                                elevation: 0, // No shadow
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.logout),
                                  SizedBox(width: 8.0),
                                  Text(localizations.signOut,
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 250),
                    child: Align(
                      alignment: Alignment.bottomRight,
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
            ),
    );
  }

  // Helper method to build info items
  Widget _buildInfoItem(String label, IconData icon, String data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                data,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              Icon(
                icon,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token'); // Remove the access token
    Fluttertoast.showToast(
      backgroundColor: primaryColor,
      msg: S.of(context).logoutSuccess, // Success message
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
    Navigator.of(context).pushReplacementNamed(
        AppRoutes.authentication); // Navigate to SplashScreen
  }
}
