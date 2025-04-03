import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class RequestItem {
  final String title;
  final String description;
  final String imageUrl;
  final String status;
  final int patientId;
  final int doctorId;
  final List<int> services;
  final VoidCallback? onAcceptPressed;
  final VoidCallback? onRejectPressed;

  RequestItem({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.status,
    required this.patientId,
    required this.doctorId,
    required this.services,
    this.onAcceptPressed,
    this.onRejectPressed,
  });
}

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  List<RequestItem> userRequests = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAppointments();
  }

  Future<void> fetchAppointments() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token') ?? '';
      final doctorDetailsId = prefs.getInt('doctor_details_id');

      if (doctorDetailsId == null) {
        throw Exception('Doctor Details ID not found in SharedPreferences');
      }

      final url = Uri.parse(
          'https://abdokh.pythonanywhere.com/api/appointments/?doctor_id=$doctorDetailsId');
      final response = await http.get(
        url,
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token',
          'X-CSRFToken':
              'va4JTfgGtNMQaLoG74oy7aD6od550NDGHInh2FtLmX2SuMdFoOIwFibk2Jk8wXGX',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        // Filter appointments with status "booked"
        final bookedAppointments = data
            .where((appointment) => appointment['status'] == 'booked')
            .toList();

        // Sort appointments by date (newest first)
        bookedAppointments.sort((a, b) {
          final DateTime dateA = DateTime.parse(a['date_time']);
          final DateTime dateB = DateTime.parse(b['date_time']);
          return dateB.compareTo(dateA);
        });

        // Create request items
        final List<RequestItem> requests =
            bookedAppointments.map((appointment) {
          final appointmentId = appointment['id'];
          final formattedDate = formatAppointmentDate(appointment['date_time']);

          return RequestItem(
            title: 'Appointment #${appointment['id']}',
            description: 'Appointment on $formattedDate',
            imageUrl:
                'assets/images/woman-choosing-dates-calendar-appointment-booking_23-2148552956.avif', // Replace with your image
            status: appointment['status'],
            patientId: appointment['patient'],
            doctorId: appointment['doctor'],
            services: List<int>.from(appointment['services']),
            onAcceptPressed: () {
              updateAppointmentStatus(appointmentId, 'confirmed');
            },
            onRejectPressed: () {
              updateAppointmentStatus(appointmentId, 'cancelled');
            },
          );
        }).toList();

        setState(() {
          userRequests = requests;
          isLoading = false;
        });
      } else {
        print('Failed to load appointments: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      print('Error fetching appointments: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updateAppointmentStatus(int appointmentId, String status) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token') ?? '';

      // Find the appointment to update
      final appointment = userRequests.firstWhere(
        (request) => request.title == 'Appointment #$appointmentId',
        orElse: () => throw Exception('Appointment not found'),
      );

      final url = Uri.parse(
          'https://abdokh.pythonanywhere.com/api/appointments/$appointmentId/');
      final response = await http.put(
        url,
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'X-CSRFToken':
              'va4JTfgGtNMQaLoG74oy7aD6od550NDGHInh2FtLmX2SuMdFoOIwFibk2Jk8wXGX',
        },
        body: json.encode({
          "date_time":
              "2025-02-27T17:16:14.717636Z", // Replace with actual date time
          "cost": "300", // Replace with actual cost
          "notes": "string", // Replace with actual notes
          "appointment_address": "string", // Replace with actual address
          "is_follow_up": true, // Replace with actual value
          "patient": appointment.patientId,
          "doctor": appointment.doctorId,
          "services": [],
          "status": status,
        }),
      );

      if (response.statusCode == 200) {
        print('Appointment updated successfully: ${response.body}');
        fetchAppointments(); // Refresh the appointments list
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Appointment status updated to $status!",
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        print(
            'Failed to update appointment: ${response.statusCode}, ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Failed to update appointment status",
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      print('Error updating appointment: $error');
    }
  }

  String formatAppointmentDate(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return DateFormat('yyyy-MM-dd').format(dateTime);
    } catch (e) {
      print('Error formatting date: $e');
      return dateTimeString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Request Screen',
            style: TextStyle(color: Colors.white, fontSize: 24)),
        backgroundColor: const Color.fromARGB(255, 3, 190, 150),
        elevation: 0,
        automaticallyImplyLeading: false, // This removes the back arrow
        centerTitle: true, // This centers the title
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.teal,
            ))
          : userRequests.isEmpty
              ? const Center(child: Text('No appointments found'))
              : ListView.builder(
                  itemCount: userRequests.length,
                  itemBuilder: (context, index) {
                    final request = userRequests[index];

                    return GestureDetector(
                      onTap: () {
                        // You can navigate to a detailed screen if necessary
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16), // Reduced margins
                        child: Card(
                          color: Colors.white,
                          elevation: 4, // Reduced elevation for a flatter look
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              // Image Section with Circular Design and Shadow
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    request.imageUrl,
                                    height: 80,
                                    width: 80,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              // Content Section with details
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Title and Status Section in a Row
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            request.title,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.blueAccent,
                                            ),
                                            softWrap: true,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: request.status == 'confirmed'
                                                ? Colors.green
                                                : request.status == 'pending'
                                                    ? Colors.orange
                                                    : Colors.amber,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            request.status,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    // Description Section
                                    Text(
                                      request.description,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Action Buttons (Accept/Reject)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (request.onAcceptPressed != null)
                                      ElevatedButton.icon(
                                        icon: const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                        ),
                                        label: const Text(
                                          'Accept',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        onPressed: request.onAcceptPressed,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              255, 3, 190, 150),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 24,
                                            vertical: 12,
                                          ),
                                        ),
                                      ),
                                    const SizedBox(width: 12),
                                    if (request.onRejectPressed != null)
                                      ElevatedButton.icon(
                                        icon: const Icon(Icons.close,
                                            color: Colors.white),
                                        label: const Text(
                                          'Reject',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        onPressed: request.onRejectPressed,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 24,
                                            vertical: 12,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
