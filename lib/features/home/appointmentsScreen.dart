import 'package:flutter/material.dart';
import 'package:flutter_mindmed_project/core/routes/app_routes.dart';
import 'package:flutter_mindmed_project/core/theme/colors.dart';
import 'package:flutter_mindmed_project/generated/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  String selectedStatus = 'booked'; // Default status
  List<dynamic> allAppointments = []; // To hold all appointments
  bool isLoading = true; // Show loading spinner during API call
  String errorMessage = ''; // To hold error messages
  String? accessToken; // Variable to hold the access token
  Map<int, String> doctorImages = {};

  @override
  void initState() {
    super.initState();
    fetchAppointments(); // Fetch appointments when the screen loads
  }

  Future<String?> fetchDoctorImage(int doctorId) async {
    if (doctorImages.containsKey(doctorId)) {
      return doctorImages[doctorId];
    }

    try {
      final response = await http.get(
        Uri.parse('https://abdokh.pythonanywhere.com/api/doctors/$doctorId/'),
        headers: {
          'accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final imagePath = data['image']?.toString();
        if (imagePath != null && imagePath.isNotEmpty) {
          final fullImageUrl = 'https://abdokh.pythonanywhere.com$imagePath';
          setState(() {
            doctorImages[doctorId] = fullImageUrl;
          });
          return fullImageUrl;
        }
      }
    } catch (error) {
      print('Error fetching doctor image: $error');
    }
    return null;
  }

  // Fetch appointments based on patient_details_id
  Future<void> fetchAppointments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString('access_token');

    if (accessToken == null) {
      setState(() {
        isLoading = false;
        errorMessage = S.of(context).pleaseSignInToViewAppointments;
      });
      return;
    }

    try {
      final patientDetailsId = prefs.getInt('patient_details_id');

      if (patientDetailsId == null) {
        throw Exception(S.of(context).pleaseSignInAgain);
      }

      final response = await http.get(
        Uri.parse(
            'https://abdokh.pythonanywhere.com/api/appointments/?patient_id=$patientDetailsId'),
        headers: {
          'accept': 'application/json',
          'X-CSRFToken':
              'sd6qim2yPU9lECw35VaDKLPgAo1O5igwVJCFWzM3zGLU3qCOczQWYOH3kWYstn6Z',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          allAppointments = data;
          isLoading = false;
        });
      } else {
        throw Exception(
            '${S.of(context).failedToLoadAppointments}: ${response.statusCode}');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
        errorMessage = '${S.of(context).errorFetchingAppointments}: $error';
      });
    }
  }

  // Delete an appointment by ID
  Future<void> deleteAppointment(int appointmentId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');

    try {
      final response = await http.delete(
        Uri.parse(
            'https://abdokh.pythonanywhere.com/api/appointments/$appointmentId/'),
        headers: {
          'accept': 'application/json',
          'X-CSRFToken':
              'sd6qim2yPU9lECw35VaDKLPgAo1O5igwVJCFWzM3zGLU3qCOczQWYOH3kWYstn6Z',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 204) {
        // Remove the deleted appointment from the list
        setState(() {
          allAppointments
              .removeWhere((appointment) => appointment['id'] == appointmentId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).appointmentDeletedSuccessfully),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw Exception(
            '${S.of(context).failedToDeleteAppointment}: ${response.statusCode}');
      }
    } catch (error) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   // SnackBar(
      //   //   content: Text('${S.of(context).errorDeletingAppointment}: $error'),
      //   //   backgroundColor: Colors.red,
      //   // ),
      // );
    }
  }

  // Filter appointments by status
  List<dynamic> get filteredAppointments {
    return allAppointments
        .where((appointment) => appointment['status'] == selectedStatus)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = S.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          localizations.appointments,
          style: TextStyle(
            color: primaryColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: Text(localizations.loading))
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : accessToken == null
                  ? _buildSignInSignUpButtons(localizations)
                  : Column(
                      children: [
                        // Status Segmented Control
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildStatusButton(
                                    'booked', localizations.booked),
                                _buildStatusButton(
                                    'confirmed', localizations.confirmed),
                                _buildStatusButton(
                                    'cancelled', localizations.cancelled),
                              ],
                            ),
                          ),
                        ),

                        // Appointments List
                        Expanded(
                          child: filteredAppointments.isEmpty
                              ? Center(
                                  child: Text(
                                    localizations.noAppointments,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  itemCount: filteredAppointments.length,
                                  itemBuilder: (context, index) {
                                    final appointment =
                                        filteredAppointments[index];
                                    final dateTime = DateTime.parse(
                                        appointment['date_time']);
                                    final formattedDate =
                                        DateFormat('dd/MM/yyyy')
                                            .format(dateTime);
                                    final formattedTime =
                                        DateFormat('HH:mm').format(dateTime);
                                    final services = appointment['services']
                                            as List<dynamic>? ??
                                        [];
                                    final notes =
                                        appointment['notes']?.toString() ?? '';

                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 16),
                                      child: Card(
                                        color: Colors.white,
                                        elevation: 4,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Doctor and Status Row
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  // Doctor Avatar
                                                  Container(
                                                    width: 60,
                                                    height: 60,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.grey[200],
                                                    ),
                                                    child: const Icon(
                                                        Icons.person,
                                                        size: 40,
                                                        color: Colors.grey),
                                                  ),
                                                  const SizedBox(width: 16),

                                                  // Doctor Info
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          '${localizations.doctor} ${appointment['doctor_first_name']} ${appointment['doctor_last_name']}',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 4),
                                                        Text(
                                                          '${localizations.patient}: ${appointment['patient_first_name']} ${appointment['patient_last_name']}',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors
                                                                .grey[700],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  // Status Badge
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 12,
                                                      vertical: 4,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: _getStatusColor(
                                                          appointment[
                                                              'status']),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: Text(
                                                      _getStatusText(
                                                          appointment['status'],
                                                          localizations),
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 16),

                                              // Appointment Details
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        localizations.date,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                      Text(
                                                        formattedDate,
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        localizations.time,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                      Text(
                                                        formattedTime,
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        localizations.cost,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                      Text(
                                                        '${appointment['cost']} ${localizations.egp}',
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 16),

                                              // Services
                                              if (services.isNotEmpty)
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      localizations.services,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Wrap(
                                                      spacing: 8,
                                                      children: services
                                                          .map<Widget>(
                                                              (service) => Chip(
                                                                    label: Text(
                                                                        service[
                                                                            'name']),
                                                                    backgroundColor:
                                                                        Colors.blue[
                                                                            50],
                                                                    labelStyle:
                                                                        const TextStyle(
                                                                            color:
                                                                                Colors.blue),
                                                                  ))
                                                          .toList(),
                                                    ),
                                                  ],
                                                ),

                                              // Notes
                                              if (notes.isNotEmpty)
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(height: 8),
                                                    Text(
                                                      localizations.notes,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      notes,
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                              // Delete Button
                                              if (selectedStatus == 'booked' ||
                                                  selectedStatus == 'confirmed')
                                                Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: TextButton.icon(
                                                    icon: const Icon(
                                                        Icons.delete,
                                                        color: Colors.red),
                                                    label: Text(
                                                      localizations
                                                          .cancelAppointment,
                                                      style: const TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                    onPressed: () {
                                                      _showDeleteConfirmationDialog(
                                                          context,
                                                          appointment['id']);
                                                    },
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
    );
  }

  Widget _buildStatusButton(String status, String text) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              selectedStatus = status;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor:
                selectedStatus == status ? primaryColor : Colors.transparent,
            foregroundColor:
                selectedStatus == status ? Colors.white : Colors.black,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'confirmed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'booked':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status, S localizations) {
    switch (status) {
      case 'confirmed':
        return localizations.confirmed;
      case 'cancelled':
        return localizations.cancelled;
      case 'booked':
        return localizations.booked;
      default:
        return status;
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context, int appointmentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).confirmCancellation),
          content: Text(S.of(context).cancelAppointmentConfirmation),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(S.of(context).no),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                deleteAppointment(appointmentId);
              },
              child: Text(S.of(context).yes),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSignInSignUpButtons(S localizations) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            localizations.pleaseSignInToViewAppointments,
            style: TextStyle(fontSize: 18, color: Colors.grey[700]),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRoutes.signinScreen),
                child: Text(
                  localizations.signIn,
                  style: _textStyle(18, Colors.white, FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRoutes.signupScreen),
                child: Text(
                  localizations.signUp,
                  style: _textStyle(18, Colors.white, FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Reusable Text Style
  TextStyle _textStyle(double size, Color color, FontWeight weight) {
    return TextStyle(fontSize: size, color: color, fontWeight: weight);
  }
}
