import 'package:flutter/material.dart';
import 'package:flutter_mindmed_project/generated/l10n.dart';
import '../../../../core/theme/colors.dart';

class DoctorFilterDialog extends StatefulWidget {
  const DoctorFilterDialog({super.key});

  @override
  State<DoctorFilterDialog> createState() => _DoctorFilterDialogState();
}

class _DoctorFilterDialogState extends State<DoctorFilterDialog> {
  String selectedAvailability = 'Today';
  String selectedDuration = 'All';
  String selectedGender = 'Male';
  int selectedRating = 5;
  String selectedCountry = 'USA';
  String selectedCity = 'New York';
  double selectedSalaryRange = 100;
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final localizations = S.of(context);
    
    return Container(
      height: 600,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(localizations),
            const SizedBox(height: 20),
            _buildAvailabilitySection(localizations),
            _buildDateSection(localizations),
            _buildInterestsSection(localizations),
            _buildDurationSection(localizations),
            _buildGenderSection(localizations),
            _buildRatingSection(localizations),
            _buildLocationSection(localizations),
            _buildSalarySection(localizations),
            _buildApplyButton(localizations),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(S localizations) {
    return Text(
      localizations.filterOptions,
      style: const TextStyle(
        fontSize: 18,
        color: primaryColor,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildAvailabilitySection(S localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(Icons.access_time, localizations.availability),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            localizations.today,
            localizations.thisWeek,
            localizations.online
          ].map((value) {
            return Row(
              children: [
                Radio<String>(
                  value: value,
                  groupValue: selectedAvailability,
                  onChanged: (String? newValue) {
                    setState(() => selectedAvailability = newValue!);
                  },
                ),
                Text(value),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDateSection(S localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(Icons.date_range, localizations.specificDateOrRange),
        TextButton(
          onPressed: () async {
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: selectedDate,
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (pickedDate != null) {
              setState(() => selectedDate = pickedDate);
            }
          },
          child: Text(selectedDate.toString().split(' ')[0]),
        ),
      ],
    );
  }

  Widget _buildInterestsSection(S localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(Icons.location_on, localizations.areasOfInterest),
        DropdownButton<String>(
          isExpanded: true,
          hint: Text(localizations.selectLanguage),
          items: [
            localizations.english,
            localizations.spanish,
            localizations.french,
            localizations.german
          ].map((value) => DropdownMenuItem(value: value, child: Text(value)))
              .toList(),
          onChanged: (String? newValue) {},
        ),
      ],
    );
  }

  Widget _buildDurationSection(S localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(Icons.timer, localizations.duration),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            localizations.all,
            '30 ${localizations.min}',
            '60 ${localizations.min}'
          ].map((value) {
            return Row(
              children: [
                Radio<String>(
                  value: value,
                  groupValue: selectedDuration,
                  onChanged: (String? newValue) {
                    setState(() => selectedDuration = newValue!);
                  },
                ),
                Text(value),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildGenderSection(S localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(Icons.person, localizations.therapistGender),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [localizations.male, localizations.female].map((value) {
            return Row(
              children: [
                Radio<String>(
                  value: value,
                  groupValue: selectedGender,
                  onChanged: (String? newValue) {
                    setState(() => selectedGender = newValue!);
                  },
                ),
                Text(value),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRatingSection(S localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(Icons.star, localizations.rating),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(5, (index) {
            return IconButton(
              icon: Icon(
                index < selectedRating ? Icons.star : Icons.star_border,
                color: index < selectedRating ? Colors.amber : Colors.grey,
              ),
              onPressed: () => setState(() => selectedRating = index + 1),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildLocationSection(S localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(Icons.public, localizations.countryAndCity),
        DropdownButton<String>(
          isExpanded: true,
          value: selectedCountry,
          items: [
            localizations.usa,
            localizations.canada,
            localizations.uk,
            localizations.australia
          ].map((value) => DropdownMenuItem(value: value, child: Text(value)))
              .toList(),
          onChanged: (String? newValue) {
            setState(() => selectedCountry = newValue!);
          },
        ),
        const SizedBox(height: 10),
        DropdownButton<String>(
          isExpanded: true,
          value: selectedCity,
          items: [
            localizations.newYork,
            localizations.toronto,
            localizations.london,
            localizations.sydney
          ].map((value) => DropdownMenuItem(value: value, child: Text(value)))
              .toList(),
          onChanged: (String? newValue) {
            setState(() => selectedCity = newValue!);
          },
        ),
      ],
    );
  }

  Widget _buildSalarySection(S localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(Icons.attach_money, localizations.salaryRange),
        Slider(
          value: selectedSalaryRange,
          min: 50,
          max: 500,
          divisions: 9,
          label: '${localizations.currencySymbol}${selectedSalaryRange.round()}',
          onChanged: (value) => setState(() => selectedSalaryRange = value),
        ),
      ],
    );
  }

  Widget _buildApplyButton(S localizations) {
    return Center(
      child: ElevatedButton(
        onPressed: () => Navigator.pop(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
        ),
        child: Text(
          localizations.applyFilter,
          style: const TextStyle(color: secoundryColor),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: mainBlueColor),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}