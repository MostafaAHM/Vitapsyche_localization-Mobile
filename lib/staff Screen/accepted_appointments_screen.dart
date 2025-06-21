import 'package:flutter/material.dart';
import 'package:flutter_mindmed_project/generated/l10n.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AcceptedAppointmentsScreen extends StatefulWidget {
  const AcceptedAppointmentsScreen({super.key});

  @override
  State<AcceptedAppointmentsScreen> createState() =>
      _AcceptedAppointmentsScreenState();
}

class _AcceptedAppointmentsScreenState extends State<AcceptedAppointmentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<dynamic> _appointments = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchAppointments();
  }

  Future<void> _fetchAppointments() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token') ?? '';

      final response = await http.get(
        Uri.parse('https://abdokh.pythonanywhere.com/api/appointments/'),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token',
          'X-CSRFToken':
              'VMgmCVZKupuWY1Bndrcpbmtu17pxiBa85NrDod8vdqV8rZd3qJpcxcPLYz02dYl9',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _appointments = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load appointments: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching appointments: $e';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = S.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(localizations.appointments,
            style: TextStyle(
                color: const Color.fromARGB(255, 3, 190, 150), fontSize: 24)),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color.fromARGB(255, 3, 190, 150),
          labelColor: const Color.fromARGB(255, 3, 190, 150),
          unselectedLabelColor: Colors.grey,
          labelStyle:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          tabs: [
            Tab(text: localizations.accepted),
            Tab(text: localizations.refused),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : TabBarView(
                  controller: _tabController,
                  children: [
                    // Accepted Appointments Tab (confirmed)
                    _buildAppointmentList(context, 'confirmed'),

                    // Refused Appointments Tab (cancelled)
                    _buildAppointmentList(context, 'cancelled'),
                  ],
                ),
    );
  }

  Widget _buildAppointmentList(BuildContext context, String status) {
    final localizations = S.of(context)!;

    final filteredAppointments = _appointments.where((appointment) {
      return appointment['status'] == status;
    }).toList();

    if (filteredAppointments.isEmpty) {
      return Center(
        child: Text(
          status == 'confirmed'
              ? localizations.noAcceptedAppointments
              : localizations.noRefusedAppointments,
          style: const TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredAppointments.length,
      itemBuilder: (context, index) {
        final appointment = filteredAppointments[index];
        final dateTime = DateTime.parse(appointment['date_time']);
        final formattedDate =
            '${dateTime.day}/${dateTime.month}/${dateTime.year}';
        final formattedTime =
            '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                  // Doctor and Patient Info
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Doctor Avatar (placeholder)
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[200],
                        ),
                        child: const Icon(Icons.person,
                            size: 40, color: Colors.grey),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${localizations.doctor} ${appointment['doctor_first_name']} ${appointment['doctor_last_name']}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${localizations.patient}: ${appointment['patient_first_name']} ${appointment['patient_last_name']}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Status Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: status == 'confirmed'
                              ? const Color.fromARGB(255, 3, 190, 150)
                              : Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          status == 'confirmed'
                              ? localizations.accepted
                              : localizations.cancelled,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Appointment Details
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            localizations.dateAndTime,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            '$formattedDate ${localizations.at} $formattedTime',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            localizations.cost,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            '${appointment['cost']} ${localizations.currency}',
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
                  if (appointment['services'] != null &&
                      appointment['services'].isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localizations.services,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 8,
                          children: (appointment['services'] as List)
                              .map<Widget>((service) => Chip(
                                    label: Text(service['name']),
                                    backgroundColor: Colors.blue[50],
                                    labelStyle:
                                        const TextStyle(color: Colors.blue),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  const SizedBox(height: 8),
                  // Notes
                  if (appointment['notes'] != null &&
                      appointment['notes'].isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localizations.notes,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          appointment['notes'],
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
