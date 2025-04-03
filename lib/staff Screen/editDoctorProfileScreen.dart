import 'package:flutter/material.dart';
import 'package:flutter_mindmed_project/core/theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart'; // For picking images
import 'dart:io'; // For handling file paths

class EditDoctorProfileScreen extends StatefulWidget {
  final Map<String, dynamic> userDetails;

  const EditDoctorProfileScreen({super.key, required this.userDetails});

  @override
  _EditDoctorProfileScreenState createState() =>
      _EditDoctorProfileScreenState();
}

class _EditDoctorProfileScreenState extends State<EditDoctorProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _birthDateController;
  late TextEditingController _genderController;
  late TextEditingController _nationalityController;
  late TextEditingController _currentResidenceController;
  late TextEditingController _fluentLanguagesController;
  late TextEditingController _doctorEmailController;
  late TextEditingController _specializationController;
  late TextEditingController _yearsOfExperienceController;
  late TextEditingController _clinicNameController;

  File? _image; // Store the selected image file
  final ImagePicker _picker = ImagePicker(); // For picking images
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current user details
    _usernameController =
        TextEditingController(text: widget.userDetails['username']);
    _firstNameController =
        TextEditingController(text: widget.userDetails['first_name']);
    _lastNameController =
        TextEditingController(text: widget.userDetails['last_name']);
    _emailController = TextEditingController(text: widget.userDetails['email']);
    _phoneNumberController =
        TextEditingController(text: widget.userDetails['phone_number']);
    _birthDateController =
        TextEditingController(text: widget.userDetails['birth_date']);
    _genderController =
        TextEditingController(text: widget.userDetails['gender']);
    _nationalityController =
        TextEditingController(text: widget.userDetails['nationality']);
    _currentResidenceController =
        TextEditingController(text: widget.userDetails['current_residence']);
    _fluentLanguagesController =
        TextEditingController(text: widget.userDetails['fluent_languages']);
    _doctorEmailController = TextEditingController(
        text: widget.userDetails['doctor_details']['email']);
    _specializationController = TextEditingController(
        text: widget.userDetails['doctor_details']['specialization']);
    _yearsOfExperienceController = TextEditingController(
        text: widget.userDetails['doctor_details']['years_of_experience']
            ?.toString());
    _clinicNameController = TextEditingController(
        text: widget.userDetails['doctor_details']['clinic_name']);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _birthDateController.dispose();
    _genderController.dispose();
    _nationalityController.dispose();
    _currentResidenceController.dispose();
    _fluentLanguagesController.dispose();
    _doctorEmailController.dispose();
    _specializationController.dispose();
    _yearsOfExperienceController.dispose();
    _clinicNameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');
    int? doctorDetailsId = prefs.getInt('doctor_details_id');

    if (accessToken == null || doctorDetailsId == null) {
      print('Access token or doctor details ID not found.');
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      // Create a multipart request
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse(
            'https://abdokh.pythonanywhere.com/api/doctor/$doctorDetailsId/'),
      );

      // Add headers
      request.headers['accept'] = 'application/json';
      request.headers['Authorization'] = 'Bearer $accessToken';
      request.headers['X-CSRFToken'] =
          '9YjRNEF19Xc7GtSgcb4sd9Uw523sYmLQgmtUh1rOTo8XTUT0OAan2WMsyPBFrzU0';

      // Add fields
      request.fields['username'] = _usernameController.text;
      request.fields['first_name'] = _firstNameController.text;
      request.fields['last_name'] = _lastNameController.text;
      request.fields['email'] = _emailController.text;
      request.fields['phone_number'] = _phoneNumberController.text;
      request.fields['birth_date'] = _birthDateController.text;
      request.fields['gender'] = _genderController.text;
      request.fields['nationality'] = _nationalityController.text;
      request.fields['current_residence'] = _currentResidenceController.text;
      request.fields['fluent_languages'] = _fluentLanguagesController.text;
      request.fields['doctor_details[email]'] = _doctorEmailController.text;
      request.fields['doctor_details[specialization]'] =
          _specializationController.text;
      request.fields['doctor_details[years_of_experience]'] =
          _yearsOfExperienceController.text;
      request.fields['doctor_details[clinic_name]'] =
          _clinicNameController.text;
      request.fields['doctor_details[availability_for_sessions]'] = 'true';

      // Add image file if selected
      if (_image != null) {
        request.files
            .add(await http.MultipartFile.fromPath('image', _image!.path));
      }

      // Send the request
      final response = await request.send();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
        Navigator.of(context).pop(true); // Go back to the profile screen
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Failed to update profile: ${response.reasonPhrase}')),
        );
      }
    } catch (e) {
      print('Error updating profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again.')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor, // Set the AppBar color
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop(); // Go back to the previous screen
          },
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        height: 200,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(200)),
                        ),
                        child: Column(
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
                                        alignment:
                                            AlignmentDirectional.bottomStart,
                                        children: [
                                          CircleAvatar(
                                            radius: 60, // Size of the avatar
                                            backgroundImage: _image != null
                                                ? FileImage(_image!)
                                                : widget.userDetails['image'] !=
                                                        null
                                                    ? NetworkImage(
                                                        'https://abdokh.pythonanywhere.com${widget.userDetails['image']}')
                                                    : null, // Show nothing if no network image is available
                                            backgroundColor: Colors
                                                .white, // Background color
                                            child: _image == null &&
                                                    widget.userDetails[
                                                            'image'] ==
                                                        null
                                                ? const Icon(
                                                    Icons
                                                        .person, // Fallback icon if no image is available
                                                    size: 60,
                                                    color: primaryColor,
                                                  )
                                                : null, // No child if the image is available
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            right: 0,
                                            child: GestureDetector(
                                              onTap:
                                                  _pickImage, // Open image picker
                                              child: Container(
                                                height: 30,
                                                width: 30,
                                                decoration: BoxDecoration(
                                                  color:
                                                      primaryColor, // Background color of the + icon
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      color: Colors.white,
                                                      width: 2), // White border
                                                ),
                                                child: const Icon(
                                                  Icons.add, // + icon
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      const Text(
                                        'Doctor Photo',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
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
                                              color: Colors.white,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              widget.userDetails['username'] ??
                                                  'User Name', // User name text
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.email, // Email icon
                                              color: Colors.white,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              widget.userDetails['email'] ??
                                                  'user@example.com', // User email text
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.white,
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
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              _buildEditField('Username', _usernameController),
                              _buildEditField(
                                  'First Name', _firstNameController),
                              _buildEditField('Last Name', _lastNameController),
                              _buildEditField('Email', _emailController),
                              _buildEditField(
                                  'Phone Number', _phoneNumberController),
                              _buildEditField(
                                  'Birth Date', _birthDateController),
                              _buildEditField('Gender', _genderController),
                              _buildEditField(
                                  'Nationality', _nationalityController),
                              _buildEditField('Current Residence',
                                  _currentResidenceController),
                              _buildEditField('Fluent Languages',
                                  _fluentLanguagesController),
                              _buildEditField(
                                  'Doctor Email', _doctorEmailController),
                              _buildEditField(
                                  'Specialization', _specializationController),
                              _buildEditField('Years of Experience',
                                  _yearsOfExperienceController),
                              _buildEditField(
                                  'Clinic Name', _clinicNameController),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: _updateProfile,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50, vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: const Text(
                                  'Save Changes',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildEditField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }
}
