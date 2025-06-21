import 'package:flutter/material.dart';
import 'package:flutter_mindmed_project/generated/l10n.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class DoctorAvailabilityScreen extends StatefulWidget {
  const DoctorAvailabilityScreen({super.key});

  @override
  State<DoctorAvailabilityScreen> createState() =>
      _DoctorAvailabilityScreenState();
}

class _DoctorAvailabilityScreenState extends State<DoctorAvailabilityScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  Map<String, List<Map<String, dynamic>>> schedulesByDay = {
    'monday': [],
    'tuesday': [],
    'wednesday': [],
    'thursday': [],
    'friday': [],
    'saturday': [],
    'sunday': [],
  };

  List<Map<String, dynamic>> allSchedules = [];
  bool isLoading = false;
  int _currentIndex = 0; // For bottom navigation bar

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: daysOfWeek.length, vsync: this);
    _fetchSchedules();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchSchedules() async {
    setState(() {
      isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';
    final doctorDetailsId =
        prefs.getInt('doctor_details_id') ?? 0; // Get doctor ID

    if (doctorDetailsId == 0) {
      print("Doctor Details ID not found in SharedPreferences");
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(
            'https://abdokh.pythonanywhere.com/api/availabilities/?doctor=$doctorDetailsId'), // Include doctor ID in the query
        headers: {
          'accept': 'application/json',
          'X-CSRFToken':
              'H7ozWH7ioICIk51WrSdzgHrd9b64ozy6v1wmJBrSo6V8EcxmbYwICxFLosEzK5od',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          allSchedules = List<Map<String, dynamic>>.from(data);
          _populateSchedulesByDay(data);
          isLoading = false;
        });
      } else {
        // Print error to terminal
        print('Failed to load schedules. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      // Print exception to terminal
      print('Error fetching schedules: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _populateSchedulesByDay(List<dynamic> schedules) {
    schedulesByDay.forEach((key, value) {
      schedulesByDay[key]!.clear();
    });

    for (var schedule in schedules) {
      final day = schedule['day_of_week'].toString().toLowerCase();
      if (schedulesByDay.containsKey(day)) {
        schedulesByDay[day]!.add(schedule);
      }
    }
  }

  Future<void> _submitSchedule(
      String day, String startTime, String endTime) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';

    final url =
        Uri.parse('https://abdokh.pythonanywhere.com/api/availabilities/');

    final headers = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
      'X-CSRFToken':
          'H7ozWH7ioICIk51WrSdzgHrd9b64ozy6v1wmJBrSo6V8EcxmbYwICxFLosEzK5od',
      'Authorization': 'Bearer $token',
    };

    // Convert the day to lowercase
    final lowercaseDay = day.toLowerCase();

    final body = jsonEncode({
      'day_of_week': lowercaseDay, // Use lowercase day
      'start_time': startTime,
      'end_time': endTime,
      'max_patients_per_slot': 1,
      'notes': 'Available for consultation',
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Schedule submitted successfully!')),
        );
        _fetchSchedules(); // Refresh schedules after submission
      } else {
        // Print error to terminal
        print('Failed to submit schedule. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to submit schedule. Please try again.')),
        );
      }
    } catch (e) {
      // Print exception to terminal
      print('Error submitting schedule: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  Future<void> _deleteAvailability(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';

    final url =
        Uri.parse('https://abdokh.pythonanywhere.com/api/availabilities/$id/');

    final headers = {
      'accept': 'application/json',
      'X-CSRFToken':
          'H7ozWH7ioICIk51WrSdzgHrd9b64ozy6v1wmJBrSo6V8EcxmbYwICxFLosEzK5od',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.delete(url, headers: headers);

      if (response.statusCode == 204) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Availability deleted successfully!')),
        );
        _fetchSchedules(); // Refresh schedules after deletion
      } else {
        // Print error to terminal
        print(
            'Failed to delete availability. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('Failed to delete availability. Please try again.')),
        );
      }
    } catch (e) {
      // Print exception to terminal
      print('Error deleting availability: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = S.of(context);
    return Scaffold(
      backgroundColor: Colors.white, // Set background to white
      body: Column(
        children: [
          AppBar(
            title: Text(localizations.doctorAvailability,
                style: TextStyle(color: Colors.white, fontSize: 24)),
            backgroundColor: const Color.fromARGB(255, 3, 190, 150),
            elevation: 0,
            automaticallyImplyLeading: false, // This removes the back arrow
            centerTitle: true, // This centers the title
          ),
          Expanded(
            child: _currentIndex == 0
                ? _buildAvailabilityScreen()
                : _buildScheduleScreen(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: const Color.fromARGB(255, 3, 190, 150),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: localizations.availability,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: localizations.schedules,
          ),
        ],
      ),
    );
  }

  Widget _buildAvailabilityScreen() {
    final localizations = S.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Container(
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 3, 190, 150).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: const Color.fromARGB(255, 3, 190, 150),
              unselectedLabelColor: Colors.grey,
              labelStyle:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              indicator: BoxDecoration(
                color: const Color.fromARGB(255, 3, 190, 150).withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              tabs: daysOfWeek
                  .map((day) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 1),
                        child: Center(child: Text(day)),
                      ))
                  .toList(),
            ),
          ),
        ),
        Expanded(
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                      color: Color.fromARGB(255, 3, 190, 150)))
              : TabBarView(
                  controller: _tabController,
                  children: daysOfWeek.map((day) {
                    var daySchedules = schedulesByDay[day] ?? [];
                    return DaySchedule(
                      day: day,
                      schedules: daySchedules.isEmpty
                          ? [
                              {
                                'id': 'new_schedule',
                                'start_time': '',
                                'end_time': ''
                              }
                            ]
                          : daySchedules,
                      submitSchedule: _submitSchedule,
                      deleteSchedule:
                          _deleteAvailability, // Pass the delete method
                    );
                  }).toList(),
                ),
        ),
      ],
    );
  }

  Widget _buildScheduleScreen() {
    final localizations = S.of(context);
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(
              color: Color.fromARGB(255, 3, 190, 150),
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: allSchedules.length,
            itemBuilder: (context, index) {
              final schedule = allSchedules[index];
              final startTime = _formatTime(schedule['start_time']);
              final endTime = _formatTime(schedule['end_time']);

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _getScheduleColor(schedule),
                      _getScheduleColor(schedule).withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Timeline Indicator
                      Container(
                        width: 4,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Schedule Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Day of the Week
                            Text(
                              schedule['day_of_week'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Time Range
                            Row(
                              children: [
                                const Icon(
                                  Icons.access_time,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '$startTime - $endTime',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Max Patients
                            Row(
                              children: [
                                Icon(
                                  Icons.people,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${localizations.maxPatients}: ${schedule['max_patients_per_slot']}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Delete Button
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          _deleteAvailability(
                              schedule['id']); // Call the delete method
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }

// Helper function to format time in AM/PM
  String _formatTime(String time) {
    try {
      final timeOfDay = TimeOfDay(
        hour: int.parse(time.split(':')[0]),
        minute: int.parse(time.split(':')[1]),
      );
      return timeOfDay.format(context); // Format time in AM/PM
    } catch (e) {
      return time; // Return the original time if formatting fails
    }
  }

// Helper function to get schedule color

  Color _getScheduleColor(Map<String, dynamic> schedule) {
    // Customize this logic based on your requirements
    if (schedule['max_patients_per_slot'] == 0) {
      return Colors.red; // Busy
    } else if (schedule['max_patients_per_slot'] == 1) {
      return const Color.fromARGB(255, 3, 190, 150); // Available
    } else {
      return Colors.blue; // Partially available
    }
  }
}

class DaySchedule extends StatefulWidget {
  final String day;
  final List<Map<String, dynamic>> schedules;
  final Future<void> Function(String day, String startTime, String endTime)
      submitSchedule;
  final Future<void> Function(int id) deleteSchedule; // Add this parameter

  const DaySchedule({
    super.key,
    required this.day,
    required this.schedules,
    required this.submitSchedule,
    required this.deleteSchedule, // Add this parameter
  });

  @override
  _DayScheduleState createState() => _DayScheduleState();
}

class _DayScheduleState extends State<DaySchedule> {
  late Map<String, TextEditingController> fromTimeControllers;
  late Map<String, TextEditingController> toTimeControllers;

  @override
  void initState() {
    super.initState();
    fromTimeControllers = {};
    toTimeControllers = {};

    for (var schedule in widget.schedules) {
      fromTimeControllers[schedule['id']] =
          TextEditingController(text: schedule['start_time']);
      toTimeControllers[schedule['id']] =
          TextEditingController(text: schedule['end_time']);
    }

    if (widget.schedules.isEmpty) {
      fromTimeControllers['new_schedule'] = TextEditingController();
      toTimeControllers['new_schedule'] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (var controller in fromTimeControllers.values) {
      controller.dispose();
    }
    for (var controller in toTimeControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = S.of(context);
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          const SizedBox(height: 20),
          ...widget.schedules.map((schedule) {
            return ScheduleWidget(
              schedule: schedule,
              fromTimeController: fromTimeControllers[schedule['id']]!,
              toTimeController: toTimeControllers[schedule['id']]!,
              deleteSchedule: widget.deleteSchedule, // Pass the delete method
            );
          }),
          if (widget.schedules.isEmpty)
            ScheduleWidget(
              schedule: {'id': 'new_schedule', 'day_of_week': widget.day},
              fromTimeController: fromTimeControllers['new_schedule']!,
              toTimeController: toTimeControllers['new_schedule']!,
              deleteSchedule: widget.deleteSchedule, // Pass the delete method
            ),
          const SizedBox(height: 50),
          ElevatedButton(
            onPressed: () {
              final startTime = fromTimeControllers['new_schedule']?.text ?? '';
              final endTime = toTimeControllers['new_schedule']?.text ?? '';
              widget.submitSchedule(widget.day, startTime, endTime);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 3, 190, 150),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            ),
            child: Text(
              localizations.submit,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}

class ScheduleWidget extends StatelessWidget {
  final Map<String, dynamic> schedule;
  final TextEditingController fromTimeController;
  final TextEditingController toTimeController;
  final Future<void> Function(int id) deleteSchedule; // Add this parameter

  const ScheduleWidget({
    super.key,
    required this.schedule,
    required this.fromTimeController,
    required this.toTimeController,
    required this.deleteSchedule, // Add this parameter
  });

  Future<void> _selectTime(
      BuildContext context, TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color.fromARGB(255, 3, 190, 150),
            colorScheme: const ColorScheme.light(
                primary: Color.fromARGB(255, 3, 190, 150)),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final now = DateTime.now();
      final selectedTime =
          DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
      // Format the time as HH:mm:ss
      controller.text = DateFormat('HH:mm:ss').format(selectedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = S.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _selectTime(context, fromTimeController),
              child: AbsorbPointer(
                child: TextFormField(
                  controller: fromTimeController,
                  decoration: InputDecoration(
                    labelText: localizations.startTime,
                    hintText: 'HH:mm:ss',
                    border: const OutlineInputBorder(),
                    labelStyle:
                        const TextStyle(color: Colors.black, fontSize: 16),
                    hintStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: GestureDetector(
              onTap: () => _selectTime(context, toTimeController),
              child: AbsorbPointer(
                child: TextFormField(
                  controller: toTimeController,
                  decoration: InputDecoration(
                    labelText: localizations.endTime,
                    hintText: 'HH:mm:ss',
                    border: const OutlineInputBorder(),
                    labelStyle:
                        const TextStyle(color: Colors.black, fontSize: 16),
                    hintStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ),
          ),
          if (schedule['id'] !=
              'new_schedule') // Show delete button only for existing schedules
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                deleteSchedule(schedule['id']); // Call the delete method
              },
            ),
        ],
      ),
    );
  }
}
