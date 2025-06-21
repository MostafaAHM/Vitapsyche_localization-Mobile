import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mindmed_project/features/test/data/test.dart';
import 'package:flutter_mindmed_project/main.dart';
import 'package:provider/provider.dart';


class ReqTest {
  // English paths
  static const String kBeckDepressionInventory =
      'assets/json/test/free_tests/BeckDepressionInventory.json';
  static const String kInternetAddictionScale =
      'assets/json/test/free_tests/InternetAddictionScale.json';
  static const String kOcdScale = 'assets/json/test/free_tests/ocd_scale.json';
  static const String kPtsdScale = 'assets/json/test/free_tests/ptsd_scale.json';
  static const String kRosenbergSelfEsteemScale =
      'assets/json/test/free_tests/Rosenberg_Self_Esteem_Scale.json';
  static const String kTaylorAnxietyScale =
      'assets/json/test/free_tests/TaylorAnxietyScale.json';
  static const String kConnersTest =
      'assets/json/test/paid_tests/ConnersTest.json';
  static const String kCognitiveDistortionsAssessment =
      'assets/json/test/paid_tests/cognitive_distortions_assessment.json';
  static const String kPersonalityDisordersTest =
      'assets/json/test/paid_tests/PersonalityDisordersTest.json';

  // Arabic paths
  static const String kBeckDepressionInventoryAr =
      'assets/json/test/free_tests/BeckDepressionInventory_an.json';
  static const String kInternetAddictionScaleAr =
      'assets/json/test/free_tests/InternetAddictionScale_an.json';
  static const String kOcdScaleAr = 'assets/json/test/free_tests/ocd_scale_an.json';
  static const String kPtsdScaleAr = 'assets/json/test/free_tests/ptsd_scale_an.json';
  static const String kRosenbergSelfEsteemScaleAr =
      'assets/json/test/free_tests/Rosenberg_Self_Esteem_Scale_an.json';
  static const String kTaylorAnxietyScaleAr =
      'assets/json/test/free_tests/TaylorAnxietyScale_an.json';
  static const String kConnersTestAr =
      'assets/json/test/paid_tests/ConnersTest_ar.json';
  static const String kCognitiveDistortionsAssessmentAr =
      'assets/json/test/paid_tests/cognitive_distortions_assessment_ar.json';
  static const String kPersonalityDisordersTestAr =
      'assets/json/test/paid_tests/PersonalityDisordersTest_ar.json';

  // This method now accepts a dynamic path to load a specific test
  static Future<Test> loadTest(String testPath) async {
    try {
      final String jsonString = await rootBundle.loadString(testPath);
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      return Test.fromJson(jsonData);
    } catch (e, stackTrace) {
      debugPrint('❌ Error loading test data from $testPath: $e');
      debugPrint('🔍 Stack Trace:\n$stackTrace');
      rethrow;
    }
  }

  // Helper method to get the localized path
  static String getLocalizedPath(BuildContext context, String englishPath, String arabicPath) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final isArabic = localeProvider.locale.languageCode == 'ar';
    return isArabic ? arabicPath : englishPath;
  }
}