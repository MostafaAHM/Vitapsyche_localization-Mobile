import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mindmed_project/core/theme/colors.dart';
import 'package:flutter_mindmed_project/features/fqas/data/model_fqas.dart';
import 'package:flutter_mindmed_project/generated/l10n.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mindmed_project/main.dart'; // For LocaleProvider

class FqasScreen extends StatefulWidget {
  const FqasScreen({super.key});

  @override
  State<FqasScreen> createState() => _FqasScreenState();
}

class _FqasScreenState extends State<FqasScreen> {
  // Paths for both English and Arabic FAQs
  static const String _englishJsonPath = 'assets/json/FAQs.json';
  static const String _arabicJsonPath = 'assets/json/FAQs_arabic_full.json';

  Future<Fqas> _loadFqasData(BuildContext context) async {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final isArabic = localeProvider.locale.languageCode == 'ar';
    final jsonPath = isArabic ? _arabicJsonPath : _englishJsonPath;

    try {
      final String jsonString = await rootBundle.loadString(jsonPath);
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      return Fqas.fromJson(jsonData);
    } catch (e) {
      debugPrint('Error loading FAQ data: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secoundryColor,
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

  AppBar _buildAppBar() {
    final localizations = S.of(context);
    return AppBar(
      foregroundColor: primaryColor,
      backgroundColor: secoundryColor,
      centerTitle: true,
      title: Text(
        localizations.fqas,
        style: TextStyle(
          color: primaryColor,
          fontSize: 21.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return FutureBuilder<Fqas>(
      future: _loadFqasData(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error loading data: ${snapshot.error}'));
        }

        if (!snapshot.hasData) {
          return const Center(child: Text('No data available'));
        }

        return _buildFaqList(snapshot.data!);
      },
    );
  }

  Widget _buildFaqList(Fqas fqasData) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverFillRemaining(
          child: Container(
            color: secoundryColor,
            child: Column(
              children: [
                SizedBox(height: 10.h),
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (_, __) => SizedBox(height: 5.h),
                    itemCount: fqasData.fqas.length,
                    itemBuilder: (context, index) {
                      return AnimatedOpacity(
                        opacity: 1.0,
                        duration: Duration(milliseconds: 300),
                        child: _buildFaqItem(
                          question: fqasData.fqas[index].question,
                          answer: fqasData.fqas[index].answer,
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 10.h),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFaqItem({required String question, required String answer}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.0.h, horizontal: 10.0.w),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: Card(
          color: secoundryColor,
          child: ExpansionTile(
            maintainState: true,
            collapsedIconColor: textMainColor,
            iconColor: textMainColor,
            childrenPadding: EdgeInsets.symmetric(horizontal: 10.w),
            title: _buildQuestionRow(question),
            expandedAlignment: Alignment.topLeft,
            children: [_buildAnswerContainer(answer)],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionRow(String question) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.help_outline, size: 20.sp),
        SizedBox(width: 5.w),
        Expanded(
          child: Text(
            question,
            softWrap: true,
            style: TextStyle(
              color: textMainColor,
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnswerContainer(String answer) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 3.h),
        child: Text(
          answer,
          softWrap: true,
          style: TextStyle(
            color: grayColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
