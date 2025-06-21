import 'package:flutter/material.dart';
import 'package:flutter_mindmed_project/generated/l10n.dart';
import '../../data/doctor_model.dart'; // Import the DoctorModel

class DoctorProfileHeader extends StatelessWidget {
  final DoctorModel doctor;

  const DoctorProfileHeader({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundImage: doctor.image != null
              ? NetworkImage('https://abdokh.pythonanywhere.com${doctor.image}')
              : const AssetImage('assets/images/doctor2.png') as ImageProvider,
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${doctor.firstName} ${doctor.lastName}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(doctor.doctorDetails.specialization),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.blue, size: 16),
                Text(
                  S.of(context).ratingValue,
                  style: const TextStyle(color: Colors.blue),
                ),
                Text(
                  S.of(context).totalReviews,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
