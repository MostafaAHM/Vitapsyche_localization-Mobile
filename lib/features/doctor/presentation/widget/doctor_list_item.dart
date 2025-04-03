import 'package:flutter/material.dart';
import 'package:flutter_mindmed_project/core/theme/colors.dart';
import 'package:flutter_mindmed_project/features/doctor/data/doctor_model.dart';

class DoctorListItem extends StatelessWidget {
  final DoctorModel doctor;
  final VoidCallback onProfileView;
  final VoidCallback onBookView;

  const DoctorListItem({
    super.key,
    required this.doctor,
    required this.onProfileView,
    required this.onBookView,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.all(10),
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            _buildDoctorHeader(),
            const SizedBox(height: 10),
            _buildDoctorInfo(),
            const SizedBox(height: 10),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: doctor.image != null
              ? NetworkImage(
                  'https://abdokh.pythonanywhere.com${doctor.image!}')
              : null,
          onBackgroundImageError: doctor.image != null
              ? (exception, stackTrace) {
                  print('Failed to load image: ${doctor.image}');
                }
              : null,
          child: doctor.image == null
              ? Text(doctor.firstName.substring(0, 1))
              : null,
        ),
        const SizedBox(width: 10),
        _buildDoctorNameAndSpecialty(),
        const Spacer(),
        _buildDoctorStats(),
      ],
    );
  }

  Widget _buildDoctorNameAndSpecialty() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${doctor.firstName} ${doctor.lastName}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(
          doctor.doctorDetails.specialization,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildDoctorStats() {
    return Column(
      children: [
        const Icon(Icons.star, color: Colors.amber),
        const Text('Top Therapist', style: TextStyle(color: Colors.grey)),
        Text('${doctor.doctorDetails.yearsOfExperience} Years Exp',
            style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildDoctorInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(doctor.doctorDetails.clinicName),
            const SizedBox(height: 5),
            _buildInfoRow(Icons.access_time, 'Available'),
            const SizedBox(height: 5),
            _buildInfoRow(Icons.attach_money, 'Salary: \$500/hr'),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.black),
        const SizedBox(width: 5),
        Text(text, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton('View Profile', onProfileView),
        _buildActionButton('Book Now', onBookView),
      ],
    );
  }

  Widget _buildActionButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        shape: const StadiumBorder(),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }
}
