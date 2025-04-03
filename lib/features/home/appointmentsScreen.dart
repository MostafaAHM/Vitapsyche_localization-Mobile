import 'package:flutter/material.dart';
import 'package:flutter_mindmed_project/core/routes/app_routes.dart';
import 'package:flutter_mindmed_project/core/theme/colors.dart';
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

  @override
  void initState() {
    super.initState();
    fetchAppointments(); // Fetch appointments when the screen loads
  }

  // Fetch appointments based on patient_details_id
  Future<void> fetchAppointments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString('access_token');

    if (accessToken == null) {
      setState(() {
        isLoading = false;
        errorMessage = 'Please log in to view appointments.';
      });
      return;
    }

    try {
      final patientDetailsId = prefs.getInt('patient_details_id');

      if (patientDetailsId == null) {
        throw Exception('Patient details ID not found. Please log in again.');
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
        throw Exception('Failed to load appointments: ${response.statusCode}');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error fetching appointments: $error';
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
          const SnackBar(
            content: Text('Appointment deleted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw Exception('Failed to delete appointment: ${response.statusCode}');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting appointment: $error'),
          backgroundColor: Colors.red,
        ),
      );
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Appointments',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : accessToken == null
                  ? _buildSignInSignUpButtons()
                  : Column(
                      children: [
                        // Toggle Buttons for Status
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  selectedStatus = 'booked';
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: selectedStatus == 'booked'
                                    ? primaryColor
                                    : Colors.grey[300],
                              ),
                              child: const Text('Booked',
                                  style: TextStyle(color: Colors.white)),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  selectedStatus = 'confirmed';
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: selectedStatus == 'confirmed'
                                    ? primaryColor
                                    : Colors.grey[300],
                              ),
                              child: const Text('Confirmed',
                                  style: TextStyle(color: Colors.white)),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  selectedStatus = 'cancelled';
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: selectedStatus == 'cancelled'
                                    ? primaryColor
                                    : Colors.grey[300],
                              ),
                              child: const Text('Cancelled',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Appointments List
                        Expanded(
                          child: filteredAppointments.isEmpty
                              ? const Center(
                                  child: Text('No appointments found.'))
                              : ListView.builder(
                                  itemCount: filteredAppointments.length,
                                  itemBuilder: (context, index) {
                                    final appointment =
                                        filteredAppointments[index];
                                    final dateTime = DateTime.parse(
                                        appointment['date_time']);
                                    final formattedDate =
                                        DateFormat('yyyy-MM-dd')
                                            .format(dateTime);
                                    final formattedTime =
                                        DateFormat('HH:mm').format(dateTime);

                                    return Card(
                                      color: Colors.white,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 8),
                                      child: ListTile(
                                        leading: Image.asset(
                                          'assets/images/woman-choosing-dates-calendar-appointment-booking_23-2148552956.avif',
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                        title: Text(
                                          'Appointment #${appointment['id']}',
                                          style: const TextStyle(
                                              color: primaryColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('Date: $formattedDate'),
                                            Text('Time: $formattedTime'),
                                            Text(
                                              'Status: ${appointment['status']}',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ],
                                        ),
                                        trailing: IconButton(
                                          icon: const Icon(Icons.delete,
                                              color: primaryColor),
                                          onPressed: () {
                                            // Delete the appointment
                                            deleteAppointment(
                                                appointment['id']);
                                          },
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

  Widget _buildSignInSignUpButtons() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.signinScreen),
            child: Text(
              'Sign In',
              style: _textStyle(18, Colors.white, FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
          SizedBox(width: 20),
          ElevatedButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.signupScreen),
            child: Text(
              'Sign Up',
              style: _textStyle(18, Colors.white, FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
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
