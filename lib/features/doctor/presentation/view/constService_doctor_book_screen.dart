import 'package:flutter/material.dart';
import 'package:flutter_mindmed_project/core/routes/app_routes.dart';
import 'package:flutter_mindmed_project/core/theme/colors.dart';
import 'package:flutter_mindmed_project/generated/l10n.dart';
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
  List<dynamic> existingAppointments = [];

  @override
  void initState() {
    super.initState();
    print('Doctor ID: ${widget.doctorDetailsId}');
    _fetchDoctorAvailability();
    _fetchExistingAppointments();
  }

  Future<void> _fetchExistingAppointments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');
    int? patientDetailsId = prefs.getInt('patient_details_id');

    if (accessToken == null || patientDetailsId == null) {
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(
            'https://abdokh.pythonanywhere.com/api/appointments/?patient_id=$patientDetailsId&doctor=${widget.doctorDetailsId}'),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          existingAppointments = json.decode(response.body);
        });
      }
    } catch (e) {
      print('Error fetching existing appointments: $e');
    }
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
      bookedSlots.clear();

      // Get booked slots for this date
      final bookedTimes = _getBookedTimesForDate(selectedDate!);

      for (var slot in filteredSlots) {
        final startTime = TimeOfDay(
          hour: int.parse(slot['start_time'].split(':')[0]),
          minute: int.parse(slot['start_time'].split(':')[1]),
        );
        final endTime = TimeOfDay(
          hour: int.parse(slot['end_time'].split(':')[0]),
          minute: int.parse(slot['end_time'].split(':')[1]),
        );
        _generateTimeSlots(startTime, endTime, bookedTimes);
      }

      setState(() {});
    }
  }

  List<TimeOfDay> _getBookedTimesForDate(DateTime date) {
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
    final bookedTimes = <TimeOfDay>[];

    for (var appointment in existingAppointments) {
      final appointmentDate = DateTime.parse(appointment['date_time']);
      if (DateFormat('yyyy-MM-dd').format(appointmentDate) == formattedDate) {
        bookedTimes.add(TimeOfDay(
          hour: appointmentDate.hour,
          minute: appointmentDate.minute,
        ));
      }
    }

    return bookedTimes;
  }

  void _generateTimeSlots(
      TimeOfDay startTime, TimeOfDay endTime, List<TimeOfDay> bookedTimes) {
    final slots = <TimeOfDay>[];
    var currentTime = startTime;

    while (currentTime.hour < endTime.hour ||
        (currentTime.hour == endTime.hour &&
            currentTime.minute <= endTime.minute)) {
      // Check if this time slot is already booked
      final isBooked = bookedTimes.any((bookedTime) =>
          bookedTime.hour == currentTime.hour &&
          bookedTime.minute == currentTime.minute);

      if (!isBooked) {
        slots.add(currentTime);
      } else {
        bookedSlots.add(currentTime);
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
          // Refresh the existing appointments
          await _fetchExistingAppointments();

          // Refresh the available slots
          await _fetchAvailableSlots();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context).appointmentDeletedSuccessfully),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          final responseBody = json.decode(response.body);
          print('Error Response Body: $responseBody');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  '${S.of(context).failedToDeleteAppointment}: ${responseBody['detail'] ?? S.of(context).errorDeletingAppointment}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        print('Error booking appointment: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).failedToDeleteAppointment),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).pleaseSignInToBookAppointment),
        ),
      );
    }
  }

  Widget _buildAvailabilityCalendar() {
    final localizations = S.of(context);
    final now = DateTime.now();
    final next30Days = DateTime.now().add(const Duration(days: 30));
    final days = List.generate(
        next30Days.difference(now).inDays, (i) => now.add(Duration(days: i)));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.available,
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

  Future<bool> _isAuthenticated() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');
    return accessToken != null;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = S.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: FutureBuilder<bool>(
        future: _isAuthenticated(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!) {
            // User is not authenticated - show sign in button
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    localizations.pleaseSignInToBookAppointment,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed(AppRoutes.signinScreen),
                    child: Text(
                      localizations.signIn,
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainBlueColor,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          // User is authenticated - show normal content
          return isLoading
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
                          Text(
                             localizations.available,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          if (timeSlots.isEmpty && bookedSlots.isEmpty)
                             Text(localizations.noAppointments)
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
                              itemCount: timeSlots.length + bookedSlots.length,
                              itemBuilder: (context, index) {
                                final allSlots = [...timeSlots, ...bookedSlots];
                                final slot = allSlots[index];
                                final isBooked = bookedSlots.contains(slot);

                                return GestureDetector(
                                  onTap: isBooked
                                      ? null
                                      : () => _onTimeSelected(slot),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    decoration: BoxDecoration(
                                      color: isBooked
                                          ? Colors.red[300]
                                          : selectedTime == slot
                                              ? Colors.teal
                                              : Colors.grey[300],
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        if (selectedTime == slot && !isBooked)
                                          BoxShadow(
                                            color: Colors.teal.withOpacity(0.4),
                                            spreadRadius: 3,
                                            blurRadius: 6,
                                          )
                                      ],
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            slot.format(context),
                                            style: TextStyle(
                                              color: isBooked ||
                                                      selectedTime == slot
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          if (isBooked)
                                            Text(
                                             localizations.booked,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                              ),
                                            ),
                                        ],
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
                              child:  Text(
                            localizations.bookAppointment  ,
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
                );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
     final localizations = S.of(context);
    return AppBar(
      backgroundColor: Colors.white,
      foregroundColor: primaryColor,
      elevation: 0,
      title: Text(
        localizations.bookAppointment,
        style: TextStyle(color: primaryColor),
      ),
      centerTitle: true,
    );
  }
}
