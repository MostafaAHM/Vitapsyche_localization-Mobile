import 'package:flutter/material.dart';
import 'package:flutter_mindmed_project/core/theme/colors.dart';
import 'package:flutter_mindmed_project/generated/l10n.dart';

class UserTypeSelection extends StatelessWidget {
  final bool isPatientSelected;
  final bool isDoctorSelected;
  final Function(bool) onPatientSelected;
  final Function(bool) onDoctorSelected;
  final VoidCallback onPatientSelectedNavigation; // New callback
  final VoidCallback onDoctorSelectedNavigation; // New callback

  const UserTypeSelection({
    Key? key,
    required this.isPatientSelected,
    required this.isDoctorSelected,
    required this.onPatientSelected,
    required this.onDoctorSelected,
    required this.onPatientSelectedNavigation, // New callback
    required this.onDoctorSelectedNavigation, // New callback
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = S.of(context); // Renamed from S to localizations
    // Trigger navigation if patient is selected by default
    if (isPatientSelected) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        onPatientSelectedNavigation();
      });
    }

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Patient Section
          GestureDetector(
            onTap: () {
              onPatientSelected(true);
              onDoctorSelected(false);
              onPatientSelectedNavigation(); // Trigger navigation
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundColor:
                      isPatientSelected ? primaryColor : Colors.grey[300],
                  child: Image.asset(
                    'assets/images/patient.png',
                    width: 50,
                    height: 50,
                    color: isPatientSelected ? Colors.white : null,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  localizations.patient,
                  style: TextStyle(
                    color: isPatientSelected ? primaryColor : Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 30),

          // Doctor Section
          GestureDetector(
            onTap: () {
              onPatientSelected(false);
              onDoctorSelected(true);
              onDoctorSelectedNavigation(); // Trigger navigation
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundColor:
                      isDoctorSelected ? primaryColor : Colors.grey[300],
                  child: Image.asset(
                    'assets/images/doctor.png',
                    width: 50,
                    height: 50,
                    color: isDoctorSelected ? Colors.white : null,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  localizations.Doctor,
                  style: TextStyle(
                    color: isDoctorSelected ? primaryColor : Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
