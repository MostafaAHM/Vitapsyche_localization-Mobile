import 'package:flutter/material.dart';
import 'package:flutter_mindmed_project/main.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/colors.dart';
import '../../data/req_test.dart';
import '../../data/test.dart';
import '../widget/test_card.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  late Future<List<Test>> _testsFuture;

  // List of tests with English and Arabic paths
  final List<Map<String, dynamic>> testsData = [
    {
      'title': 'Depression scale',
      'englishPath': ReqTest.kBeckDepressionInventory,
      'arabicPath': ReqTest.kBeckDepressionInventoryAr,
    },
    {
      'title': 'Internet Addiction Scale',
      'englishPath': ReqTest.kInternetAddictionScale,
      'arabicPath': ReqTest.kInternetAddictionScaleAr,
    },
    {
      'title': 'OCD Scale',
      'englishPath': ReqTest.kOcdScale,
      'arabicPath': ReqTest.kOcdScaleAr,
    },
    {
      'title': 'Ptsd Scale',
      'englishPath': ReqTest.kPtsdScale,
      'arabicPath': ReqTest.kPtsdScaleAr,
    },
    {
      'title': 'Rosenberg Self Esteem Scale',
      'englishPath': ReqTest.kRosenbergSelfEsteemScale,
      'arabicPath': ReqTest.kRosenbergSelfEsteemScaleAr,
    },
    {
      'title': 'Taylor Anxiety Scale',
      'englishPath': ReqTest.kTaylorAnxietyScale,
      'arabicPath': ReqTest.kTaylorAnxietyScaleAr,
    },
    {
      'title': 'Cognitive Distortions Assessment',
      'englishPath': ReqTest.kCognitiveDistortionsAssessment,
      'arabicPath': ReqTest.kCognitiveDistortionsAssessmentAr,
    },
    {
      'title': 'Conners Test',
      'englishPath': ReqTest.kConnersTest,
      'arabicPath': ReqTest.kConnersTestAr,
    },
    {
      'title': 'Personality Disorders Test',
      'englishPath': ReqTest.kPersonalityDisordersTest,
      'arabicPath': ReqTest.kPersonalityDisordersTestAr,
    },
  ];

  @override
  void initState() {
    super.initState();
    _testsFuture = _loadAllTests();
  }

  Future<List<Test>> _loadAllTests() async {
    List<Test> tests = [];
    for (var testData in testsData) {
      try {
        final path = ReqTest.getLocalizedPath(
          context,
          testData['englishPath'],
          testData['arabicPath'],
        );
        Test test = await ReqTest.loadTest(path);
        tests.add(test);
      } catch (e) {
        debugPrint('Error loading test: ${testData['title']} -> $e');
      }
    }
    return tests;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secoundryColor,
      appBar: _buildAppBar(),
      body: FutureBuilder<List<Test>>(
        future: _testsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error loading tests: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final tests = snapshot.data!;
            return _buildTestsList(tests);
          } else {
            return const Center(child: Text('No tests available.'));
          }
        },
      ),
    );
  }

  Widget _buildTestsList(List<Test> tests) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: tests.length,
              itemBuilder: (context, index) {
                final test = tests[index];
                return TestCard(
                  test: test,
                  title: test.testTitle,
                  questionCount: test.questions.length,
                  isPayment: test.payment,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      foregroundColor: primaryColor,
      backgroundColor: secoundryColor,
      centerTitle: true,
      title: Text(
        // Localize the title as well
        Provider.of<LocaleProvider>(context).locale.languageCode == 'ar'
            ? 'الاختبارات'
            : 'Tests',
        style: TextStyle(
          color: primaryColor,
          fontSize: 26.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
