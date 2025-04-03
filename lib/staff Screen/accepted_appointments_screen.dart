import 'package:flutter/material.dart';

class AcceptedAppointmentsScreen extends StatefulWidget {
  const AcceptedAppointmentsScreen({super.key});

  @override
  State<AcceptedAppointmentsScreen> createState() =>
      _AcceptedAppointmentsScreenState();
}

class _AcceptedAppointmentsScreenState extends State<AcceptedAppointmentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Appointments',
            style: TextStyle(
                color: const Color.fromARGB(255, 3, 190, 150), fontSize: 24)),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, // This removes the back arrow
        centerTitle: true, // This centers the title
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelStyle:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'Accepted'),
            Tab(text: 'Refused'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Accepted Appointments Tab
          _buildAppointmentList('accepted'),

          // Refused Appointments Tab
          _buildAppointmentList('refused'),
        ],
      ),
    );
  }

  Widget _buildAppointmentList(String status) {
    // Replace this with your actual data fetching logic
    final List<Map<String, dynamic>> appointments = [
      // {
      //   'id': 1,
      //   'title': 'Appointment #1',
      //   'description': 'Appointment on 2025-03-01',
      //   'imageUrl':
      //       'assets/images/woman-choosing-dates-calendar-appointment-booking_23-2148552956.avif',
      //   'status': status,
      // },
      // {
      //   'id': 2,
      //   'title': 'Appointment #2',
      //   'description': 'Appointment on 2025-03-02',
      //   'imageUrl':
      //       'assets/images/woman-choosing-dates-calendar-appointment-booking_23-2148552956.avif',
      //   'status': status,
      // },
    ];

    return ListView.builder(
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Card(
            color: Colors.white,
            elevation: 4,
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
                      appointment['imageUrl'],
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              appointment['title'],
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
                              color: appointment['status'] == 'accepted'
                                  ? Colors.green
                                  : Colors.red,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              appointment['status'],
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
                        appointment['description'],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
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
