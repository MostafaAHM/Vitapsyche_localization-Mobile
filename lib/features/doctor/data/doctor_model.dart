class DoctorModel {
  final int id;
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String birthDate;
  final String gender;
  final String nationality;
  final String currentResidence;
  final String fluentLanguages;
  final DoctorDetails doctorDetails;
  final String role;
  final String? image;

  DoctorModel({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.birthDate,
    required this.gender,
    required this.nationality,
    required this.currentResidence,
    required this.fluentLanguages,
    required this.doctorDetails,
    required this.role,
    this.image,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'] ?? 0, // Provide a default value if null
      username: json['username'] ?? '', // Provide a default value if null
      firstName: json['first_name'] ?? '', // Provide a default value if null
      lastName: json['last_name'] ?? '', // Provide a default value if null
      email: json['email'] ?? '', // Provide a default value if null
      phoneNumber:
          json['phone_number'] ?? '', // Provide a default value if null
      birthDate: json['birth_date'] ?? '', // Provide a default value if null
      gender: json['gender'] ?? '', // Provide a default value if null
      nationality: json['nationality'] ?? '', // Provide a default value if null
      currentResidence:
          json['current_residence'] ?? '', // Provide a default value if null
      fluentLanguages:
          json['fluent_languages'] ?? '', // Provide a default value if null
      doctorDetails:
          DoctorDetails.fromJson(json['doctor_details'] ?? {}), // Handle null
      role: json['role'] ?? '', // Provide a default value if null
      image: json['image'], // This is already nullable
    );
  }
}

class DoctorDetails {
  final int id;
  final String email;
  final String specialization;
  final String? anotherQualification1;
  final String? anotherQualification2;
  final int yearsOfExperience;
  final String clinicName;
  final bool availabilityForSessions;

  DoctorDetails({
    required this.id,
    required this.email,
    required this.specialization,
    this.anotherQualification1,
    this.anotherQualification2,
    required this.yearsOfExperience,
    required this.clinicName,
    required this.availabilityForSessions,
  });

  factory DoctorDetails.fromJson(Map<String, dynamic> json) {
    return DoctorDetails(
      id: json['id'] ?? 0, // Provide a default value if null
      email: json['email'] ?? '', // Provide a default value if null
      specialization:
          json['specialization'] ?? '', // Provide a default value if null
      anotherQualification1: json['another_qualification1'], // This is nullable
      anotherQualification2: json['another_qualification2'], // This is nullable
      yearsOfExperience:
          json['years_of_experience'] ?? 0, // Provide a default value if null
      clinicName: json['clinic_name'] ?? '', // Provide a default value if null
      availabilityForSessions: json['availability_for_sessions'] ??
          false, // Provide a default value if null
    );
  }
}
