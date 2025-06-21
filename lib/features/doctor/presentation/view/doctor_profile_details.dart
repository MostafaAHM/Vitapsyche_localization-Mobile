import 'package:flutter/material.dart';
import 'package:flutter_mindmed_project/core/theme/colors.dart';
import 'package:flutter_mindmed_project/generated/l10n.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


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
  List<dynamic> _reviews = [];
  bool _hasAccessToken = false;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _checkAccessToken();
  }

  Future<void> _checkAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _hasAccessToken = prefs.getString('access_token') != null;
    });
    if (_hasAccessToken) {
      _fetchReviews();
    }
  }

  Future<void> _fetchReviews() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? patientDetailsId = prefs.getInt('patient_details_id');
    String? accessToken = prefs.getString('access_token');

    if (patientDetailsId == null || accessToken == null) {
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
      }
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> _submitReview() async {
    if (_formKey.currentState!.validate()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? patientDetailsId = prefs.getInt('patient_details_id');
      String? accessToken = prefs.getString('access_token');

      if (patientDetailsId == null || accessToken == null) {
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
            SnackBar(content: Text(S.of(context).reviewSubmittedSuccessfully)),
          );
          _fetchReviews();
          _ratingController.clear();
          _commentController.clear();
        }
      } catch (e) {
        // Handle error silently
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = S.of(context);
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.h,
            pinned: true,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground],
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Background image or gradient
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          primaryColor.withOpacity(0.9),
                          primaryColor.withBlue(200).withOpacity(0.8),
                        ],
                      ),
                    ),
                  ),

                  // Doctor image with decorative elements
                  Positioned(
                    top: 70.h,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        // Decorative circle behind avatar
                        Container(
                          width: 140.w,
                          height: 140.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 2.w,
                            ),
                          ),
                          child: Center(
                            child: Container(
                              width: 120.w,
                              height: 120.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.5),
                                  width: 3.w,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 55.r,
                                backgroundColor: Colors.white.withOpacity(0.2),
                                backgroundImage: widget.imagePath.isNotEmpty
                                    ? NetworkImage(widget.imagePath)
                                    : null,
                                child: widget.imagePath.isEmpty
                                    ? Text(
                                        widget.firstCharacter,
                                        style: TextStyle(
                                          fontSize: 42.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      )
                                    : null,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 20.h),

                        // Doctor name with verified badge
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.doctorName,
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Icon(Icons.verified,
                                color: Colors.white, size: 20.sp),
                          ],
                        ),

                        SizedBox(height: 5.h),

                        // Specialty with rating
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.specialty,
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              child: Container(
                                width: 5.w,
                                height: 5.w,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.7),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            Icon(Icons.star, color: Colors.amber, size: 18.sp),
                            SizedBox(width: 4.w),
                            Text(
                              widget.rating,
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 15.h),

                        // Quick stats row
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 30.w),
                          padding: EdgeInsets.symmetric(
                              vertical: 12.h, horizontal: 20.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatItem(Icons.people,
                                  '${widget.sessions}+', localizations.patients),
                              _buildStatItem(Icons.work,
                                  widget.joiningDate.split('-').first, localizations.experience),
                              _buildStatItem(
                                  Icons.attach_money, widget.salary, localizations.fee),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Back button with transparent background
                  Positioned(
                    top: 40.h,
                    left: 15.w,
                    child: Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.2),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rating and basic info card
                  Card(
                    color: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.r),
                      side: BorderSide(
                        color: Colors.grey.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(15.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildInfoItem(Icons.star, localizations.rating, widget.rating),
                          _buildInfoItem(Icons.medical_services, localizations.specialty,
                              widget.specification),
                          _buildInfoItem(
                              Icons.payments, localizations.fee, '\$${widget.salary}'),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // About section
                  Text(
                    localizations.aboutDoctor,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(15.w),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow(
                            Icons.location_on, localizations.country, widget.country),
                        SizedBox(height: 10.h),
                        _buildDetailRow(
                            Icons.calendar_today, localizations.joined, widget.joiningDate),
                        SizedBox(height: 10.h),
                        _buildDetailRow(
                            Icons.event_available, localizations.sessions, widget.sessions),
                      ],
                    ),
                  ),
                  SizedBox(height: 25.h),

                  // Reviews section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        localizations.patientReviews,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (_reviews.isNotEmpty)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isExpanded = !_isExpanded;
                            });
                          },
                          child: Text(
                            _isExpanded ? localizations.showLess : localizations.showAll,
                            style: TextStyle(color: primaryColor),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 10.h),

                  if (_reviews.isEmpty)
                    Center(
                      child: Text(
                        localizations.noReviewsYet,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  else
                    Column(
                      children: [
                        ..._reviews
                            .take(_isExpanded ? _reviews.length : 1)
                            .map((review) => _buildReviewCard(review, localizations))
                            .toList(),
                      ],
                    ),

                  if (_hasAccessToken) ...[
                    SizedBox(height: 25.h),
                    Text(
                      localizations.leaveYourReview,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15.h),
                    Card(
                      color: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.r),
                        side: BorderSide(
                          color: Colors.grey.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(15.w),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _ratingController,
                                      decoration: InputDecoration(
                                        labelText: '${localizations.rating} (1-5)',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                        ),
                                        prefixIcon: Icon(Icons.star),
                                      ),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return localizations.ratingRequired;
                                        }
                                        final rating = int.tryParse(value);
                                        if (rating == null ||
                                            rating < 1 ||
                                            rating > 5) {
                                          return localizations.ratingRange;
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Column(
                                    children: [
                                      Text(localizations.positive,
                                          style: TextStyle(fontSize: 12.sp)),
                                      Switch(
                                        value: _isPositive,
                                        onChanged: (value) {
                                          setState(() {
                                            _isPositive = value;
                                          });
                                        },
                                        activeColor: primaryColor,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 15.h),
                              TextFormField(
                                controller: _commentController,
                                decoration: InputDecoration(
                                  labelText: localizations.yourReview,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  prefixIcon: Icon(Icons.comment),
                                ),
                                maxLines: 3,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return localizations.reviewRequired;
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 15.h),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _submitReview,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    padding:
                                        EdgeInsets.symmetric(vertical: 15.h),
                                  ),
                                  child: Text(
                                    localizations.submitReview,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String title, String value) {
    return Column(
      children: [
        Icon(icon, size: 24.sp, color: primaryColor),
        SizedBox(height: 5.h),
        Text(
          title,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, size: 20.sp, color: Colors.grey[600]),
        SizedBox(width: 10.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey[600],
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 24.sp, color: Colors.white),
        SizedBox(height: 5.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review, localizations) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 10.h),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(
          color: Colors.grey.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: primaryColor.withOpacity(0.1),
                  child: Icon(
                    Icons.person,
                    color: primaryColor,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations.anonymousPatient,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 16.sp),
                          SizedBox(width: 5.w),
                          Text(
                            '${review['rating']}',
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  review['is_positive'] ? Icons.thumb_up : Icons.thumb_down,
                  color: review['is_positive'] ? Colors.green : Colors.red,
                  size: 20.sp,
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Text(
              review['comment'],
              style: TextStyle(fontSize: 14.sp),
            ),
            SizedBox(height: 10.h),
            Text(
              '2 ${localizations.daysAgo}', // You might want to replace this with actual date from review
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}