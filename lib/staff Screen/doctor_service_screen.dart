import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_mindmed_project/core/theme/colors.dart';
import 'package:flutter_mindmed_project/generated/l10n.dart';
import 'package:flutter_mindmed_project/staff%20Screen/service_card.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DoctorServiceScreen extends StatefulWidget {
  const DoctorServiceScreen({super.key});

  @override
  State<DoctorServiceScreen> createState() => _DoctorServiceScreenState();
}

class _DoctorServiceScreenState extends State<DoctorServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  File? _pickedImage;

  List<Map<String, dynamic>> categoryList = [];
  String? selectedCategory;
  String? selectedCategoryId;
  bool _isActive = true;

  Future<void> fetchCategories() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token == null) {
        print('Error: Access token not found in SharedPreferences');
        return;
      }

      final response = await http.get(
        Uri.parse('https://abdokh.pythonanywhere.com/api/categories/'),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token', // Add access token to headers
          'X-CSRFToken':
              'xyBjktUqXib7Qx2J50HY0gaWmKXUASh1cy0Wgi7e1ji1PbE8ZCo2EYCM1kHpUnj8',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          categoryList = data
              .map((category) => {
                    'id': category['id'],
                    'name': category['name'],
                  })
              .toList();
        });
      } else {
        print('Failed to load categories. Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
        throw Exception('Failed to load categories');
      }
    } catch (error) {
      print('Error fetching categories: $error');
    }
  }

  Future<void> pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() {
          _pickedImage = File(image.path);
        });
      }
    } catch (error) {
      print('Error picking image: $error');
    }
  }

  Future<void> postService() async {
    if (!_formKey.currentState!.validate()) {
      print('Error: Form validation failed');
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token == null || selectedCategoryId == null) {
        print('Error: Missing token or category ID');
        throw Exception('Missing token or category ID');
      }

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('https://abdokh.pythonanywhere.com/api/services/'),
      );

      request.headers.addAll({
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
        'X-CSRFToken':
            'tT5ZLT7Ca2sgHQhUB9pc4OsvbcN0hVxrrWlxBM9WvLqvpejoeJRzlcQCxPHQgwnA',
      });

      request.fields.addAll({
        'name': _nameController.text,
        'description': _descriptionController.text,
        'price': _priceController.text,
        'duration': _durationController.text,
        'category': selectedCategoryId!,
        'is_active': _isActive.toString(),
      });

      if (_pickedImage != null) {
        request.files.add(
          await http.MultipartFile.fromPath('image', _pickedImage!.path),
        );
      }

      final response = await request.send();
      final responseString = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Service posted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        _formKey.currentState!.reset();
        setState(() {
          _pickedImage = null;
        });
      } else {
        print('Failed to post service. Status Code: ${response.statusCode}');
        print('Response Body: $responseString');
        throw Exception('Failed to post service: $responseString');
      }
    } catch (error) {
      print('Error posting service: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = S.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          localizations.doctorsSpecialists,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(
            255, 3, 190, 150), // Change the background color
        elevation: 5, // Add shadow
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                // Text Button
                TextButton.icon(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    final doctorDetailsId = prefs.getInt('doctor_details_id');
                    if (doctorDetailsId != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ServiceCardScreen(
                            doctorId: doctorDetailsId,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(localizations.doctorIdNotFound),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  icon: const Icon(
                    Icons.list,
                    size: 30,
                    color: Colors.white,
                  ),
                  label: Text(
                    localizations.viewServices,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Service Name
              _buildInputField(
                controller: _nameController,
                label: localizations.serviceName,
                validator: (value) =>
                    value!.isEmpty ? 'Name is required' : null,
              ),

              // Description
              _buildInputField(
                controller: _descriptionController,
                label: localizations.description,
                validator: (value) =>
                    value!.isEmpty ? 'Description is required' : null,
              ),

              // Price
              _buildInputField(
                controller: _priceController,
                label: localizations.price,
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Price is required' : null,
              ),

              // Duration
              _buildInputField(
                controller: _durationController,
                label: localizations.duration,
                validator: (value) =>
                    value!.isEmpty ? 'Duration is required' : null,
              ),

              // Category dropdown
              _buildDropdown(
                label: localizations.category,
                value: selectedCategory,
                items: categoryList
                    .map((category) => category['name'] as String)
                    .toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedCategory = newValue;
                    selectedCategoryId = categoryList
                        .firstWhere(
                          (category) => category['name'] == newValue,
                          orElse: () => {'id': null},
                        )['id']
                        .toString();
                  });
                },
                validator: (value) =>
                    value == null ? 'Category is required' : null,
              ),

              // Is Active Switch
              Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 2,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Text(
                        '${localizations.isActive}:',
                        style: TextStyle(fontSize: 16),
                      ),
                      const Spacer(),
                      Switch(
                        value: _isActive,
                        onChanged: (value) {
                          setState(() {
                            _isActive = value;
                          });
                        },
                        activeColor: Colors.teal,
                      ),
                    ],
                  ),
                ),
              ),

              // Image picker
              GestureDetector(
                onTap: pickImage,
                child: Card(
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 2,
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: _pickedImage == null
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.image, size: 40, color: Colors.grey),
                                SizedBox(height: 8),
                                Text(localizations.tapToPickImage,
                                    style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(_pickedImage!, fit: BoxFit.cover),
                          ),
                  ),
                ),
              ),

              // Submit Button
              ElevatedButton(
                onPressed: postService,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 3, 190, 150),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: Text(
                  localizations.submitService,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    required String? Function(String?) validator,
  }) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: InputBorder.none,
            labelStyle: TextStyle(color: Colors.grey[600]),
          ),
          keyboardType: keyboardType,
          validator: validator,
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
    required String? Function(String?) validator,
  }) {
    final localizations = S.of(context);
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                // Show the custom dropdown
                _showCustomDropdown(context, items, onChanged);
              },
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[400]!),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      value ?? '${localizations.select} $label',
                      style: TextStyle(
                        color: value == null ? Colors.grey[600] : Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down, color: Colors.grey),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCustomDropdown(
    BuildContext context,
    List<String> items,
    void Function(String?) onChanged,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true, // Allow the bottom sheet to take full height
      builder: (context) {
        final localizations = S.of(context);
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            // padding: const EdgeInsets.all(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${localizations.select} ${localizations.category}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              // Wrap the list of items in a SingleChildScrollView or ListView
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height *
                      0.5, // Limit height to 50% of screen
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: items.map((item) {
                      return ListTile(
                        title: Text(
                          item,
                          style: const TextStyle(fontSize: 16),
                        ),
                        onTap: () {
                          Navigator.pop(context); // Close the bottom sheet
                          onChanged(item); // Update the selected value
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
