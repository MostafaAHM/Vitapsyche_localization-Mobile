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
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      birthDate: json['birth_date'] ?? '',
      gender: json['gender'] ?? '',
      nationality: json['nationality'] ?? '',
      currentResidence: json['current_residence'] ?? '',
      fluentLanguages: json['fluent_languages'] ?? '',
      doctorDetails: DoctorDetails.fromJson(json['doctor_details'] ?? {}),
      role: json['role'] ?? '',
      image: json['image'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone_number': phoneNumber,
      'birth_date': birthDate,
      'gender': gender,
      'nationality': nationality,
      'current_residence': currentResidence,
      'fluent_languages': fluentLanguages,
      'doctor_details': doctorDetails.toMap(),
      'role': role,
      'image': image,
    };
  }

  static fromMap(Map<String, dynamic> map) {
    return DoctorModel(
      id: map['id'] ?? 0,
      username: map['username'] ?? '',
      firstName: map['first_name'] ?? '',
      lastName: map['last_name'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phone_number'] ?? '',
      birthDate: map['birth_date'] ?? '',
      gender: map['gender'] ?? '',
      nationality: map['nationality'] ?? '',
      currentResidence: map['current_residence'] ?? '',
      fluentLanguages: map['fluent_languages'] ?? '',
      doctorDetails: DoctorDetails.fromJson(map['doctor_details'] ?? {}),
      role: map['role'] ?? '',
      image: map['image'],
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
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      specialization: json['specialization'] ?? '',
      anotherQualification1: json['another_qualification1'],
      anotherQualification2: json['another_qualification2'],
      yearsOfExperience: json['years_of_experience'] ?? 0,
      clinicName: json['clinic_name'] ?? '',
      availabilityForSessions: json['availability_for_sessions'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'specialization': specialization,
      'another_qualification1': anotherQualification1,
      'another_qualification2': anotherQualification2,
      'years_of_experience': yearsOfExperience,
      'clinic_name': clinicName,
      'availability_for_sessions': availabilityForSessions,
    };
  }
}