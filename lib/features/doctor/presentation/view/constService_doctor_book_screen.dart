import 'package:flutter/material.dart';
import 'package:flutter_mindmed_project/core/theme/colors.dart';
import '../widget/doctor_profile_header.dart';
import '../../data/doctor_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class ServiceDoctorBookingScreen extends StatefulWidget {
  final DoctorModel doctor;
  final int doctorDetailsId;

  const ServiceDoctorBookingScreen({
    super.key,
    required this.doctor,
    required this.doctorDetailsId,
  });

  @override
  State<ServiceDoctorBookingScreen> createState() =>
      _ServiceDoctorBookingScreenState();
}

class _ServiceDoctorBookingScreenState
    extends State<ServiceDoctorBookingScreen> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  List<Map<String, dynamic>> availableSlots = [];
  List<TimeOfDay> timeSlots = [];
  Set<TimeOfDay> bookedSlots = {};
  bool isLoading = false;
  Map<String, List<Map<String, dynamic>>> schedulesByDay = {};

  @override
  void initState() {
    super.initState();
    print('Doctor ID: ${widget.doctorDetailsId}');
    _fetchDoctorAvailability();
  }

  Future<void> _fetchDoctorAvailability() async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');

    if (accessToken == null) {
      print('Access token not found. Please log in again.');
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(
            'https://abdokh.pythonanywhere.com/api/availabilities/?doctor=${widget.doctorDetailsId}'),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          availableSlots = data.cast<Map<String, dynamic>>();
          _populateSchedulesByDay(data);
          isLoading = false;
        });
        print('Fetched Availability: $availableSlots');
      } else {
        print('Failed to load doctor availability: ${response.statusCode}');
        print('Response body: ${response.body}');
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to load doctor availability'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error fetching doctor availability: $e');
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _populateSchedulesByDay(List<dynamic> schedules) {
    schedulesByDay = {};
    for (var schedule in schedules) {
      final day = schedule['day_of_week'];
      if (!schedulesByDay.containsKey(day)) {
        schedulesByDay[day] = [];
      }
      schedulesByDay[day]!.add(schedule);
    }
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      selectedDate = date;
      timeSlots.clear();
      bookedSlots.clear();
    });
    _fetchAvailableSlots();
  }

  Future<void> _fetchAvailableSlots() async {
    if (selectedDate != null) {
      final String dayOfWeek =
          DateFormat('EEEE').format(selectedDate!).toLowerCase();
      final filteredSlots = schedulesByDay[dayOfWeek] ?? [];

      timeSlots.clear();

      for (var slot in filteredSlots) {
        final startTime = TimeOfDay(
          hour: int.parse(slot['start_time'].split(':')[0]),
          minute: int.parse(slot['start_time'].split(':')[1]),
        );
        final endTime = TimeOfDay(
          hour: int.parse(slot['end_time'].split(':')[0]),
          minute: int.parse(slot['end_time'].split(':')[1]),
        );
        _generateTimeSlots(startTime, endTime);
      }

      setState(() {});
    }
  }

  void _generateTimeSlots(TimeOfDay startTime, TimeOfDay endTime) {
    final slots = <TimeOfDay>[];
    var currentTime = startTime;

    while (currentTime.hour < endTime.hour ||
        (currentTime.hour == endTime.hour &&
            currentTime.minute <= endTime.minute)) {
      if (!bookedSlots.contains(currentTime)) {
        slots.add(currentTime);
      }
      currentTime = _addMinutes(currentTime, 30);
    }

    setState(() {
      timeSlots.addAll(slots);
    });
  }

  TimeOfDay _addMinutes(TimeOfDay time, int minutes) {
    final totalMinutes = time.hour * 60 + time.minute + minutes;
    final hours = totalMinutes ~/ 60;
    final mins = totalMinutes % 60;
    return TimeOfDay(hour: hours, minute: mins);
  }

  void _onTimeSelected(TimeOfDay time) {
    setState(() {
      selectedTime = time;
    });
  }

  DateTime? get selectedDateTime {
    if (selectedDate != null && selectedTime != null) {
      return DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        selectedTime!.hour,
        selectedTime!.minute,
      );
    }
    return null;
  }

  Future<void> _onBookAppointment() async {
    if (selectedDate != null && selectedTime != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('access_token');
      int? patientDetailsId = prefs.getInt('patient_details_id');

      if (accessToken == null || patientDetailsId == null) {
        print('Access token or patient details ID not found.');
        return;
      }

      final appointmentData = {
        "date_time": selectedDateTime?.toIso8601String(),
        "service_type": "teleconsultation",
        "status": "booked",
        "notes": "string",
        "appointment_address": "string",
        "is_follow_up": false,
        "is_confirmed": false,
        "patient": patientDetailsId,
        "doctor": widget.doctorDetailsId,
        "services": [38],
      };

      try {
        final response = await http.post(
          Uri.parse('https://abdokh.pythonanywhere.com/api/appointments/'),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
          body: json.encode(appointmentData),
        );

        if (response.statusCode == 201) {
          setState(() {
            bookedSlots.add(selectedTime!);
            timeSlots.removeWhere((slot) =>
                slot.hour == selectedTime!.hour &&
                slot.minute == selectedTime!.minute);
            selectedTime = null;
          });

          await _fetchAvailableSlots();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Appointment successfully booked!'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          final responseBody = json.decode(response.body);
          print('Error Response Body: $responseBody');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Failed to book appointment: ${responseBody['detail'] ?? 'Unknown error'}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        print('Error booking appointment: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Failed to book appointment. Please try again later.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Please fill in all the details to book an appointment'),
        ),
      );
    }
  }

  Widget _buildAvailabilityCalendar() {
    final now = DateTime.now();
    final next30Days = DateTime.now().add(const Duration(days: 30));
    final days = List.generate(
        next30Days.difference(now).inDays, (i) => now.add(Duration(days: i)));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Available Days",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: days.length,
            itemBuilder: (context, index) {
              final day = days[index];
              final dayName = DateFormat('EEE').format(day);
              final dayNumber = day.day;
              final isSelected = selectedDate?.day == day.day &&
                  selectedDate?.month == day.month;
              final dayOfWeek = DateFormat('EEEE').format(day).toLowerCase();
              final isAvailable = schedulesByDay.containsKey(dayOfWeek);

              return GestureDetector(
                onTap: isAvailable ? () => _onDateSelected(day) : null,
                child: Container(
                  width: 60,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.teal
                        : isAvailable
                            ? Colors.teal[100]
                            : Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        dayName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        dayNumber.toString(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DoctorProfileHeader(doctor: widget.doctor),
                    const SizedBox(height: 24),
                    _buildAvailabilityCalendar(),
                    const SizedBox(height: 24),
                    if (selectedDate != null) ...[
                      const Text(
                        "Available Time Slots",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      if (timeSlots.isEmpty)
                        const Text("No available slots for this day")
                      else
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 1.5,
                          ),
                          itemCount: timeSlots.length,
                          itemBuilder: (context, index) {
                            final slot = timeSlots[index];
                            return GestureDetector(
                              onTap: () =>
                                  _onTimeSelected(slot), // Select the time slot
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                decoration: BoxDecoration(
                                  color: selectedTime == slot
                                      ? Colors.teal
                                      : Colors.grey[300],
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    if (selectedTime == slot)
                                      BoxShadow(
                                        color: Colors.teal.withOpacity(0.4),
                                        spreadRadius: 3,
                                        blurRadius: 6,
                                      )
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    slot.format(
                                        context), // Format the time slot
                                    style: TextStyle(
                                      color: selectedTime == slot
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      const SizedBox(height: 20),
                      if (selectedTime != null)
                        ElevatedButton(
                          onPressed: _onBookAppointment,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            backgroundColor: Colors.teal,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Book Appointment',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
                  ],
                ),
              ),
            ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      foregroundColor: primaryColor,
      elevation: 0,
      title: const Text(
        'Book Appointment',
        style: TextStyle(color: primaryColor),
      ),
      centerTitle: true,
    );
  }
}
