// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Vitapsyche`
  String get appTitle {
    return Intl.message('Vitapsyche', name: 'appTitle', desc: '', args: []);
  }

  /// `The journey to healing starts here...`
  String get welcomeSubtitle {
    return Intl.message(
      'The journey to healing starts here...',
      name: 'welcomeSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Sign in`
  String get signIn {
    return Intl.message('Sign in', name: 'signIn', desc: '', args: []);
  }

  /// `If you don't have an account?`
  String get signIntext {
    return Intl.message(
      'If you don\'t have an account?',
      name: 'signIntext',
      desc: '',
      args: [],
    );
  }

  /// `Sign up`
  String get signUp {
    return Intl.message('Sign up', name: 'signUp', desc: '', args: []);
  }

  /// `Doctor Registration`
  String get doctorRegistration {
    return Intl.message(
      'Doctor Registration',
      name: 'doctorRegistration',
      desc: '',
      args: [],
    );
  }

  /// `or`
  String get orDivider {
    return Intl.message('or', name: 'orDivider', desc: '', args: []);
  }

  /// `Continue as Guest`
  String get continueAsGuest {
    return Intl.message(
      'Continue as Guest',
      name: 'continueAsGuest',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get currentLanguage {
    return Intl.message('English', name: 'currentLanguage', desc: '', args: []);
  }

  /// `Doctor`
  String get Doctor {
    return Intl.message('Doctor', name: 'Doctor', desc: '', args: []);
  }

  /// `patient`
  String get patient {
    return Intl.message('patient', name: 'patient', desc: '', args: []);
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Username`
  String get username {
    return Intl.message('Username', name: 'username', desc: '', args: []);
  }

  /// `First Name`
  String get firstName {
    return Intl.message('First Name', name: 'firstName', desc: '', args: []);
  }

  /// `Last Name`
  String get lastName {
    return Intl.message('Last Name', name: 'lastName', desc: '', args: []);
  }

  /// `full Name`
  String get fullName {
    return Intl.message('full Name', name: 'fullName', desc: '', args: []);
  }

  /// `Phone Number`
  String get phone {
    return Intl.message('Phone Number', name: 'phone', desc: '', args: []);
  }

  /// `Birthdate`
  String get birthdate {
    return Intl.message('Birthdate', name: 'birthdate', desc: '', args: []);
  }

  /// `Confirm Password`
  String get confirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Gender`
  String get gender {
    return Intl.message('Gender', name: 'gender', desc: '', args: []);
  }

  /// `Nationality`
  String get nationality {
    return Intl.message('Nationality', name: 'nationality', desc: '', args: []);
  }

  /// `Fluent Language`
  String get fluentLanguage {
    return Intl.message(
      'Fluent Language',
      name: 'fluentLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Current Residence`
  String get currentResidence {
    return Intl.message(
      'Current Residence',
      name: 'currentResidence',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submit {
    return Intl.message('Submit', name: 'submit', desc: '', args: []);
  }

  /// `Male`
  String get male {
    return Intl.message('Male', name: 'male', desc: '', args: []);
  }

  /// `Female`
  String get female {
    return Intl.message('Female', name: 'female', desc: '', args: []);
  }

  /// `Other`
  String get other {
    return Intl.message('Other', name: 'other', desc: '', args: []);
  }

  /// `Select Date`
  String get selectDate {
    return Intl.message('Select Date', name: 'selectDate', desc: '', args: []);
  }

  /// `This field is required`
  String get requiredField {
    return Intl.message(
      'This field is required',
      name: 'requiredField',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get passwordMismatch {
    return Intl.message(
      'Passwords do not match',
      name: 'passwordMismatch',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email`
  String get invalidEmail {
    return Intl.message(
      'Please enter a valid email',
      name: 'invalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid phone number`
  String get invalidPhone {
    return Intl.message(
      'Please enter a valid phone number',
      name: 'invalidPhone',
      desc: '',
      args: [],
    );
  }

  /// `Personal Information`
  String get personalInformation {
    return Intl.message(
      'Personal Information',
      name: 'personalInformation',
      desc: '',
      args: [],
    );
  }

  /// `Professional Information`
  String get professionalInformation {
    return Intl.message(
      'Professional Information',
      name: 'professionalInformation',
      desc: '',
      args: [],
    );
  }

  /// `Documents & Preferences`
  String get documentsPreferences {
    return Intl.message(
      'Documents & Preferences',
      name: 'documentsPreferences',
      desc: '',
      args: [],
    );
  }

  /// `Prefix`
  String get prefix {
    return Intl.message('Prefix', name: 'prefix', desc: '', args: []);
  }

  /// `Institution`
  String get institution {
    return Intl.message('Institution', name: 'institution', desc: '', args: []);
  }

  /// `Degree`
  String get degree {
    return Intl.message('Degree', name: 'degree', desc: '', args: []);
  }

  /// `Graduation Year`
  String get graduationYear {
    return Intl.message(
      'Graduation Year',
      name: 'graduationYear',
      desc: '',
      args: [],
    );
  }

  /// `Years of Experience`
  String get yearOfExperience {
    return Intl.message(
      'Years of Experience',
      name: 'yearOfExperience',
      desc: '',
      args: [],
    );
  }

  /// `License Number`
  String get licenseNumber {
    return Intl.message(
      'License Number',
      name: 'licenseNumber',
      desc: '',
      args: [],
    );
  }

  /// `Category`
  String get category {
    return Intl.message('Category', name: 'category', desc: '', args: []);
  }

  /// `Specialization`
  String get specialization {
    return Intl.message(
      'Specialization',
      name: 'specialization',
      desc: '',
      args: [],
    );
  }

  /// `Clinic Name`
  String get clinicName {
    return Intl.message('Clinic Name', name: 'clinicName', desc: '', args: []);
  }

  /// `Upload CV`
  String get uploadCV {
    return Intl.message('Upload CV', name: 'uploadCV', desc: '', args: []);
  }

  /// `Upload Qualifications`
  String get uploadQualifications {
    return Intl.message(
      'Upload Qualifications',
      name: 'uploadQualifications',
      desc: '',
      args: [],
    );
  }

  /// `Upload Profile Image`
  String get uploadProfileImage {
    return Intl.message(
      'Upload Profile Image',
      name: 'uploadProfileImage',
      desc: '',
      args: [],
    );
  }

  /// `No file selected`
  String get noFileSelected {
    return Intl.message(
      'No file selected',
      name: 'noFileSelected',
      desc: '',
      args: [],
    );
  }

  /// `Available for Sessions`
  String get availableForSessions {
    return Intl.message(
      'Available for Sessions',
      name: 'availableForSessions',
      desc: '',
      args: [],
    );
  }

  /// `Multiple Qualifications`
  String get multipleQualifications {
    return Intl.message(
      'Multiple Qualifications',
      name: 'multipleQualifications',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message('Next', name: 'next', desc: '', args: []);
  }

  /// `Back`
  String get back {
    return Intl.message('Back', name: 'back', desc: '', args: []);
  }

  /// `Mr.`
  String get mr {
    return Intl.message('Mr.', name: 'mr', desc: '', args: []);
  }

  /// `Mrs.`
  String get mrs {
    return Intl.message('Mrs.', name: 'mrs', desc: '', args: []);
  }

  /// `Dr.`
  String get dr {
    return Intl.message('Dr.', name: 'dr', desc: '', args: []);
  }

  /// `Prof.`
  String get prof {
    return Intl.message('Prof.', name: 'prof', desc: '', args: []);
  }

  /// `Select Category`
  String get selectCategory {
    return Intl.message(
      'Select Category',
      name: 'selectCategory',
      desc: '',
      args: [],
    );
  }

  /// `Select Specialization`
  String get selectSpecialization {
    return Intl.message(
      'Select Specialization',
      name: 'selectSpecialization',
      desc: '',
      args: [],
    );
  }

  /// `Psychiatrist`
  String get psychiatrist {
    return Intl.message(
      'Psychiatrist',
      name: 'psychiatrist',
      desc: '',
      args: [],
    );
  }

  /// `Psychologist`
  String get psychologist {
    return Intl.message(
      'Psychologist',
      name: 'psychologist',
      desc: '',
      args: [],
    );
  }

  /// `Therapist`
  String get therapist {
    return Intl.message('Therapist', name: 'therapist', desc: '', args: []);
  }

  /// `Counselor`
  String get counselor {
    return Intl.message('Counselor', name: 'counselor', desc: '', args: []);
  }

  /// `Select Degree`
  String get selectDegree {
    return Intl.message(
      'Select Degree',
      name: 'selectDegree',
      desc: '',
      args: [],
    );
  }

  /// `Bachelor`
  String get bachelor {
    return Intl.message('Bachelor', name: 'bachelor', desc: '', args: []);
  }

  /// `Master`
  String get master {
    return Intl.message('Master', name: 'master', desc: '', args: []);
  }

  /// `PhD`
  String get phd {
    return Intl.message('PhD', name: 'phd', desc: '', args: []);
  }

  /// `MD`
  String get md {
    return Intl.message('MD', name: 'md', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
