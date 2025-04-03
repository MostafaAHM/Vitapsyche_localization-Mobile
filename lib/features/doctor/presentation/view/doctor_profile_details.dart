import 'package:flutter/material.dart';
import 'package:flutter_mindmed_project/core/theme/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// import '../widget/custom_expansion_tile.dart';
import '../widget/profile_header.dart';
// import '../widget/profile_info_item.dart';

class DoctorProfileDetails extends StatefulWidget {
  final String doctorName;
  final String specialty;
  final String imagePath;
  final String rating;
  final String specification;
  final String country;
  final String joiningDate;
  final String sessions;
  final String salary;
  final String firstCharacter;
  final int doctorDetailsId;

  const DoctorProfileDetails({
    super.key,
    required this.doctorName,
    required this.specialty,
    required this.imagePath,
    required this.rating,
    required this.specification,
    required this.country,
    required this.joiningDate,
    required this.sessions,
    required this.salary,
    required this.firstCharacter,
    required this.doctorDetailsId,
  });

  @override
  _DoctorProfileDetailsState createState() => _DoctorProfileDetailsState();
}

class _DoctorProfileDetailsState extends State<DoctorProfileDetails> {
  final _formKey = GlobalKey<FormState>();
  final _ratingController = TextEditingController();
  final _commentController = TextEditingController();
  bool _isPositive = true;
  List<dynamic> _reviews = []; // To store fetched reviews

  @override
  void initState() {
    super.initState();
    _fetchReviews(); // Fetch reviews when the screen loads
  }

  Future<void> _fetchReviews() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? patientDetailsId = prefs.getInt('patient_details_id');
    String? accessToken = prefs.getString('access_token');

    if (patientDetailsId == null || accessToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Patient details or access token not found.')),
      );
      return;
    }

    final url = Uri.parse(
        'https://abdokh.pythonanywhere.com/api/reviews/?doctor_id=${widget.doctorDetailsId}&patient_id=$patientDetailsId');
    final headers = {
      'accept': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        setState(() {
          _reviews = jsonDecode(response.body);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch reviews: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching reviews: $e')),
      );
    }
  }

  Future<void> _submitReview() async {
    if (_formKey.currentState!.validate()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? patientDetailsId = prefs.getInt('patient_details_id');
      String? accessToken = prefs.getString('access_token');

      if (patientDetailsId == null || accessToken == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Patient details or access token not found.')),
        );
        return;
      }

      final url = Uri.parse('https://abdokh.pythonanywhere.com/api/reviews/');
      final headers = {
        'accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };
      final body = jsonEncode({
        "rating": int.parse(_ratingController.text),
        "comment": _commentController.text,
        "is_positive": _isPositive,
        "patient": patientDetailsId,
        "doctor": widget.doctorDetailsId,
      });

      try {
        final response = await http.post(url, headers: headers, body: body);

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Review submitted successfully!')),
          );
          _fetchReviews(); // Refresh reviews after submission
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Failed to submit review: ${response.body}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting review: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.doctorName,
          style: TextStyle(color: Colors.black, fontSize: 20.sp),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileCard(),
            const SizedBox(height: 20),
            _buildReviewForm(),
            const SizedBox(height: 20),
            _buildReviewsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Card(
      color: Colors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileHeader(
              imagePath: widget.imagePath,
              name: widget.doctorName,
              specialty: widget.specialty,
              rating: widget.rating,
            ),
            const SizedBox(height: 16),
            Text(
              'Specification: ${widget.specification}',
              style: TextStyle(fontSize: 14.sp, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(Icons.public, 'Country', widget.country),
            _buildInfoRow(Icons.date_range, 'Joining Date', widget.joiningDate),
            _buildInfoRow(Icons.event, 'Sessions', widget.sessions),
            _buildInfoRow(Icons.attach_money, 'Salary', widget.salary),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20.sp, color: Colors.grey),
          const SizedBox(width: 8),
          Text(
            '$label: $value',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewForm() {
    return Card(
      color: Colors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _ratingController,
                decoration: InputDecoration(
                  labelText: 'Rating (1-5)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a rating';
                  }
                  final rating = int.tryParse(value);
                  if (rating == null || rating < 1 || rating > 5) {
                    return 'Rating must be between 1 and 5';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _commentController,
                decoration: InputDecoration(
                  labelText: 'Comment',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a comment';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Is Positive Review?'),
                value: _isPositive,
                onChanged: (value) {
                  setState(() {
                    _isPositive = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  elevation: 6,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Submit Review',
                  style: TextStyle(
                    color: secoundryColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReviewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reviews',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _reviews.isEmpty
            ? const Center(child: Text('No reviews found.'))
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _reviews.length,
                itemBuilder: (context, index) {
                  final review = _reviews[index];
                  return Card(
                    color: Colors.white,
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text('Rating: ${review['rating']}'),
                      subtitle: Text(review['comment']),
                      trailing: Icon(
                        review['is_positive']
                            ? Icons.thumb_up
                            : Icons.thumb_down,
                        color:
                            review['is_positive'] ? Colors.green : Colors.red,
                      ),
                    ),
                  );
                },
              ),
      ],
    );
  }
}
