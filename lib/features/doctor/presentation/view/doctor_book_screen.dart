// import 'package:flutter/material.dart';
// import 'package:flutter_mindmed_project/core/theme/colors.dart';
// import '../widget/doctor_profile_header.dart';
// import '../../data/doctor_model.dart'; // Import the DoctorModel
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:intl/intl.dart';

// class DoctorBookingScreen extends StatefulWidget {
//   final DoctorModel doctor;
//   final int doctorDetailsId; // Use doctor ID instead of doctor_details ID

//   const DoctorBookingScreen({
//     super.key,
//     required this.doctor,
//     required this.doctorDetailsId, // Use doctor ID
//   });

//   @override
//   State<DoctorBookingScreen> createState() => _DoctorBookingScreenState();
// }

// class _DoctorBookingScreenState extends State<DoctorBookingScreen> {
//   DateTime? selectedDate;
//   TimeOfDay? selectedTime;
//   List<Map<String, dynamic>> availableSlots = []; // To hold available slots
//   List<TimeOfDay> timeSlots = []; // To hold generated time slots
//   Set<TimeOfDay> bookedSlots = {}; // To track booked time slots

//   @override
//   void initState() {
//     super.initState();
//     // Print the doctor's ID to the terminal
//     print('Doctor ID: ${widget.doctorDetailsId}');
//     _fetchDoctorAvailability(); // Fetch doctor availability
//   }

//   // Fetch doctor availability from the API
//   Future<void> _fetchDoctorAvailability() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? accessToken = prefs.getString('access_token');

//     if (accessToken == null) {
//       print('Access token not found. Please log in again.');
//       return;
//     }

//     try {
//       // Use doctor ID in the API call
//       final response = await http.get(
//         Uri.parse(
//             'https://abdokh.pythonanywhere.com/api/availabilities/?doctor=${widget.doctorDetailsId}'),
//         headers: {
//           'accept': 'application/json',
//           'Authorization': 'Bearer $accessToken',
//         },
//       );

//       if (response.statusCode == 200) {
//         final List<dynamic> data = json.decode(response.body);
//         setState(() {
//           availableSlots = data.cast<Map<String, dynamic>>();
//         });
//         print('Fetched Availability: $availableSlots'); // Print fetched data
//       } else {
//         print('Failed to load doctor availability: ${response.statusCode}');
//         print('Response body: ${response.body}');
//         throw Exception('Failed to load doctor availability');
//       }
//     } catch (e) {
//       print('Error fetching doctor availability: $e');
//     }
//   }

//   void _onDateSelected(DateTime date) {
//     setState(() {
//       selectedDate = date;
//       timeSlots.clear(); // Clear previous time slots
//       bookedSlots.clear(); // Clear booked slots for the new date
//     });
//     _fetchAvailableSlots(); // Fetch available slots for the selected date
//   }

//   Future<void> _fetchAvailableSlots() async {
//     if (selectedDate != null) {
//       final String dayOfWeek =
//           DateFormat('EEEE').format(selectedDate!).toLowerCase();
//       final filteredSlots = availableSlots
//           .where((slot) => slot['day_of_week'] == dayOfWeek)
//           .toList();

//       // Clear existing time slots
//       timeSlots.clear();

//       // Generate time slots for each available slot
//       for (var slot in filteredSlots) {
//         final startTime = TimeOfDay(
//           hour: int.parse(slot['start_time'].split(':')[0]),
//           minute: int.parse(slot['start_time'].split(':')[1]),
//         );
//         final endTime = TimeOfDay(
//           hour: int.parse(slot['end_time'].split(':')[0]),
//           minute: int.parse(slot['end_time'].split(':')[1]),
//         );
//         _generateTimeSlots(startTime, endTime); // Generate time slots
//       }

//       setState(() {}); // Update the UI
//     }
//   }

//   void _generateTimeSlots(TimeOfDay startTime, TimeOfDay endTime) {
//     final slots = <TimeOfDay>[];
//     var currentTime = startTime;

//     while (currentTime.hour < endTime.hour ||
//         (currentTime.hour == endTime.hour &&
//             currentTime.minute <= endTime.minute)) {
//       // Skip the slot if it's already booked
//       if (!bookedSlots.contains(currentTime)) {
//         slots.add(currentTime);
//       }
//       // Add 30 minutes to the current time
//       currentTime = _addMinutes(currentTime, 30);
//     }

//     setState(() {
//       timeSlots.addAll(slots); // Add generated slots to the list
//     });
//   }

//   TimeOfDay _addMinutes(TimeOfDay time, int minutes) {
//     final totalMinutes = time.hour * 60 + time.minute + minutes;
//     final hours = totalMinutes ~/ 60;
//     final mins = totalMinutes % 60;
//     return TimeOfDay(hour: hours, minute: mins);
//   }

//   void _onTimeSelected(TimeOfDay time) {
//     setState(() {
//       selectedTime = time;
//     });
//   }

//   DateTime? get selectedDateTime {
//     if (selectedDate != null && selectedTime != null) {
//       return DateTime(
//         selectedDate!.year,
//         selectedDate!.month,
//         selectedDate!.day,
//         selectedTime!.hour,
//         selectedTime!.minute,
//       );
//     }
//     return null;
//   }

//   Future<void> _onBookAppointment() async {
//     if (selectedDate != null && selectedTime != null) {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? accessToken = prefs.getString('access_token');
//       int? patientDetailsId =
//           prefs.getInt('patient_details_id'); // Retrieve patient_details_id

//       if (accessToken == null || patientDetailsId == null) {
//         print(
//             'Access token or patient details ID not found. Please log in again.');
//         return;
//       }

//       final appointmentData = {
//         "date_time": selectedDateTime?.toIso8601String(),
//         "service_type": "teleconsultation",
//         "status": "booked",
//         "notes": "string",
//         "appointment_address": "string",
//         "is_follow_up": false,
//         "is_confirmed": false,
//         "patient": patientDetailsId, // Use patient_details_id instead of userId
//         "doctor": widget.doctorDetailsId,
//         "services": [widget.doctorDetailsId],
//       };

//       try {
//         final response = await http.post(
//           Uri.parse('https://abdokh.pythonanywhere.com/api/appointments/'),
//           headers: {
//             'Accept': 'application/json',
//             'Content-Type': 'application/json',
//             'Authorization': 'Bearer $accessToken',
//           },
//           body: json.encode(appointmentData),
//         );

//         if (response.statusCode == 201) {
//           // Add the selected time slot to the bookedSlots set
//           setState(() {
//             bookedSlots.add(selectedTime!); // Mark the slot as booked
//             timeSlots.removeWhere((slot) =>
//                 slot.hour == selectedTime!.hour &&
//                 slot.minute == selectedTime!.minute); // Remove from timeSlots
//             selectedTime = null; // Clear the selected time
//           });

//           // Refresh the available slots
//           await _fetchAvailableSlots();

//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Appointment successfully booked!'),
//               backgroundColor: Colors.green,
//             ),
//           );
//         } else {
//           final responseBody = json.decode(response.body);
//           print('Error Response Body: $responseBody');

//           String errorMessage =
//               'Another user booked this appointment. Please select another time.';
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('$errorMessage'),
//               backgroundColor: Colors.red,
//             ),
//           );
//         }
//       } catch (e) {
//         print('Error booking appointment: $e');
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content:
//                 Text('Failed to book appointment. Please try again later.'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content:
//               Text('Please fill in all the details to book an appointment'),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: _buildAppBar(),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               DoctorProfileHeader(doctor: widget.doctor),
//               const SizedBox(height: 16),
//               const Text(
//                 "Select Appointment Date",
//                 style: TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.black),
//               ),
//               const SizedBox(height: 10),
//               GestureDetector(
//                 onTap: () async {
//                   final DateTime? picked = await showDatePicker(
//                     context: context,
//                     initialDate: selectedDate ?? DateTime.now(),
//                     firstDate: DateTime.now(),
//                     lastDate: DateTime.now().add(const Duration(days: 30)),
//                   );
//                   if (picked != null && picked != selectedDate) {
//                     _onDateSelected(picked); // Call the date selected method
//                   }
//                 },
//                 child: Card(
//                   elevation: 5,
//                   color: selectedDate == null
//                       ? Colors.grey[300]
//                       : Colors.teal[100],
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 16.0),
//                     child: Center(
//                       child: Text(
//                         selectedDate == null
//                             ? 'Select Date'
//                             : DateFormat('yMMMd').format(selectedDate!),
//                         style: TextStyle(
//                           color: selectedDate == null
//                               ? Colors.black
//                               : Colors.teal[800],
//                           fontSize: 18,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 "Select Appointment Time",
//                 style: TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.black),
//               ),
//               const SizedBox(height: 10),
//               // Display generated time slots
//               GridView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 4,
//                   crossAxisSpacing: 12,
//                   mainAxisSpacing: 12,
//                 ),
//                 itemCount: timeSlots.length,
//                 itemBuilder: (context, index) {
//                   final slot = timeSlots[index];
//                   return GestureDetector(
//                     onTap: () => _onTimeSelected(slot), // Select the time slot
//                     child: AnimatedContainer(
//                       duration: const Duration(milliseconds: 300),
//                       decoration: BoxDecoration(
//                         color: selectedTime == slot
//                             ? Colors.teal
//                             : Colors.grey[300],
//                         borderRadius: BorderRadius.circular(15),
//                         boxShadow: [
//                           if (selectedTime == slot)
//                             BoxShadow(
//                               color: Colors.teal.withOpacity(0.4),
//                               spreadRadius: 3,
//                               blurRadius: 6,
//                             )
//                         ],
//                       ),
//                       child: Center(
//                         child: Text(
//                           slot.format(context), // Format the time slot
//                           style: TextStyle(
//                             color: selectedTime == slot
//                                 ? Colors.white
//                                 : Colors.black,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//               const SizedBox(height: 40),
//               ElevatedButton(
//                 onPressed: _onBookAppointment,
//                 style: ElevatedButton.styleFrom(
//                   minimumSize: const Size(double.infinity, 50),
//                   backgroundColor: Colors.teal,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                 ),
//                 child: const Text(
//                   'Book Appointment',
//                   style: TextStyle(fontSize: 18, color: Colors.white),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   PreferredSizeWidget _buildAppBar() {
//     return AppBar(
//       backgroundColor: Colors.white,
//       foregroundColor: primaryColor,
//       elevation: 0,
//       title: const Text(
//         'Session Booking',
//         style: TextStyle(color: primaryColor),
//       ),
//       centerTitle: true,
//     );
//   }
// }
