import 'package:flutter/material.dart';
import 'package:flutter_mindmed_project/features/doctor/data/doctor_model.dart';
import 'package:flutter_mindmed_project/features/doctor/presentation/view/doctor_profile_details.dart';
import 'package:flutter_mindmed_project/features/doctor/presentation/widget/doctor_list_item.dart';
import 'package:flutter_mindmed_project/features/home/presentation/doctorService_book_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceDetailsScreen extends StatefulWidget {
  final int serviceId;

  const ServiceDetailsScreen({
    super.key,
    required this.serviceId,
  });

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  Map<String, dynamic>? serviceDetails;
  DoctorModel? doctorDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchServiceDetails();
  }

  Future<void> _fetchServiceDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');

    if (accessToken == null) {
      print('Access token not found. Please log in again.');
      return;
    }

    try {
      // Fetch service details
      final serviceResponse = await http.get(
        Uri.parse(
            'https://abdokh.pythonanywhere.com/api/services/${widget.serviceId}/'),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (serviceResponse.statusCode == 200) {
        final serviceData = json.decode(serviceResponse.body);
        setState(() {
          serviceDetails = serviceData;
        });

        // Fetch doctor details using the doctor ID from the service details
        final doctorId = serviceData['doctor'];
        final doctorResponse = await http.get(
          Uri.parse('https://abdokh.pythonanywhere.com/api/doctor/$doctorId/'),
          headers: {
            'accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        );

        if (doctorResponse.statusCode == 200) {
          final doctorData = json.decode(doctorResponse.body);
          setState(() {
            doctorDetails = DoctorModel.fromJson(doctorData);
            isLoading = false;
          });

          // Print the doctor's image URL and doctor_details ID
          print(
              'Doctor Image URL: https://abdokh.pythonanywhere.com${doctorData['image']}');
          print('Doctor Details ID: ${doctorData['doctor_details']['id']}');
        } else {
          print(
              'Failed to load doctor details. Status Code: ${doctorResponse.statusCode}');
          setState(() {
            isLoading = false;
          });
        }
      } else {
        print(
            'Failed to load service details. Status Code: ${serviceResponse.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching details: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Details'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : serviceDetails == null || doctorDetails == null
              ? const Center(child: Text('Failed to load details.'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Service Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          serviceDetails!['image'] ?? '', // Handle null image
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(Icons.error, color: Colors.red),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Service Name
                      Text(
                        serviceDetails!['name'] ?? 'No Name',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Service Description
                      Text(
                        serviceDetails!['description'] ?? 'No Description',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Service Price
                      Text(
                        'Price: ${serviceDetails!['price'] ?? 'N/A'}',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Service Duration
                      Text(
                        'Duration: ${serviceDetails!['duration'] ?? 'N/A'}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Doctor Details Section
                      const Text(
                        'Doctor Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (doctorDetails != null)
                        DoctorListItem(
                          doctor: doctorDetails!,
                          onProfileView: () {
                            // Navigate to DoctorProfileDetails
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DoctorProfileDetails(
                                  doctorName:
                                      '${doctorDetails!.firstName} ${doctorDetails!.lastName}',
                                  specialty: doctorDetails!
                                      .doctorDetails.specialization,
                                  imagePath: doctorDetails!.image != null
                                      ? 'https://abdokh.pythonanywhere.com${doctorDetails!.image}'
                                      : '',
                                  rating: '4.5', // Placeholder
                                  specification: doctorDetails!
                                      .doctorDetails.specialization,
                                  country: doctorDetails!.nationality,
                                  joiningDate: '2023-01-01', // Placeholder
                                  sessions: doctorDetails!
                                      .doctorDetails.yearsOfExperience
                                      .toString(),
                                  salary: '\$500', // Placeholder
                                  firstCharacter:
                                      doctorDetails!.firstName.substring(0, 1),
                                  doctorDetailsId: doctorDetails!.doctorDetails
                                      .id, // Pass doctor_details ID
                                ),
                              ),
                            );
                          },
                          onBookView: () {
                            // Navigate to DoctorBookingScreen with the required parameters
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DoctorServiceBookingScreen(
                                  doctor: doctorDetails!,
                                  doctorDetailsId:
                                      doctorDetails!.doctorDetails.id,
                                  serviceId: widget.serviceId, // Pass serviceId
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
    );
  }
}
