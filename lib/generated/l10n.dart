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
    final name = (locale.countryCode?.isEmpty ?? false)
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

  S.of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
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

  /// `Clear your mind, calm your heart`
  String get mindHeartText {
    return Intl.message(
      'Clear your mind, calm your heart',
      name: 'mindHeartText',
      desc: '',
      args: [],
    );
  }

  /// `Our Services`
  String get ourServices {
    return Intl.message(
      'Our Services',
      name: 'ourServices',
      desc: '',
      args: [],
    );
  }

  /// `Lina Service`
  String get linaService {
    return Intl.message(
      'Lina Service',
      name: 'linaService',
      desc: '',
      args: [],
    );
  }

  /// `ChatBot Service`
  String get chatbotService {
    return Intl.message(
      'ChatBot Service',
      name: 'chatbotService',
      desc: '',
      args: [],
    );
  }

  /// `Click to Treat`
  String get clickToTreat {
    return Intl.message(
      'Click to Treat',
      name: 'clickToTreat',
      desc: '',
      args: [],
    );
  }

  /// `Yourself`
  String get yourself {
    return Intl.message('Yourself', name: 'yourself', desc: '', args: []);
  }

  /// `Heart Rate`
  String get heartRate {
    return Intl.message('Heart Rate', name: 'heartRate', desc: '', args: []);
  }

  /// `Test`
  String get test {
    return Intl.message('Test', name: 'test', desc: '', args: []);
  }

  /// `Blog`
  String get blog {
    return Intl.message('Blog', name: 'blog', desc: '', args: []);
  }

  /// `Product`
  String get product {
    return Intl.message('Product', name: 'product', desc: '', args: []);
  }

  /// `FQAs`
  String get fqas {
    return Intl.message('FQAs', name: 'fqas', desc: '', args: []);
  }

  /// `Ask Doctor`
  String get askDoctor {
    return Intl.message('Ask Doctor', name: 'askDoctor', desc: '', args: []);
  }

  /// `Entertainment`
  String get entertainment {
    return Intl.message(
      'Entertainment',
      name: 'entertainment',
      desc: '',
      args: [],
    );
  }

  /// `Doctors Specialists`
  String get doctorsSpecialists {
    return Intl.message(
      'Doctors Specialists',
      name: 'doctorsSpecialists',
      desc: '',
      args: [],
    );
  }

  /// `Get Help`
  String get getHelp {
    return Intl.message('Get Help', name: 'getHelp', desc: '', args: []);
  }

  /// `Talk to Vitapsyche Support`
  String get talkToSupport {
    return Intl.message(
      'Talk to Vitapsyche Support',
      name: 'talkToSupport',
      desc: '',
      args: [],
    );
  }

  /// `Call Vitapsyche Support`
  String get callSupport {
    return Intl.message(
      'Call Vitapsyche Support',
      name: 'callSupport',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message('Home', name: 'home', desc: '', args: []);
  }

  /// `Online AI`
  String get onlineAI {
    return Intl.message('Online AI', name: 'onlineAI', desc: '', args: []);
  }

  /// `More`
  String get more {
    return Intl.message('More', name: 'more', desc: '', args: []);
  }

  /// `Doctor`
  String get doctor {
    return Intl.message('Doctor', name: 'doctor', desc: '', args: []);
  }

  /// `Appointments`
  String get appointments {
    return Intl.message(
      'Appointments',
      name: 'appointments',
      desc: '',
      args: [],
    );
  }

  /// `Appointment`
  String get appointment {
    return Intl.message('Appointment', name: 'appointment', desc: '', args: []);
  }

  /// `No doctors found for`
  String get noDoctorsFound {
    return Intl.message(
      'No doctors found for',
      name: 'noDoctorsFound',
      desc: '',
      args: [],
    );
  }

  /// `Please log in to view therapists`
  String get signInText {
    return Intl.message(
      'Please log in to view therapists',
      name: 'signInText',
      desc: '',
      args: [],
    );
  }

  /// `Our Therapists`
  String get ourTherapists {
    return Intl.message(
      'Our Therapists',
      name: 'ourTherapists',
      desc: '',
      args: [],
    );
  }

  /// `Therapist name or title`
  String get therapistNameOrTitle {
    return Intl.message(
      'Therapist name or title',
      name: 'therapistNameOrTitle',
      desc: '',
      args: [],
    );
  }

  /// `Top Therapist`
  String get topTherapist {
    return Intl.message(
      'Top Therapist',
      name: 'topTherapist',
      desc: '',
      args: [],
    );
  }

  /// `Years Exp`
  String get yearsExp {
    return Intl.message('Years Exp', name: 'yearsExp', desc: '', args: []);
  }

  /// `Available`
  String get available {
    return Intl.message('Available', name: 'available', desc: '', args: []);
  }

  /// `Salary: 500$/hr`
  String get salary {
    return Intl.message('Salary: 500\$/hr', name: 'salary', desc: '', args: []);
  }

  /// `View Profile`
  String get viewProfile {
    return Intl.message(
      'View Profile',
      name: 'viewProfile',
      desc: '',
      args: [],
    );
  }

  /// `Book Now`
  String get bookNow {
    return Intl.message('Book Now', name: 'bookNow', desc: '', args: []);
  }

  /// `Booked`
  String get booked {
    return Intl.message('Booked', name: 'booked', desc: '', args: []);
  }

  /// `Confirmed`
  String get confirmed {
    return Intl.message('Confirmed', name: 'confirmed', desc: '', args: []);
  }

  /// `Cancelled`
  String get cancelled {
    return Intl.message('Cancelled', name: 'cancelled', desc: '', args: []);
  }

  /// `No appointments found`
  String get noAppointments {
    return Intl.message(
      'No appointments found',
      name: 'noAppointments',
      desc: '',
      args: [],
    );
  }

  /// `Appointment #`
  String get appointmentNumber {
    return Intl.message(
      'Appointment #',
      name: 'appointmentNumber',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get date {
    return Intl.message('Date', name: 'date', desc: '', args: []);
  }

  /// `Time`
  String get time {
    return Intl.message('Time', name: 'time', desc: '', args: []);
  }

  /// `Status`
  String get status {
    return Intl.message('Status', name: 'status', desc: '', args: []);
  }

  /// `Loading...`
  String get loading {
    return Intl.message('Loading...', name: 'loading', desc: '', args: []);
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `AI Support`
  String get aiSupport {
    return Intl.message('AI Support', name: 'aiSupport', desc: '', args: []);
  }

  /// `Online Chat Service`
  String get onlineChatService {
    return Intl.message(
      'Online Chat Service',
      name: 'onlineChatService',
      desc: '',
      args: [],
    );
  }

  /// `Online Lina Service`
  String get onlineLinaService {
    return Intl.message(
      'Online Lina Service',
      name: 'onlineLinaService',
      desc: '',
      args: [],
    );
  }

  /// `Languages`
  String get languages {
    return Intl.message('Languages', name: 'languages', desc: '', args: []);
  }

  /// `Contact Us`
  String get contactUs {
    return Intl.message('Contact Us', name: 'contactUs', desc: '', args: []);
  }

  /// `Help & Support`
  String get helpAndSupport {
    return Intl.message(
      'Help & Support',
      name: 'helpAndSupport',
      desc: '',
      args: [],
    );
  }

  /// `Help Center`
  String get helpCenter {
    return Intl.message('Help Center', name: 'helpCenter', desc: '', args: []);
  }

  /// `Terms & Policies`
  String get termsAndPolicies {
    return Intl.message(
      'Terms & Policies',
      name: 'termsAndPolicies',
      desc: '',
      args: [],
    );
  }

  /// `Settings & Privacy`
  String get settingsAndPrivacy {
    return Intl.message(
      'Settings & Privacy',
      name: 'settingsAndPrivacy',
      desc: '',
      args: [],
    );
  }

  /// `Account Settings`
  String get accountSettings {
    return Intl.message(
      'Account Settings',
      name: 'accountSettings',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get privacyPolicy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Social Media`
  String get socialMedia {
    return Intl.message(
      'Social Media',
      name: 'socialMedia',
      desc: '',
      args: [],
    );
  }

  /// `Facebook`
  String get facebook {
    return Intl.message('Facebook', name: 'facebook', desc: '', args: []);
  }

  /// `Instagram`
  String get instagram {
    return Intl.message('Instagram', name: 'instagram', desc: '', args: []);
  }

  /// `Version`
  String get version {
    return Intl.message('Version', name: 'version', desc: '', args: []);
  }

  /// `Select Language`
  String get selectLanguage {
    return Intl.message(
      'Select Language',
      name: 'selectLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Daily Challenge`
  String get dailyChallengeTitle {
    return Intl.message(
      'Daily Challenge',
      name: 'dailyChallengeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Deep Breathing Challenge`
  String get deepBreathingChallenge {
    return Intl.message(
      'Deep Breathing Challenge',
      name: 'deepBreathingChallenge',
      desc: '',
      args: [],
    );
  }

  /// `Take 3 minutes to focus on your breathing. Inhale slowly for a count of 4, hold for 4, then exhale for 6.`
  String get deepBreathingDescription {
    return Intl.message(
      'Take 3 minutes to focus on your breathing. Inhale slowly for a count of 4, hold for 4, then exhale for 6.',
      name: 'deepBreathingDescription',
      desc: '',
      args: [],
    );
  }

  /// `"Deep breathing is an anchor for psychological calmness."`
  String get deepBreathingReward {
    return Intl.message(
      '"Deep breathing is an anchor for psychological calmness."',
      name: 'deepBreathingReward',
      desc: '',
      args: [],
    );
  }

  /// `Emotional Journaling Challenge`
  String get journalingChallenge {
    return Intl.message(
      'Emotional Journaling Challenge',
      name: 'journalingChallenge',
      desc: '',
      args: [],
    );
  }

  /// `Write about your current feelings in your journal without any correction or judgment.`
  String get journalingDescription {
    return Intl.message(
      'Write about your current feelings in your journal without any correction or judgment.',
      name: 'journalingDescription',
      desc: '',
      args: [],
    );
  }

  /// `"When you write, you give your feelings space to express themselves."`
  String get journalingReward {
    return Intl.message(
      '"When you write, you give your feelings space to express themselves."',
      name: 'journalingReward',
      desc: '',
      args: [],
    );
  }

  /// `Write your response here`
  String get writeResponseHere {
    return Intl.message(
      'Write your response here',
      name: 'writeResponseHere',
      desc: '',
      args: [],
    );
  }

  /// `Complete Challenge`
  String get completeChallenge {
    return Intl.message(
      'Complete Challenge',
      name: 'completeChallenge',
      desc: '',
      args: [],
    );
  }

  /// `Your Reward`
  String get yourReward {
    return Intl.message('Your Reward', name: 'yourReward', desc: '', args: []);
  }

  /// `Challenge Completed`
  String get challengeCompleted {
    return Intl.message(
      'Challenge Completed',
      name: 'challengeCompleted',
      desc: '',
      args: [],
    );
  }

  /// `Psychological Games`
  String get psychologicalGames {
    return Intl.message(
      'Psychological Games',
      name: 'psychologicalGames',
      desc: '',
      args: [],
    );
  }

  /// `Choose a game to start`
  String get chooseGameToStart {
    return Intl.message(
      'Choose a game to start',
      name: 'chooseGameToStart',
      desc: '',
      args: [],
    );
  }

  /// `Color Sorting`
  String get colorSorting {
    return Intl.message(
      'Color Sorting',
      name: 'colorSorting',
      desc: '',
      args: [],
    );
  }

  /// `Improve Focus`
  String get improveFocus {
    return Intl.message(
      'Improve Focus',
      name: 'improveFocus',
      desc: '',
      args: [],
    );
  }

  /// `Synchronized Breathing`
  String get synchronizedBreathing {
    return Intl.message(
      'Synchronized Breathing',
      name: 'synchronizedBreathing',
      desc: '',
      args: [],
    );
  }

  /// `Relaxation and Calm`
  String get relaxationAndCalm {
    return Intl.message(
      'Relaxation and Calm',
      name: 'relaxationAndCalm',
      desc: '',
      args: [],
    );
  }

  /// `Memory Game`
  String get memoryGame {
    return Intl.message('Memory Game', name: 'memoryGame', desc: '', args: []);
  }

  /// `Activate Memory`
  String get activateMemory {
    return Intl.message(
      'Activate Memory',
      name: 'activateMemory',
      desc: '',
      args: [],
    );
  }

  /// `Breath`
  String get breath {
    return Intl.message('Breath', name: 'breath', desc: '', args: []);
  }

  /// `Breathe In`
  String get breatheIn {
    return Intl.message('Breathe In', name: 'breatheIn', desc: '', args: []);
  }

  /// `Breathe Out`
  String get breatheOut {
    return Intl.message('Breathe Out', name: 'breatheOut', desc: '', args: []);
  }

  /// `Well done! You completed the exercise`
  String get exerciseCompleted {
    return Intl.message(
      'Well done! You completed the exercise',
      name: 'exerciseCompleted',
      desc: '',
      args: [],
    );
  }

  /// `Start Over`
  String get startOver {
    return Intl.message('Start Over', name: 'startOver', desc: '', args: []);
  }

  /// `Sort the colors from darkest to lightest`
  String get sortColorsInstruction {
    return Intl.message(
      'Sort the colors from darkest to lightest',
      name: 'sortColorsInstruction',
      desc: '',
      args: [],
    );
  }

  /// `Drag and drop the cards to arrange them`
  String get dragAndDropInstruction {
    return Intl.message(
      'Drag and drop the cards to arrange them',
      name: 'dragAndDropInstruction',
      desc: '',
      args: [],
    );
  }

  /// `Well done! You sorted the colors correctly`
  String get correctOrderMessage {
    return Intl.message(
      'Well done! You sorted the colors correctly',
      name: 'correctOrderMessage',
      desc: '',
      args: [],
    );
  }

  /// `Moves`
  String get moves {
    return Intl.message('Moves', name: 'moves', desc: '', args: []);
  }

  /// `Pairs`
  String get pairs {
    return Intl.message('Pairs', name: 'pairs', desc: '', args: []);
  }

  /// `Play Again`
  String get playAgain {
    return Intl.message('Play Again', name: 'playAgain', desc: '', args: []);
  }

  /// `Mood Tracker`
  String get moodTrackerTitle {
    return Intl.message(
      'Mood Tracker',
      name: 'moodTrackerTitle',
      desc: '',
      args: [],
    );
  }

  /// `How are you feeling today?`
  String get moodTrackerQuestion {
    return Intl.message(
      'How are you feeling today?',
      name: 'moodTrackerQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Add a note (optional)`
  String get moodTrackerNoteHint {
    return Intl.message(
      'Add a note (optional)',
      name: 'moodTrackerNoteHint',
      desc: '',
      args: [],
    );
  }

  /// `Log Mood`
  String get moodTrackerLogButton {
    return Intl.message(
      'Log Mood',
      name: 'moodTrackerLogButton',
      desc: '',
      args: [],
    );
  }

  /// `Weekly Mood Chart`
  String get moodTrackerWeeklyChart {
    return Intl.message(
      'Weekly Mood Chart',
      name: 'moodTrackerWeeklyChart',
      desc: '',
      args: [],
    );
  }

  /// `Suggestion`
  String get moodTrackerSuggestionTitle {
    return Intl.message(
      'Suggestion',
      name: 'moodTrackerSuggestionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Start logging your mood to get suggestions!`
  String get moodTrackerInitialSuggestion {
    return Intl.message(
      'Start logging your mood to get suggestions!',
      name: 'moodTrackerInitialSuggestion',
      desc: '',
      args: [],
    );
  }

  /// `You're feeling great! Keep up the positive energy.`
  String get moodTrackerHappySuggestion {
    return Intl.message(
      'You\'re feeling great! Keep up the positive energy.',
      name: 'moodTrackerHappySuggestion',
      desc: '',
      args: [],
    );
  }

  /// `Feeling neutral? Try a new activity to boost your mood.`
  String get moodTrackerNeutralSuggestion {
    return Intl.message(
      'Feeling neutral? Try a new activity to boost your mood.',
      name: 'moodTrackerNeutralSuggestion',
      desc: '',
      args: [],
    );
  }

  /// `Feeling down? Reach out to a friend or take a walk.`
  String get moodTrackerSadSuggestion {
    return Intl.message(
      'Feeling down? Reach out to a friend or take a walk.',
      name: 'moodTrackerSadSuggestion',
      desc: '',
      args: [],
    );
  }

  /// `Feeling angry? Try deep breathing exercises.`
  String get moodTrackerAngrySuggestion {
    return Intl.message(
      'Feeling angry? Try deep breathing exercises.',
      name: 'moodTrackerAngrySuggestion',
      desc: '',
      args: [],
    );
  }

  /// `Feeling tired? Make sure to get enough rest.`
  String get moodTrackerTiredSuggestion {
    return Intl.message(
      'Feeling tired? Make sure to get enough rest.',
      name: 'moodTrackerTiredSuggestion',
      desc: '',
      args: [],
    );
  }

  /// `Keep tracking your mood for personalized suggestions.`
  String get moodTrackerDefaultSuggestion {
    return Intl.message(
      'Keep tracking your mood for personalized suggestions.',
      name: 'moodTrackerDefaultSuggestion',
      desc: '',
      args: [],
    );
  }

  /// `Mon`
  String get mondayShort {
    return Intl.message('Mon', name: 'mondayShort', desc: '', args: []);
  }

  /// `Tue`
  String get tuesdayShort {
    return Intl.message('Tue', name: 'tuesdayShort', desc: '', args: []);
  }

  /// `Wed`
  String get wednesdayShort {
    return Intl.message('Wed', name: 'wednesdayShort', desc: '', args: []);
  }

  /// `Thu`
  String get thursdayShort {
    return Intl.message('Thu', name: 'thursdayShort', desc: '', args: []);
  }

  /// `Fri`
  String get fridayShort {
    return Intl.message('Fri', name: 'fridayShort', desc: '', args: []);
  }

  /// `Sat`
  String get saturdayShort {
    return Intl.message('Sat', name: 'saturdayShort', desc: '', args: []);
  }

  /// `Sun`
  String get sundayShort {
    return Intl.message('Sun', name: 'sundayShort', desc: '', args: []);
  }

  /// `Therapeutic Music`
  String get therapeuticMusicTitle {
    return Intl.message(
      'Therapeutic Music',
      name: 'therapeuticMusicTitle',
      desc: '',
      args: [],
    );
  }

  /// `Ocean Waves`
  String get oceanWavesTitle {
    return Intl.message(
      'Ocean Waves',
      name: 'oceanWavesTitle',
      desc: '',
      args: [],
    );
  }

  /// `Relaxing sounds of the ocean`
  String get oceanWavesSubtitle {
    return Intl.message(
      'Relaxing sounds of the ocean',
      name: 'oceanWavesSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Birds Waves`
  String get birdsWavesTitle {
    return Intl.message(
      'Birds Waves',
      name: 'birdsWavesTitle',
      desc: '',
      args: [],
    );
  }

  /// `Relaxing sounds of the birds`
  String get birdsWavesSubtitle {
    return Intl.message(
      'Relaxing sounds of the birds',
      name: 'birdsWavesSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Forest Waves`
  String get forestWavesTitle {
    return Intl.message(
      'Forest Waves',
      name: 'forestWavesTitle',
      desc: '',
      args: [],
    );
  }

  /// `Relaxing sounds of the Forest`
  String get forestWavesSubtitle {
    return Intl.message(
      'Relaxing sounds of the Forest',
      name: 'forestWavesSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Rain Waves`
  String get rainWavesTitle {
    return Intl.message(
      'Rain Waves',
      name: 'rainWavesTitle',
      desc: '',
      args: [],
    );
  }

  /// `Relaxing sounds of the rain`
  String get rainWavesSubtitle {
    return Intl.message(
      'Relaxing sounds of the rain',
      name: 'rainWavesSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Thunderstorm Waves`
  String get thunderstormWavesTitle {
    return Intl.message(
      'Thunderstorm Waves',
      name: 'thunderstormWavesTitle',
      desc: '',
      args: [],
    );
  }

  /// `Relaxing sounds of the thunderstorm`
  String get thunderstormWavesSubtitle {
    return Intl.message(
      'Relaxing sounds of the thunderstorm',
      name: 'thunderstormWavesSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `White Noise Waves`
  String get whiteNoiseWavesTitle {
    return Intl.message(
      'White Noise Waves',
      name: 'whiteNoiseWavesTitle',
      desc: '',
      args: [],
    );
  }

  /// `Relaxing sounds of the white noise`
  String get whiteNoiseWavesSubtitle {
    return Intl.message(
      'Relaxing sounds of the white noise',
      name: 'whiteNoiseWavesSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Games`
  String get gamesTitle {
    return Intl.message('Games', name: 'gamesTitle', desc: '', args: []);
  }

  /// `Now Playing`
  String get nowPlayingTitle {
    return Intl.message(
      'Now Playing',
      name: 'nowPlayingTitle',
      desc: '',
      args: [],
    );
  }

  /// `Sleep Timer`
  String get sleepTimerTitle {
    return Intl.message(
      'Sleep Timer',
      name: 'sleepTimerTitle',
      desc: '',
      args: [],
    );
  }

  /// `{count} minutes`
  String minutesCount(Object count) {
    return Intl.message(
      '$count minutes',
      name: 'minutesCount',
      desc: '',
      args: [count],
    );
  }

  /// `Please sign in to view services`
  String get pleaseSignInToViewServices {
    return Intl.message(
      'Please sign in to view services',
      name: 'pleaseSignInToViewServices',
      desc: '',
      args: [],
    );
  }

  /// `Please sign in to book an appointment`
  String get pleaseSignInToBookAppointment {
    return Intl.message(
      'Please sign in to book an appointment',
      name: 'pleaseSignInToBookAppointment',
      desc: '',
      args: [],
    );
  }

  /// `Please sign in to view your appointments`
  String get pleaseSignInToViewAppointments {
    return Intl.message(
      'Please sign in to view your appointments',
      name: 'pleaseSignInToViewAppointments',
      desc: '',
      args: [],
    );
  }

  /// `Please sign in again`
  String get pleaseSignInAgain {
    return Intl.message(
      'Please sign in again',
      name: 'pleaseSignInAgain',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load appointments`
  String get failedToLoadAppointments {
    return Intl.message(
      'Failed to load appointments',
      name: 'failedToLoadAppointments',
      desc: '',
      args: [],
    );
  }

  /// `Error fetching appointments`
  String get errorFetchingAppointments {
    return Intl.message(
      'Error fetching appointments',
      name: 'errorFetchingAppointments',
      desc: '',
      args: [],
    );
  }

  /// `Appointment deleted successfully!`
  String get appointmentDeletedSuccessfully {
    return Intl.message(
      'Appointment deleted successfully!',
      name: 'appointmentDeletedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Failed to delete appointment`
  String get failedToDeleteAppointment {
    return Intl.message(
      'Failed to delete appointment',
      name: 'failedToDeleteAppointment',
      desc: '',
      args: [],
    );
  }

  /// `Error deleting appointment`
  String get errorDeletingAppointment {
    return Intl.message(
      'Error deleting appointment',
      name: 'errorDeletingAppointment',
      desc: '',
      args: [],
    );
  }

  /// `Cost`
  String get cost {
    return Intl.message('Cost', name: 'cost', desc: '', args: []);
  }

  /// `EGP`
  String get egp {
    return Intl.message('EGP', name: 'egp', desc: '', args: []);
  }

  /// `Services`
  String get services {
    return Intl.message('Services', name: 'services', desc: '', args: []);
  }

  /// `Notes`
  String get notes {
    return Intl.message('Notes', name: 'notes', desc: '', args: []);
  }

  /// `Cancel Appointment`
  String get cancelAppointment {
    return Intl.message(
      'Cancel Appointment',
      name: 'cancelAppointment',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Cancellation`
  String get confirmCancellation {
    return Intl.message(
      'Confirm Cancellation',
      name: 'confirmCancellation',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to cancel this appointment?`
  String get cancelAppointmentConfirmation {
    return Intl.message(
      'Are you sure you want to cancel this appointment?',
      name: 'cancelAppointmentConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message('No', name: 'no', desc: '', args: []);
  }

  /// `Yes`
  String get yes {
    return Intl.message('Yes', name: 'yes', desc: '', args: []);
  }

  /// `Articles`
  String get articles {
    return Intl.message('Articles', name: 'articles', desc: '', args: []);
  }

  /// `Search articles`
  String get searchArticles {
    return Intl.message(
      'Search articles',
      name: 'searchArticles',
      desc: '',
      args: [],
    );
  }

  /// `Read More`
  String get readMore {
    return Intl.message('Read More', name: 'readMore', desc: '', args: []);
  }

  /// `No articles found`
  String get noArticlesFound {
    return Intl.message(
      'No articles found',
      name: 'noArticlesFound',
      desc: '',
      args: [],
    );
  }

  /// `Loading articles...`
  String get loadingArticles {
    return Intl.message(
      'Loading articles...',
      name: 'loadingArticles',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get description {
    return Intl.message('Description', name: 'description', desc: '', args: []);
  }

  /// `Symptoms`
  String get symptoms {
    return Intl.message('Symptoms', name: 'symptoms', desc: '', args: []);
  }

  /// `Causes`
  String get causes {
    return Intl.message('Causes', name: 'causes', desc: '', args: []);
  }

  /// `Treatment`
  String get treatment {
    return Intl.message('Treatment', name: 'treatment', desc: '', args: []);
  }

  /// `Error loading image`
  String get errorLoadingImage {
    return Intl.message(
      'Error loading image',
      name: 'errorLoadingImage',
      desc: '',
      args: [],
    );
  }

  /// `Products`
  String get products {
    return Intl.message('Products', name: 'products', desc: '', args: []);
  }

  /// `Search here`
  String get searchHere {
    return Intl.message('Search here', name: 'searchHere', desc: '', args: []);
  }

  /// `No products found`
  String get noProductsFound {
    return Intl.message(
      'No products found',
      name: 'noProductsFound',
      desc: '',
      args: [],
    );
  }

  /// `Add to Cart`
  String get addToCart {
    return Intl.message('Add to Cart', name: 'addToCart', desc: '', args: []);
  }

  /// `EGP`
  String get egpCurrency {
    return Intl.message('EGP', name: 'egpCurrency', desc: '', args: []);
  }

  /// `About this product`
  String get aboutThisProduct {
    return Intl.message(
      'About this product',
      name: 'aboutThisProduct',
      desc: '',
      args: [],
    );
  }

  /// `Price`
  String get price {
    return Intl.message('Price', name: 'price', desc: '', args: []);
  }

  /// `Cart Products`
  String get cartProducts {
    return Intl.message(
      'Cart Products',
      name: 'cartProducts',
      desc: '',
      args: [],
    );
  }

  /// `Your cart is empty`
  String get yourCartIsEmpty {
    return Intl.message(
      'Your cart is empty',
      name: 'yourCartIsEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Total`
  String get total {
    return Intl.message('Total', name: 'total', desc: '', args: []);
  }

  /// `Buy Now`
  String get buyNow {
    return Intl.message('Buy Now', name: 'buyNow', desc: '', args: []);
  }

  /// `Check Out`
  String get checkOut {
    return Intl.message('Check Out', name: 'checkOut', desc: '', args: []);
  }

  /// `Done`
  String get done {
    return Intl.message('Done', name: 'done', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Delete Product`
  String get deleteProduct {
    return Intl.message(
      'Delete Product',
      name: 'deleteProduct',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this product?`
  String get deleteProductConfirmation {
    return Intl.message(
      'Are you sure you want to delete this product?',
      name: 'deleteProductConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `£`
  String get currencySymbol {
    return Intl.message('£', name: 'currencySymbol', desc: '', args: []);
  }

  /// `Added to cart successfully!`
  String get addedToCartSuccessfully {
    return Intl.message(
      'Added to cart successfully!',
      name: 'addedToCartSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Please wait...`
  String get pleaseWait {
    return Intl.message(
      'Please wait...',
      name: 'pleaseWait',
      desc: '',
      args: [],
    );
  }

  /// `Process completed successfully!`
  String get processCompleted {
    return Intl.message(
      'Process completed successfully!',
      name: 'processCompleted',
      desc: '',
      args: [],
    );
  }

  /// `06 Oct 2024 - 10 Oct 2024`
  String get appointmentDates {
    return Intl.message(
      '06 Oct 2024 - 10 Oct 2024',
      name: 'appointmentDates',
      desc: '',
      args: [],
    );
  }

  /// `Shipping to`
  String get shippingTo {
    return Intl.message('Shipping to', name: 'shippingTo', desc: '', args: []);
  }

  /// `Payment Method`
  String get paymentMethod {
    return Intl.message(
      'Payment Method',
      name: 'paymentMethod',
      desc: '',
      args: [],
    );
  }

  /// `Premium Test Details`
  String get premiumTestDetails {
    return Intl.message(
      'Premium Test Details',
      name: 'premiumTestDetails',
      desc: '',
      args: [],
    );
  }

  /// `Test Name`
  String get testName {
    return Intl.message('Test Name', name: 'testName', desc: '', args: []);
  }

  /// `Coupon Code`
  String get couponCode {
    return Intl.message('Coupon Code', name: 'couponCode', desc: '', args: []);
  }

  /// `Enter coupon code`
  String get enterCouponCode {
    return Intl.message(
      'Enter coupon code',
      name: 'enterCouponCode',
      desc: '',
      args: [],
    );
  }

  /// `Apply`
  String get apply {
    return Intl.message('Apply', name: 'apply', desc: '', args: []);
  }

  /// `ChatBot Service`
  String get chatBotService {
    return Intl.message(
      'ChatBot Service',
      name: 'chatBotService',
      desc: '',
      args: [],
    );
  }

  /// `How can I help you today?`
  String get chatWelcomeTitle {
    return Intl.message(
      'How can I help you today?',
      name: 'chatWelcomeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Start typing or use the microphone to ask me anything.`
  String get chatWelcomeSubtitle {
    return Intl.message(
      'Start typing or use the microphone to ask me anything.',
      name: 'chatWelcomeSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Type your message...`
  String get typeYourMessage {
    return Intl.message(
      'Type your message...',
      name: 'typeYourMessage',
      desc: '',
      args: [],
    );
  }

  /// `Welcome back`
  String get welcomeBack {
    return Intl.message(
      'Welcome back',
      name: 'welcomeBack',
      desc: '',
      args: [],
    );
  }

  /// `Session`
  String get session {
    return Intl.message('Session', name: 'session', desc: '', args: []);
  }

  /// `Selected Session ID`
  String get selectedSessionID {
    return Intl.message(
      'Selected Session ID',
      name: 'selectedSessionID',
      desc: '',
      args: [],
    );
  }

  /// `Start New Chat`
  String get startNewChat {
    return Intl.message(
      'Start New Chat',
      name: 'startNewChat',
      desc: '',
      args: [],
    );
  }

  /// `Your previous conversations`
  String get yourPreviousConversations {
    return Intl.message(
      'Your previous conversations',
      name: 'yourPreviousConversations',
      desc: '',
      args: [],
    );
  }

  /// `Pitch Control`
  String get pitchControl {
    return Intl.message(
      'Pitch Control',
      name: 'pitchControl',
      desc: '',
      args: [],
    );
  }

  /// `Please enter some text or use the mic.`
  String get pleaseEnterSomeText {
    return Intl.message(
      'Please enter some text or use the mic.',
      name: 'pleaseEnterSomeText',
      desc: '',
      args: [],
    );
  }

  /// `No services available for this category.`
  String get noServicesAvailable {
    return Intl.message(
      'No services available for this category.',
      name: 'noServicesAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Service Details`
  String get serviceDetails {
    return Intl.message(
      'Service Details',
      name: 'serviceDetails',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load details.`
  String get failedToLoadDetails {
    return Intl.message(
      'Failed to load details.',
      name: 'failedToLoadDetails',
      desc: '',
      args: [],
    );
  }

  /// `Duration`
  String get duration {
    return Intl.message('Duration', name: 'duration', desc: '', args: []);
  }

  /// `No Name`
  String get noName {
    return Intl.message('No Name', name: 'noName', desc: '', args: []);
  }

  /// `No Description`
  String get noDescription {
    return Intl.message(
      'No Description',
      name: 'noDescription',
      desc: '',
      args: [],
    );
  }

  /// `Doctor Details`
  String get doctorDetails {
    return Intl.message(
      'Doctor Details',
      name: 'doctorDetails',
      desc: '',
      args: [],
    );
  }

  /// `Available Days`
  String get availableDays {
    return Intl.message(
      'Available Days',
      name: 'availableDays',
      desc: '',
      args: [],
    );
  }

  /// `Available Time Slots`
  String get availableTimeSlots {
    return Intl.message(
      'Available Time Slots',
      name: 'availableTimeSlots',
      desc: '',
      args: [],
    );
  }

  /// `No available slots for this day`
  String get noAvailableSlots {
    return Intl.message(
      'No available slots for this day',
      name: 'noAvailableSlots',
      desc: '',
      args: [],
    );
  }

  /// `Book Appointment`
  String get bookAppointment {
    return Intl.message(
      'Book Appointment',
      name: 'bookAppointment',
      desc: '',
      args: [],
    );
  }

  /// `Review submitted successfully!`
  String get reviewSubmittedSuccessfully {
    return Intl.message(
      'Review submitted successfully!',
      name: 'reviewSubmittedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Patients`
  String get patients {
    return Intl.message('Patients', name: 'patients', desc: '', args: []);
  }

  /// `Exp`
  String get experience {
    return Intl.message('Exp', name: 'experience', desc: '', args: []);
  }

  /// `Fee`
  String get fee {
    return Intl.message('Fee', name: 'fee', desc: '', args: []);
  }

  /// `Rating`
  String get rating {
    return Intl.message('Rating', name: 'rating', desc: '', args: []);
  }

  /// `Specialty`
  String get specialty {
    return Intl.message('Specialty', name: 'specialty', desc: '', args: []);
  }

  /// `About Doctor`
  String get aboutDoctor {
    return Intl.message(
      'About Doctor',
      name: 'aboutDoctor',
      desc: '',
      args: [],
    );
  }

  /// `Country`
  String get country {
    return Intl.message('Country', name: 'country', desc: '', args: []);
  }

  /// `Joined`
  String get joined {
    return Intl.message('Joined', name: 'joined', desc: '', args: []);
  }

  /// `Sessions`
  String get sessions {
    return Intl.message('Sessions', name: 'sessions', desc: '', args: []);
  }

  /// `Patient Reviews`
  String get patientReviews {
    return Intl.message(
      'Patient Reviews',
      name: 'patientReviews',
      desc: '',
      args: [],
    );
  }

  /// `Show Less`
  String get showLess {
    return Intl.message('Show Less', name: 'showLess', desc: '', args: []);
  }

  /// `Show All`
  String get showAll {
    return Intl.message('Show All', name: 'showAll', desc: '', args: []);
  }

  /// `No reviews yet`
  String get noReviewsYet {
    return Intl.message(
      'No reviews yet',
      name: 'noReviewsYet',
      desc: '',
      args: [],
    );
  }

  /// `Leave Your Review`
  String get leaveYourReview {
    return Intl.message(
      'Leave Your Review',
      name: 'leaveYourReview',
      desc: '',
      args: [],
    );
  }

  /// `Positive?`
  String get positive {
    return Intl.message('Positive?', name: 'positive', desc: '', args: []);
  }

  /// `Your Review`
  String get yourReview {
    return Intl.message('Your Review', name: 'yourReview', desc: '', args: []);
  }

  /// `Submit Review`
  String get submitReview {
    return Intl.message(
      'Submit Review',
      name: 'submitReview',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a rating`
  String get ratingRequired {
    return Intl.message(
      'Please enter a rating',
      name: 'ratingRequired',
      desc: '',
      args: [],
    );
  }

  /// `Rating must be between 1 and 5`
  String get ratingRange {
    return Intl.message(
      'Rating must be between 1 and 5',
      name: 'ratingRange',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your review`
  String get reviewRequired {
    return Intl.message(
      'Please enter your review',
      name: 'reviewRequired',
      desc: '',
      args: [],
    );
  }

  /// `Anonymous Patient`
  String get anonymousPatient {
    return Intl.message(
      'Anonymous Patient',
      name: 'anonymousPatient',
      desc: '',
      args: [],
    );
  }

  /// `days ago`
  String get daysAgo {
    return Intl.message('days ago', name: 'daysAgo', desc: '', args: []);
  }

  /// `Confirm Booking`
  String get confirmBooking {
    return Intl.message(
      'Confirm Booking',
      name: 'confirmBooking',
      desc: '',
      args: [],
    );
  }

  /// `Appointment booked successfully!`
  String get appointmentBookedSuccessfully {
    return Intl.message(
      'Appointment booked successfully!',
      name: 'appointmentBookedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Failed to book appointment`
  String get failedToBookAppointment {
    return Intl.message(
      'Failed to book appointment',
      name: 'failedToBookAppointment',
      desc: '',
      args: [],
    );
  }

  /// `Please select a date and time`
  String get selectDateAndTime {
    return Intl.message(
      'Please select a date and time',
      name: 'selectDateAndTime',
      desc: '',
      args: [],
    );
  }

  /// `No availability for selected date`
  String get noAvailability {
    return Intl.message(
      'No availability for selected date',
      name: 'noAvailability',
      desc: '',
      args: [],
    );
  }

  /// `Filter Options`
  String get filterOptions {
    return Intl.message(
      'Filter Options',
      name: 'filterOptions',
      desc: '',
      args: [],
    );
  }

  /// `Availability`
  String get availability {
    return Intl.message(
      'Availability',
      name: 'availability',
      desc: '',
      args: [],
    );
  }

  /// `Today`
  String get today {
    return Intl.message('Today', name: 'today', desc: '', args: []);
  }

  /// `This Week`
  String get thisWeek {
    return Intl.message('This Week', name: 'thisWeek', desc: '', args: []);
  }

  /// `Online`
  String get online {
    return Intl.message('Online', name: 'online', desc: '', args: []);
  }

  /// `Specific Date or Range`
  String get specificDateOrRange {
    return Intl.message(
      'Specific Date or Range',
      name: 'specificDateOrRange',
      desc: '',
      args: [],
    );
  }

  /// `Areas of Interest`
  String get areasOfInterest {
    return Intl.message(
      'Areas of Interest',
      name: 'areasOfInterest',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get english {
    return Intl.message('English', name: 'english', desc: '', args: []);
  }

  /// `Spanish`
  String get spanish {
    return Intl.message('Spanish', name: 'spanish', desc: '', args: []);
  }

  /// `French`
  String get french {
    return Intl.message('French', name: 'french', desc: '', args: []);
  }

  /// `German`
  String get german {
    return Intl.message('German', name: 'german', desc: '', args: []);
  }

  /// `All`
  String get all {
    return Intl.message('All', name: 'all', desc: '', args: []);
  }

  /// `Therapist Gender`
  String get therapistGender {
    return Intl.message(
      'Therapist Gender',
      name: 'therapistGender',
      desc: '',
      args: [],
    );
  }

  /// `Country and City`
  String get countryAndCity {
    return Intl.message(
      'Country and City',
      name: 'countryAndCity',
      desc: '',
      args: [],
    );
  }

  /// `USA`
  String get usa {
    return Intl.message('USA', name: 'usa', desc: '', args: []);
  }

  /// `Canada`
  String get canada {
    return Intl.message('Canada', name: 'canada', desc: '', args: []);
  }

  /// `UK`
  String get uk {
    return Intl.message('UK', name: 'uk', desc: '', args: []);
  }

  /// `Australia`
  String get australia {
    return Intl.message('Australia', name: 'australia', desc: '', args: []);
  }

  /// `New York`
  String get newYork {
    return Intl.message('New York', name: 'newYork', desc: '', args: []);
  }

  /// `Toronto`
  String get toronto {
    return Intl.message('Toronto', name: 'toronto', desc: '', args: []);
  }

  /// `London`
  String get london {
    return Intl.message('London', name: 'london', desc: '', args: []);
  }

  /// `Sydney`
  String get sydney {
    return Intl.message('Sydney', name: 'sydney', desc: '', args: []);
  }

  /// `Salary Range`
  String get salaryRange {
    return Intl.message(
      'Salary Range',
      name: 'salaryRange',
      desc: '',
      args: [],
    );
  }

  /// `Apply Filter`
  String get applyFilter {
    return Intl.message(
      'Apply Filter',
      name: 'applyFilter',
      desc: '',
      args: [],
    );
  }

  /// `min`
  String get min {
    return Intl.message('min', name: 'min', desc: '', args: []);
  }

  /// `Reviews`
  String get reviews {
    return Intl.message('Reviews', name: 'reviews', desc: '', args: []);
  }

  /// `4.8`
  String get ratingValue {
    return Intl.message('4.8', name: 'ratingValue', desc: '', args: []);
  }

  /// `(1172 Reviews)`
  String get totalReviews {
    return Intl.message(
      '(1172 Reviews)',
      name: 'totalReviews',
      desc: '',
      args: [],
    );
  }

  /// `Ask A Doctor`
  String get askADoctor {
    return Intl.message('Ask A Doctor', name: 'askADoctor', desc: '', args: []);
  }

  /// `Your Question`
  String get yourQuestion {
    return Intl.message(
      'Your Question',
      name: 'yourQuestion',
      desc: '',
      args: [],
    );
  }

  /// `example: What are the reasons?`
  String get questionExample {
    return Intl.message(
      'example: What are the reasons?',
      name: 'questionExample',
      desc: '',
      args: [],
    );
  }

  /// `Question description (explain the symptoms of the problem)`
  String get questionDescriptionHint {
    return Intl.message(
      'Question description (explain the symptoms of the problem)',
      name: 'questionDescriptionHint',
      desc: '',
      args: [],
    );
  }

  /// `This Question Is For`
  String get thisQuestionFor {
    return Intl.message(
      'This Question Is For',
      name: 'thisQuestionFor',
      desc: '',
      args: [],
    );
  }

  /// `For yourself`
  String get forYourself {
    return Intl.message(
      'For yourself',
      name: 'forYourself',
      desc: '',
      args: [],
    );
  }

  /// `For someone else`
  String get forSomeoneElse {
    return Intl.message(
      'For someone else',
      name: 'forSomeoneElse',
      desc: '',
      args: [],
    );
  }

  /// `Age`
  String get age {
    return Intl.message('Age', name: 'age', desc: '', args: []);
  }

  /// `Enter your age`
  String get enterYourAge {
    return Intl.message(
      'Enter your age',
      name: 'enterYourAge',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get send {
    return Intl.message('Send', name: 'send', desc: '', args: []);
  }

  /// `Your question has been sent successfully!`
  String get questionSentSuccessfully {
    return Intl.message(
      'Your question has been sent successfully!',
      name: 'questionSentSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `The Answer Is Not Intended For Individual Diagnosis Or Treatment. Please Consult A Psychiatrist.`
  String get answerDisclaimer {
    return Intl.message(
      'The Answer Is Not Intended For Individual Diagnosis Or Treatment. Please Consult A Psychiatrist.',
      name: 'answerDisclaimer',
      desc: '',
      args: [],
    );
  }

  /// `This field cannot be empty`
  String get fieldCannotBeEmpty {
    return Intl.message(
      'This field cannot be empty',
      name: 'fieldCannotBeEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Contact Us Form Submission`
  String get contactUsFormSubmission {
    return Intl.message(
      'Contact Us Form Submission',
      name: 'contactUsFormSubmission',
      desc: '',
      args: [],
    );
  }

  /// `Email Sent Successfully!`
  String get emailSentSuccessfully {
    return Intl.message(
      'Email Sent Successfully!',
      name: 'emailSentSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Failed to send email`
  String get failedToSendEmail {
    return Intl.message(
      'Failed to send email',
      name: 'failedToSendEmail',
      desc: '',
      args: [],
    );
  }

  /// `You are our priority`
  String get youAreOurPriority {
    return Intl.message(
      'You are our priority',
      name: 'youAreOurPriority',
      desc: '',
      args: [],
    );
  }

  /// `We appreciate your comments and inquiries! Feel free to contact us.`
  String get contactUsMessage {
    return Intl.message(
      'We appreciate your comments and inquiries! Feel free to contact us.',
      name: 'contactUsMessage',
      desc: '',
      args: [],
    );
  }

  /// `Message`
  String get message {
    return Intl.message('Message', name: 'message', desc: '', args: []);
  }

  /// `Write your message..`
  String get writeYourMessage {
    return Intl.message(
      'Write your message..',
      name: 'writeYourMessage',
      desc: '',
      args: [],
    );
  }

  /// `Send a Comment`
  String get sendComment {
    return Intl.message(
      'Send a Comment',
      name: 'sendComment',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message('Profile', name: 'profile', desc: '', args: []);
  }

  /// `Profile Details`
  String get profileDetails {
    return Intl.message(
      'Profile Details',
      name: 'profileDetails',
      desc: '',
      args: [],
    );
  }

  /// `Payment Details`
  String get paymentDetails {
    return Intl.message(
      'Payment Details',
      name: 'paymentDetails',
      desc: '',
      args: [],
    );
  }

  /// `Add Photo`
  String get addPhoto {
    return Intl.message('Add Photo', name: 'addPhoto', desc: '', args: []);
  }

  /// `User Name`
  String get userName {
    return Intl.message('User Name', name: 'userName', desc: '', args: []);
  }

  /// `user@example.com`
  String get userEmail {
    return Intl.message(
      'user@example.com',
      name: 'userEmail',
      desc: '',
      args: [],
    );
  }

  /// `My Profile`
  String get myProfile {
    return Intl.message('My Profile', name: 'myProfile', desc: '', args: []);
  }

  /// `Name`
  String get name {
    return Intl.message('Name', name: 'name', desc: '', args: []);
  }

  /// `Birthday`
  String get birthday {
    return Intl.message('Birthday', name: 'birthday', desc: '', args: []);
  }

  /// `N/A`
  String get notAvailable {
    return Intl.message('N/A', name: 'notAvailable', desc: '', args: []);
  }

  /// `Sign Out`
  String get signOut {
    return Intl.message('Sign Out', name: 'signOut', desc: '', args: []);
  }

  /// `Successfully logged out`
  String get logoutSuccess {
    return Intl.message(
      'Successfully logged out',
      name: 'logoutSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Access token not found. Please log in again.`
  String get accessTokenNotFound {
    return Intl.message(
      'Access token not found. Please log in again.',
      name: 'accessTokenNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load user details`
  String get failedToLoadUserDetails {
    return Intl.message(
      'Failed to load user details',
      name: 'failedToLoadUserDetails',
      desc: '',
      args: [],
    );
  }

  /// `Error fetching user details`
  String get errorFetchingUserDetails {
    return Intl.message(
      'Error fetching user details',
      name: 'errorFetchingUserDetails',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continueText {
    return Intl.message('Continue', name: 'continueText', desc: '', args: []);
  }

  /// `VitaPsyche Wallet`
  String get vitaPsycheWallet {
    return Intl.message(
      'VitaPsyche Wallet',
      name: 'vitaPsycheWallet',
      desc: '',
      args: [],
    );
  }

  /// `Depression Scale`
  String get depressionScale {
    return Intl.message(
      'Depression Scale',
      name: 'depressionScale',
      desc: '',
      args: [],
    );
  }

  /// `Your Score`
  String get yourScore {
    return Intl.message('Your Score', name: 'yourScore', desc: '', args: []);
  }

  /// `What does that mean?`
  String get whatDoesThatMean {
    return Intl.message(
      'What does that mean?',
      name: 'whatDoesThatMean',
      desc: '',
      args: [],
    );
  }

  /// `Book An Appointment`
  String get bookAnAppointment {
    return Intl.message(
      'Book An Appointment',
      name: 'bookAnAppointment',
      desc: '',
      args: [],
    );
  }

  /// `Talk With AI`
  String get talkWithAI {
    return Intl.message('Talk With AI', name: 'talkWithAI', desc: '', args: []);
  }

  /// `Unknown`
  String get unknown {
    return Intl.message('Unknown', name: 'unknown', desc: '', args: []);
  }

  /// `No data`
  String get noData {
    return Intl.message('No data', name: 'noData', desc: '', args: []);
  }

  /// `Please read the test items carefully and make sure that the choices apply to you in the last two weeks. There is no right or wrong answer.`
  String get testInstructions {
    return Intl.message(
      'Please read the test items carefully and make sure that the choices apply to you in the last two weeks. There is no right or wrong answer.',
      name: 'testInstructions',
      desc: '',
      args: [],
    );
  }

  /// `No question available`
  String get noQuestion {
    return Intl.message(
      'No question available',
      name: 'noQuestion',
      desc: '',
      args: [],
    );
  }

  /// `No choice available`
  String get noChoice {
    return Intl.message(
      'No choice available',
      name: 'noChoice',
      desc: '',
      args: [],
    );
  }

  /// `Question`
  String get question {
    return Intl.message('Question', name: 'question', desc: '', args: []);
  }

  /// `of`
  String get of {
    return Intl.message('of', name: 'of', desc: '', args: []);
  }

  /// `Previous`
  String get previous {
    return Intl.message('Previous', name: 'previous', desc: '', args: []);
  }

  /// `Please select an answer before proceeding.`
  String get selectAnswerWarning {
    return Intl.message(
      'Please select an answer before proceeding.',
      name: 'selectAnswerWarning',
      desc: '',
      args: [],
    );
  }

  /// `Personality Disorders Result`
  String get personalityDisordersResult {
    return Intl.message(
      'Personality Disorders Result',
      name: 'personalityDisordersResult',
      desc: '',
      args: [],
    );
  }

  /// `Your Score is:`
  String get yourScoreIs {
    return Intl.message(
      'Your Score is:',
      name: 'yourScoreIs',
      desc: '',
      args: [],
    );
  }

  /// `Score`
  String get score {
    return Intl.message('Score', name: 'score', desc: '', args: []);
  }

  /// `Questions`
  String get questions {
    return Intl.message('Questions', name: 'questions', desc: '', args: []);
  }

  /// `Every 2 weeks`
  String get everyTwoWeeks {
    return Intl.message(
      'Every 2 weeks',
      name: 'everyTwoWeeks',
      desc: '',
      args: [],
    );
  }

  /// `Payment the test`
  String get paymentTheTest {
    return Intl.message(
      'Payment the test',
      name: 'paymentTheTest',
      desc: '',
      args: [],
    );
  }

  /// `Take the test`
  String get takeTheTest {
    return Intl.message(
      'Take the test',
      name: 'takeTheTest',
      desc: '',
      args: [],
    );
  }

  /// `Accepted`
  String get accepted {
    return Intl.message('Accepted', name: 'accepted', desc: '', args: []);
  }

  /// `Refused`
  String get refused {
    return Intl.message('Refused', name: 'refused', desc: '', args: []);
  }

  /// `No accepted appointments`
  String get noAcceptedAppointments {
    return Intl.message(
      'No accepted appointments',
      name: 'noAcceptedAppointments',
      desc: '',
      args: [],
    );
  }

  /// `No refused appointments`
  String get noRefusedAppointments {
    return Intl.message(
      'No refused appointments',
      name: 'noRefusedAppointments',
      desc: '',
      args: [],
    );
  }

  /// `Date & Time`
  String get dateAndTime {
    return Intl.message('Date & Time', name: 'dateAndTime', desc: '', args: []);
  }

  /// `at`
  String get at {
    return Intl.message('at', name: 'at', desc: '', args: []);
  }

  /// `EGP`
  String get currency {
    return Intl.message('EGP', name: 'currency', desc: '', args: []);
  }

  /// `Doctor Availability`
  String get doctorAvailability {
    return Intl.message(
      'Doctor Availability',
      name: 'doctorAvailability',
      desc: '',
      args: [],
    );
  }

  /// `Schedules`
  String get schedules {
    return Intl.message('Schedules', name: 'schedules', desc: '', args: []);
  }

  /// `Max Patients`
  String get maxPatients {
    return Intl.message(
      'Max Patients',
      name: 'maxPatients',
      desc: '',
      args: [],
    );
  }

  /// `Start Time`
  String get startTime {
    return Intl.message('Start Time', name: 'startTime', desc: '', args: []);
  }

  /// `End Time`
  String get endTime {
    return Intl.message('End Time', name: 'endTime', desc: '', args: []);
  }

  /// `Doctor Photo`
  String get doctorPhoto {
    return Intl.message(
      'Doctor Photo',
      name: 'doctorPhoto',
      desc: '',
      args: [],
    );
  }

  /// `Edit Info`
  String get editInfo {
    return Intl.message('Edit Info', name: 'editInfo', desc: '', args: []);
  }

  /// `Years of Experience`
  String get yearsOfExperience {
    return Intl.message(
      'Years of Experience',
      name: 'yearsOfExperience',
      desc: '',
      args: [],
    );
  }

  /// `Doctor Services`
  String get doctorServices {
    return Intl.message(
      'Doctor Services',
      name: 'doctorServices',
      desc: '',
      args: [],
    );
  }

  /// `View Services`
  String get viewServices {
    return Intl.message(
      'View Services',
      name: 'viewServices',
      desc: '',
      args: [],
    );
  }

  /// `Doctor ID not found`
  String get doctorIdNotFound {
    return Intl.message(
      'Doctor ID not found',
      name: 'doctorIdNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Service Name`
  String get serviceName {
    return Intl.message(
      'Service Name',
      name: 'serviceName',
      desc: '',
      args: [],
    );
  }

  /// `Name is required`
  String get nameRequired {
    return Intl.message(
      'Name is required',
      name: 'nameRequired',
      desc: '',
      args: [],
    );
  }

  /// `Description is required`
  String get descriptionRequired {
    return Intl.message(
      'Description is required',
      name: 'descriptionRequired',
      desc: '',
      args: [],
    );
  }

  /// `Price is required`
  String get priceRequired {
    return Intl.message(
      'Price is required',
      name: 'priceRequired',
      desc: '',
      args: [],
    );
  }

  /// `Duration is required`
  String get durationRequired {
    return Intl.message(
      'Duration is required',
      name: 'durationRequired',
      desc: '',
      args: [],
    );
  }

  /// `Category is required`
  String get categoryRequired {
    return Intl.message(
      'Category is required',
      name: 'categoryRequired',
      desc: '',
      args: [],
    );
  }

  /// `Is Active`
  String get isActive {
    return Intl.message('Is Active', name: 'isActive', desc: '', args: []);
  }

  /// `Tap to pick an image`
  String get tapToPickImage {
    return Intl.message(
      'Tap to pick an image',
      name: 'tapToPickImage',
      desc: '',
      args: [],
    );
  }

  /// `Submit Service`
  String get submitService {
    return Intl.message(
      'Submit Service',
      name: 'submitService',
      desc: '',
      args: [],
    );
  }

  /// `Service posted successfully!`
  String get servicePostedSuccess {
    return Intl.message(
      'Service posted successfully!',
      name: 'servicePostedSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message('Error', name: 'error', desc: '', args: []);
  }

  /// `Select`
  String get select {
    return Intl.message('Select', name: 'select', desc: '', args: []);
  }

  /// `Edit Profile`
  String get editProfile {
    return Intl.message(
      'Edit Profile',
      name: 'editProfile',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get phoneNumber {
    return Intl.message(
      'Phone Number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Birth Date`
  String get birthDate {
    return Intl.message('Birth Date', name: 'birthDate', desc: '', args: []);
  }

  /// `Fluent Languages`
  String get fluentLanguages {
    return Intl.message(
      'Fluent Languages',
      name: 'fluentLanguages',
      desc: '',
      args: [],
    );
  }

  /// `Doctor Email`
  String get doctorEmail {
    return Intl.message(
      'Doctor Email',
      name: 'doctorEmail',
      desc: '',
      args: [],
    );
  }

  /// `Save Changes`
  String get saveChanges {
    return Intl.message(
      'Save Changes',
      name: 'saveChanges',
      desc: '',
      args: [],
    );
  }

  /// `Please enter`
  String get pleaseEnter {
    return Intl.message(
      'Please enter',
      name: 'pleaseEnter',
      desc: '',
      args: [],
    );
  }

  /// `Edit Service`
  String get editService {
    return Intl.message(
      'Edit Service',
      name: 'editService',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a name`
  String get pleaseEnterName {
    return Intl.message(
      'Please enter a name',
      name: 'pleaseEnterName',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a price`
  String get pleaseEnterPrice {
    return Intl.message(
      'Please enter a price',
      name: 'pleaseEnterPrice',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a duration`
  String get pleaseEnterDuration {
    return Intl.message(
      'Please enter a duration',
      name: 'pleaseEnterDuration',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a category`
  String get pleaseEnterCategory {
    return Intl.message(
      'Please enter a category',
      name: 'pleaseEnterCategory',
      desc: '',
      args: [],
    );
  }

  /// `Update Service`
  String get updateService {
    return Intl.message(
      'Update Service',
      name: 'updateService',
      desc: '',
      args: [],
    );
  }

  /// `Appointment Requests`
  String get appointmentRequests {
    return Intl.message(
      'Appointment Requests',
      name: 'appointmentRequests',
      desc: '',
      args: [],
    );
  }

  /// `No appointment requests found`
  String get noAppointmentRequests {
    return Intl.message(
      'No appointment requests found',
      name: 'noAppointmentRequests',
      desc: '',
      args: [],
    );
  }

  /// `ACCEPT`
  String get accept {
    return Intl.message('ACCEPT', name: 'accept', desc: '', args: []);
  }

  /// `REJECT`
  String get reject {
    return Intl.message('REJECT', name: 'reject', desc: '', args: []);
  }

  /// `Service`
  String get service {
    return Intl.message('Service', name: 'service', desc: '', args: []);
  }

  /// `Request`
  String get request {
    return Intl.message('Request', name: 'request', desc: '', args: []);
  }

  /// `Vitapsyche`
  String get appName {
    return Intl.message('Vitapsyche', name: 'appName', desc: '', args: []);
  }

  /// `clear your mind, calm your heart`
  String get appTagline {
    return Intl.message(
      'clear your mind, calm your heart',
      name: 'appTagline',
      desc: '',
      args: [],
    );
  }

  /// `Appointment on`
  String get appointmentOn {
    return Intl.message(
      'Appointment on',
      name: 'appointmentOn',
      desc: '',
      args: [],
    );
  }

  /// `Monday`
  String get monday {
    return Intl.message('Monday', name: 'monday', desc: '', args: []);
  }

  /// `Tuesday`
  String get tuesday {
    return Intl.message('Tuesday', name: 'tuesday', desc: '', args: []);
  }

  /// `Wednesday`
  String get wednesday {
    return Intl.message('Wednesday', name: 'wednesday', desc: '', args: []);
  }

  /// `Thursday`
  String get thursday {
    return Intl.message('Thursday', name: 'thursday', desc: '', args: []);
  }

  /// `Friday`
  String get friday {
    return Intl.message('Friday', name: 'friday', desc: '', args: []);
  }

  /// `Saturday`
  String get saturday {
    return Intl.message('Saturday', name: 'saturday', desc: '', args: []);
  }

  /// `Sunday`
  String get sunday {
    return Intl.message('Sunday', name: 'sunday', desc: '', args: []);
  }

  /// `Schedule submitted successfully!`
  String get scheduleSubmitted {
    return Intl.message(
      'Schedule submitted successfully!',
      name: 'scheduleSubmitted',
      desc: '',
      args: [],
    );
  }

  /// `Failed to submit schedule. Please try again.`
  String get submitFailed {
    return Intl.message(
      'Failed to submit schedule. Please try again.',
      name: 'submitFailed',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred. Please try again.`
  String get errorOccurred {
    return Intl.message(
      'An error occurred. Please try again.',
      name: 'errorOccurred',
      desc: '',
      args: [],
    );
  }

  /// `Availability deleted successfully!`
  String get availabilityDeleted {
    return Intl.message(
      'Availability deleted successfully!',
      name: 'availabilityDeleted',
      desc: '',
      args: [],
    );
  }

  /// `Failed to delete availability. Please try again.`
  String get deleteFailed {
    return Intl.message(
      'Failed to delete availability. Please try again.',
      name: 'deleteFailed',
      desc: '',
      args: [],
    );
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
