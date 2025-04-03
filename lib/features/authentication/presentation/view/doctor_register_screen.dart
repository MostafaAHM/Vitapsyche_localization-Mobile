import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mindmed_project/core/const/user_type_selection.dart';
import 'package:flutter_mindmed_project/core/routes/app_routes.dart';
import 'package:flutter_mindmed_project/core/theme/colors.dart';
import 'package:flutter_mindmed_project/features/authentication/data/doctor_registation_sevice.dart';
import 'package:flutter_mindmed_project/generated/l10n.dart';
import 'package:intl/intl.dart';
import 'package:country_picker/country_picker.dart';
import 'package:file_picker/file_picker.dart';

class DoctorRegistrationScreen extends StatefulWidget {
  const DoctorRegistrationScreen({super.key});

  @override
  State<DoctorRegistrationScreen> createState() =>
      _DoctorRegistrationScreenState();
}

class _DoctorRegistrationScreenState extends State<DoctorRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _prefixController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _institutionController = TextEditingController();
  final TextEditingController _graduationYearController =
      TextEditingController();
  final TextEditingController _yearsOfExperienceController =
      TextEditingController();
  final TextEditingController _licenseNumberController =
      TextEditingController();
  final TextEditingController _clinicNameController = TextEditingController();
  final TextEditingController _cvController = TextEditingController();
  final TextEditingController _qualificationsController =
      TextEditingController();

  String _selectedCountryCode = "+20";
  String? _selectedGender;
  String? _selectedDegree;
  String? _selectedNationality;
  String? _selectedCategory;
  String? _selectedSpecialization;

  final List<String> categories = [
    'Clinical Psychologist',
    'Counseling Psychologist',
    'Psychiatrist'
  ];
  final List<String> specializations = [
    'Child Psychology',
    'Adult Psychology',
    'Family Therapy'
  ];
  final List<String> degrees = ["Bachelor's", "Master's", "Doctorate"];
  bool _isAvailableForSessions = false;
  bool _hasMultipleQualifications = false;

  bool isPatientSelected = false;
  bool isDoctorSelected = true;

  File? _cvFile;
  File? _qualificationsFile;
  File? _profileImage;

  int _currentStep = 0;
  bool _isLoading = false; // Track loading state

  void _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _selectCountry() {
    showCountryPicker(
      context: context,
      onSelect: (Country country) {
        setState(() {
          _selectedCountryCode = "+${country.phoneCode}";
        });
      },
    );
  }

  void _pickFile(String field) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      setState(() {
        if (field == 'CV') {
          _cvFile = File(result.files.single.path!);
          _cvController.text = _cvFile!.path.split('/').last;
        } else if (field == 'Qualifications') {
          _qualificationsFile = File(result.files.single.path!);
          _qualificationsController.text =
              _qualificationsFile!.path.split('/').last;
        } else if (field == 'Profile Image') {
          _profileImage = File(result.files.single.path!);
        }
      });
    }
  }

  Widget _buildFileUploadField({
    required String label,
    required String? fileName,
    required VoidCallback onTap,
  }) {
    final localizations = S.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey),
        ),
        child: ListTile(
          title: Text(label),
          subtitle: Text(fileName ?? localizations.noFileSelected),
          trailing: const Icon(CupertinoIcons.paperclip),
        ),
      ),
    );
  }

  List<Widget> _buildStep1Fields() {
    final localizations = S.of(context);
    return [
      _buildTextField(_firstNameController, localizations.firstName,
          validator: _validateRequired),
      _buildTextField(_lastNameController, localizations.lastName,
          validator: _validateRequired),
      _buildTextField(_fullNameController, localizations.fullName,
          validator: _validateRequired),
      _buildTextField(_usernameController, localizations.username,
          validator: _validateRequired),
      _buildTextField(_passwordController, localizations.password,
          obscureText: true, validator: _validatePassword),
      _buildTextField(_confirmPasswordController, localizations.confirmPassword,
          obscureText: true, validator: _validateConfirmPassword),
      _buildTextField(_emailController, localizations.email,
          keyboardType: TextInputType.emailAddress, validator: _validateEmail),
      _buildDropdownField(localizations.gender, ["male", "female"],
          (value) => setState(() => _selectedGender = value), _selectedGender,
          validator: _validateRequired),
      _buildTextField(_prefixController, localizations.prefix),
      _buildDatePickerField(_dobController, localizations.birthdate,
          validator: _validateRequired),
      Row(
        children: [
          GestureDetector(
            onTap: _selectCountry,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(_selectedCountryCode),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildTextField(_phoneController, localizations.phone,
                keyboardType: TextInputType.phone, validator: _validatePhone),
          ),
        ],
      ),
      DropdownButtonFormField<String>(
        value: _selectedNationality,
        items: ["Egyptian", "American", "Indian"]
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (value) {
          setState(() {
            _selectedNationality = value;
          });
        },
        decoration: InputDecoration(labelText: localizations.nationality),
      ),
    ];
  }

  List<Widget> _buildStep2Fields() {
    final localizations = S.of(context);
    return [
      _buildTextField(_institutionController, localizations.institution,
          validator: _validateRequired),
      _buildDropdownField(localizations.degree, degrees,
          (value) => setState(() => _selectedDegree = value), _selectedDegree),
      _buildTextField(_graduationYearController, localizations.graduationYear,
          keyboardType: TextInputType.number, validator: _validateRequired),
      _buildTextField(
          _yearsOfExperienceController, localizations.yearOfExperience,
          keyboardType: TextInputType.number, validator: _validateRequired),
      _buildTextField(_licenseNumberController, localizations.licenseNumber,
          validator: _validateRequired),
      _buildDropdownField(
          localizations.category,
          categories,
          (value) => setState(() => _selectedCategory = value),
          _selectedCategory),
      _buildDropdownField(
          localizations.specialization,
          specializations,
          (value) => setState(() => _selectedSpecialization = value),
          _selectedSpecialization),
      _buildTextField(_clinicNameController, localizations.clinicName,
          validator: _validateRequired),
    ];
  }

  List<Widget> _buildStep3Fields() {
    final localizations = S.of(context);
    return [
      _buildFileUploadField(
        label: localizations.uploadCV,
        fileName: _cvController.text.isEmpty
            ? null
            : _cvController.text.split('/').last,
        onTap: () => _pickFile('CV'),
      ),
      _buildFileUploadField(
        label: localizations.uploadQualifications,
        fileName: _qualificationsController.text.isEmpty
            ? null
            : _qualificationsController.text.split('/').last,
        onTap: () => _pickFile('Qualifications'),
      ),
      _buildFileUploadField(
        label: localizations.uploadProfileImage,
        fileName:
            _profileImage == null ? null : _profileImage!.path.split('/').last,
        onTap: () => _pickFile('Profile Image'),
      ),
      SwitchListTile(
          title: Text(localizations.availableForSessions),
          value: _isAvailableForSessions,
          onChanged: (value) =>
              setState(() => _isAvailableForSessions = value)),
      SwitchListTile(
          title: Text(localizations.multipleQualifications),
          value: _hasMultipleQualifications,
          onChanged: (value) =>
              setState(() => _hasMultipleQualifications = value)),
    ];
  }

  //*validation
  String? _validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    final phoneRegex = RegExp(r'^\d{6,15}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = S.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.doctorRegistration),
        // automaticallyImplyLeading: false,
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
      body: SingleChildScrollView(
        child: Container(
          child: Form(
            key: _formKey,
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
                  onPatientSelectedNavigation: () {
                    Navigator.pushReplacementNamed(
                        context, AppRoutes.signupScreen);
                  },
                  onDoctorSelectedNavigation: () {
                    // No need to navigate, already on the DoctorRegistrationScreen
                  },
                ),
                Container(
                  height: 600,
                  child: Stepper(
                    currentStep: _currentStep,
                    onStepContinue: () {
                      if (_currentStep < 2) {
                        setState(() {
                          _currentStep += 1;
                        });
                      } else {
                        _submitForm();
                      }
                    },
                    onStepCancel: () {
                      if (_currentStep > 0) {
                        setState(() {
                          _currentStep -= 1;
                        });
                      }
                    },
                    steps: [
                      Step(
                        title: Text(localizations.personalInformation),
                        content: SingleChildScrollView(
                          child: Column(children: _buildStep1Fields()),
                        ),
                        isActive: _currentStep >= 0,
                        state: _currentStep > 0
                            ? StepState.complete
                            : StepState.indexed,
                      ),
                      Step(
                        title: Text(localizations.professionalInformation),
                        content: SingleChildScrollView(
                          child: Column(children: _buildStep2Fields()),
                        ),
                        isActive: _currentStep >= 1,
                        state: _currentStep > 1
                            ? StepState.complete
                            : StepState.indexed,
                      ),
                      Step(
                        title: Text(localizations.documentsPreferences),
                        content: SingleChildScrollView(
                          child: Column(children: _buildStep3Fields()),
                        ),
                        isActive: _currentStep >= 2,
                        state: _currentStep > 2
                            ? StepState.complete
                            : StepState.indexed,
                      ),
                    ],
                    controlsBuilder:
                        (BuildContext context, ControlsDetails details) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Row(
                          children: [
                            if (_currentStep != 0)
                              TextButton(
                                onPressed: details.onStepCancel,
                                child: Text(
                                  localizations.back,
                                  style: TextStyle(color: primaryColor),
                                ),
                              ),
                            const Spacer(),
                            ElevatedButton(
                              onPressed:
                                  _isLoading ? null : details.onStepContinue,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      _currentStep == 2
                                          ? localizations.submit
                                          : localizations.next,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                            ),
                          ],
                        ),
                      );
                    },
                    connectorColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        return primaryColor;
                      },
                    ),
                    connectorThickness: 2.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField(
    String label,
    List<String> items,
    ValueChanged<String?> onChanged,
    String? value, {
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
          ),
        ),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
        validator: validator ?? _validateRequired,
      ),
    );
  }

  Widget _buildDatePickerField(
    TextEditingController controller,
    String label, {
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
          ),
        ),
        onTap: _selectDate,
        validator: validator ?? _validateRequired,
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Start loading
      });

      Map<String, dynamic> doctorData = {
        "username": _usernameController.text,
        "first_name": _firstNameController.text,
        "last_name": _lastNameController.text,
        "full_name_arabic": _fullNameController.text,
        "email": _emailController.text,
        "password": _passwordController.text,
        "password2": _confirmPasswordController.text,
        "phone_number": _selectedCountryCode + _phoneController.text,
        "birth_date": _dobController.text,
        "gender": _selectedGender,
        "specialization": _selectedSpecialization,
        "prefix": _prefixController.text,
        "nationality": _selectedNationality,
        "fluent_languages": ["en", "ar"],
        "current_residence": "null",
        "availability_for_sessions": _isAvailableForSessions,
        "graduation_year": _graduationYearController.text,
        "years_of_experience": _yearsOfExperienceController.text,
        "clinic_name": _clinicNameController.text,
      };

      Api api = Api();
      var response =
          await api.registerDoctor(doctorData, _profileImage, _cvFile);

      setState(() {
        _isLoading = false; // Stop loading
      });

      if (response.containsKey('error')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['error'])),
        );
      } else {
        _showSuccessDialog(context);
      }
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
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
                Image.asset(
                  'assets/images/Logo.png', // Add your logo image
                  width: 80,
                  height: 80,
                ),
                SizedBox(height: 20),
                Text(
                  "Success!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "You have successfully signed up.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.green,
                  ),
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
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
