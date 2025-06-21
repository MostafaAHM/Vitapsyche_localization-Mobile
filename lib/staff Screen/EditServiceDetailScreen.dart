import 'package:flutter/material.dart';
import 'package:flutter_mindmed_project/core/theme/colors.dart';
import 'package:flutter_mindmed_project/generated/l10n.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditServiceDetailScreen extends StatefulWidget {
  final int serviceId;
  final int doctorId;

  const EditServiceDetailScreen({
    super.key,
    required this.serviceId,
    required this.doctorId,
  });

  @override
  State<EditServiceDetailScreen> createState() =>
      _EditServiceDetailScreenState();
}

class _EditServiceDetailScreenState extends State<EditServiceDetailScreen> {
  Map<String, dynamic> serviceDetails = {};
  bool isLoading = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  bool _isActive = true;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _fetchServiceDetails();
  }

  Future<void> _fetchServiceDetails() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token == null) {
        print('Error: Access token not found in SharedPreferences');
        return;
      }

      final response = await http.get(
        Uri.parse(
            'https://abdokh.pythonanywhere.com/api/services/${widget.serviceId}/'),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token',
          'X-CSRFToken':
              'va4JTfgGtNMQaLoG74oy7aD6od550NDGHInh2FtLmX2SuMdFoOIwFibk2Jk8wXGX',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          serviceDetails = data;
          _nameController.text = data['name'];
          _descriptionController.text = data['description'] ?? '';
          _priceController.text = data['price'].toString();
          _durationController.text = data['duration'].toString();
          _categoryController.text = data['category'].toString();
          _isActive = data['is_active'];
          isLoading = false;
        });
      } else {
        print(
            'Failed to load service details. Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
        throw Exception('Failed to load service details');
      }
    } catch (error) {
      print('Error fetching service details: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _updateService() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token == null) {
        print('Error: Access token not found in SharedPreferences');
        return;
      }

      var request = http.MultipartRequest(
        'PUT',
        Uri.parse(
            'https://abdokh.pythonanywhere.com/api/services/${widget.serviceId}/'),
      );

      request.headers['accept'] = 'application/json';
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['X-CSRFToken'] =
          'va4JTfgGtNMQaLoG74oy7aD6od550NDGHInh2FtLmX2SuMdFoOIwFibk2Jk8wXGX';

      request.fields['name'] = _nameController.text;
      request.fields['description'] = _descriptionController.text;
      request.fields['price'] = _priceController.text;
      request.fields['duration'] = _durationController.text;
      request.fields['doctor'] = widget.doctorId.toString();
      request.fields['category'] = _categoryController.text;
      request.fields['is_active'] = _isActive.toString();

      if (_imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            _imageFile!.path,
          ),
        );
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Service updated successfully')),
        );
      } else {
        print('Failed to update service. Status Code: ${response.statusCode}');
        print('Response Body: ${await response.stream.bytesToString()}');
        throw Exception('Failed to update service');
      }
    } catch (error) {
      print('Error updating service: $error');
    }
  }

  Future<void> _deleteService() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token == null) {
        print('Error: Access token not found in SharedPreferences');
        return;
      }

      final response = await http.delete(
        Uri.parse(
            'https://abdokh.pythonanywhere.com/api/services/${widget.serviceId}/'),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token',
          'X-CSRFToken':
              'va4JTfgGtNMQaLoG74oy7aD6od550NDGHInh2FtLmX2SuMdFoOIwFibk2Jk8wXGX',
        },
      );

      if (response.statusCode == 204) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Service deleted successfully')),
        );
        Navigator.pop(context);
      } else {
        print('Failed to delete service. Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
        throw Exception('Failed to delete service');
      }
    } catch (error) {
      print('Error deleting service: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
     final localizations = S.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.editService),
        backgroundColor: Colors.white, // Use primary color
        actions: [
          IconButton(
            icon: const Icon(
              Icons.delete,
              color: primaryColor,
              size: 30,
            ),
            onPressed: _deleteService,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Image Picker
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: _imageFile != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  _imageFile!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : serviceDetails['image'] != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      serviceDetails['image'],
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Icon(
                                    Icons.camera_alt,
                                    size: 50,
                                    color: primaryColor,
                                  ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Name Field
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText:  localizations.name,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primaryColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return localizations.pleaseEnterName;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Description Field
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText:  localizations.description,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primaryColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 20),
                    // Price Field
                    TextFormField(
                      controller: _priceController,
                      decoration: InputDecoration(
                        labelText: localizations.price,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primaryColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return localizations.pleaseEnterPrice;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Duration Field
                    TextFormField(
                      controller: _durationController,
                      decoration: InputDecoration(
                        labelText: localizations.duration,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primaryColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return  localizations.pleaseEnterDuration;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Category Field
                    TextFormField(
                      controller: _categoryController,
                      decoration: InputDecoration(
                        labelText: localizations.category,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primaryColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return localizations.pleaseEnterCategory;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Is Active Switch
                    Card(
                      color: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: SwitchListTile(
                        title: Text(
                         localizations.isActive,
                          style: TextStyle(color: primaryColor),
                        ),
                        value: _isActive,
                        onChanged: (value) {
                          setState(() {
                            _isActive = value;
                          });
                        },
                        activeColor: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Update Button
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _updateService();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: primaryColor,
                      ),
                      child:  Text(
                        localizations.updateService,
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
