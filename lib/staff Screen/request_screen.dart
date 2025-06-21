import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_mindmed_project/generated/l10n.dart';
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
  String csrfToken =
      'VMgmCVZKupuWY1Bndrcpbmtu17pxiBa85NrDod8vdqV8rZd3qJpcxcPLYz02dYl9';

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
          'X-CSRFToken': csrfToken,
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

        // Create request items with proper type conversion
        final List<RequestItem> requests =
            bookedAppointments.map((appointment) {
          final appointmentId = appointment['id'] is int
              ? appointment['id']
              : int.tryParse(appointment['id'].toString()) ?? 0;

          final patientId = appointment['patient'] is int
              ? appointment['patient']
              : int.tryParse(appointment['patient'].toString()) ?? 0;

          final doctorId = appointment['doctor'] is int
              ? appointment['doctor']
              : int.tryParse(appointment['doctor'].toString()) ?? 0;

          final services = appointment['services'] is List
              ? List<int>.from(appointment['services']
                  .map((s) => s is int ? s : int.tryParse(s.toString()) ?? 0))
              : <int>[];

          final formattedDate = formatAppointmentDate(appointment['date_time']);

          return RequestItem(
            title: '${S.of(context).appointment} #$appointmentId',
           description: '${S.of(context).appointmentOn} $formattedDate',
            imageUrl:
                'assets/images/woman-choosing-dates-calendar-appointment-booking_23-2148552956.avif',
            status: appointment['status'] ?? 'unknown',
            patientId: patientId,
            doctorId: doctorId,
            services: services,
            onAcceptPressed: () {
              updateAppointmentStatus(
                appointmentId: appointmentId,
                dateTime: appointment['date_time'],
                status: 'confirmed',
                patientId: patientId,
                doctorId: doctorId,
                services: services,
              );
            },
            onRejectPressed: () {
              updateAppointmentStatus(
                appointmentId: appointmentId,
                dateTime: appointment['date_time'],
                status: 'cancelled',
                patientId: patientId,
                doctorId: doctorId,
                services: services,
              );
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

  Future<void> updateAppointmentStatus({
    required int appointmentId,
    required String dateTime,
    required String status,
    required int patientId,
    required int doctorId,
    required List<int> services,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token') ?? '';

      final url =
          Uri.parse('https://abdokh.pythonanywhere.com/api/appointments/');
      final response = await http.put(
        url,
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'X-CSRFToken': csrfToken,
        },
        body: json.encode({
          "id": appointmentId,
          "date_time": dateTime,
          "status": status,
          "cost": "200",
          "notes": "string",
          "appointment_address": "string",
          "is_follow_up": true,
          "is_confirmed": status == 'confirmed',
          "patient": patientId,
          "doctor": doctorId,
          "services": services,
        }),
      );

      if (response.statusCode == 200) {
        print('Appointment updated successfully: ${response.body}');
        final responseData = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Appointment with ${responseData['patient_first_name']} ${responseData['patient_last_name']} updated to $status!",
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
        );
        fetchAppointments(); // Refresh the appointments list
      } else {
        print(
            'Failed to update appointment: ${response.statusCode}, ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Failed to update appointment status",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      print('Error updating appointment: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Error: ${error.toString()}",
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String formatAppointmentDate(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return DateFormat('yyyy-MM-dd – HH:mm').format(dateTime);
    } catch (e) {
      print('Error formatting date: $e');
      return dateTimeString;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = S.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(localizations.appointmentRequests,
            style: TextStyle(color: Colors.white, fontSize: 24)),
        backgroundColor: const Color.fromARGB(255, 3, 190, 150),
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.teal,
            ))
          : userRequests.isEmpty
              ? Center(
                  child: Text(
                    localizations.noAppointmentRequests,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: fetchAppointments,
                  child: ListView.builder(
                    itemCount: userRequests.length,
                    itemBuilder: (context, index) {
                      final request = userRequests[index];

                      return Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: Card(
                          color: Colors.white,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundImage:
                                          AssetImage(request.imageUrl),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            request.title,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blueAccent,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            request.description,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: request.status == 'confirmed'
                                            ? Colors.green
                                            : request.status == 'pending'
                                                ? Colors.orange
                                                : Colors.amber,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        request.status.toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    if (request.onAcceptPressed != null)
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          icon: const Icon(
                                            Icons.check_circle,
                                            color: Colors.white,
                                          ),
                                          label: Text(
                                            localizations.accept,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          onPressed: request.onAcceptPressed,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 3, 190, 150),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    if (request.onRejectPressed != null) ...[
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          icon: const Icon(Icons.cancel,
                                              color: Colors.white),
                                          label: Text(
                                            localizations.reject,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          onPressed: request.onRejectPressed,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
