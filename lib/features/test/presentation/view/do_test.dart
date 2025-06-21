// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mindmed_project/generated/l10n.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_mindmed_project/core/routes/app_routes.dart';
import 'package:flutter_mindmed_project/core/theme/colors.dart';
import 'package:flutter_mindmed_project/features/test/data/test.dart';

import '../../cubit/do_text_cubit.dart';

class DoTest extends StatelessWidget {
  final Test test;

  const DoTest({
    super.key,
    required this.test,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = S.of(context);
    return BlocProvider(
      create: (_) => DoTestCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          foregroundColor: primaryColor,
          backgroundColor: secoundryColor,
          elevation: 0,
          centerTitle: true,
          title: Text(
            localizations.depressionScale,
            style: TextStyle(
                color: primaryColor, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              const SizedBox(height: 10),
              _buildDescription(context),
              Expanded(child: _buildQuestions()),
              const SizedBox(height: 20),
              _buildNavigationBar(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDescription(context) {
    final localizations = S.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        localizations.testInstructions,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildQuestions() {
    return BlocBuilder<DoTestCubit, DoTestState>(
      builder: (context, state) {
        final cubit = context.read<DoTestCubit>();
        final question = test.questions[state.currentIndex].question;
        final choices = test.questions[state.currentIndex].choices;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              question ?? 'no question',
              style: const TextStyle(
                color: mainBlueColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ...choices.map<Widget>((choice) {
              final bool isSelected =
                  state.selectedAnswers[state.currentIndex] == choice.text;
              int sorce = choice.score;

              return _buildChoiceButton(
                  choice.text ?? "bad boy", isSelected, cubit, sorce);
            }),
          ],
        );
      },
    );
  }

  Widget _buildChoiceButton(
      String choice, bool isSelected, DoTestCubit cubit, int socre) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: GestureDetector(
        onTap: () {
          cubit.selectAnswer(cubit.state.currentIndex, choice, socre);
        },
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? grayColor.withOpacity(0.1) : secoundryColor,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: primaryColor,
              width: 2,
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15).w,
          child: Center(
            child: Text(
              choice,
              style: TextStyle(
                color: isSelected ? primaryColor : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationBar(context) {
    final localizations = S.of(context);
    return BlocBuilder<DoTestCubit, DoTestState>(
      builder: (context, state) {
        final cubit = context.read<DoTestCubit>();

        return Column(
          children: [
            linearQuestionAndAnswer(
                state.currentIndex + 1, test.questions.length.toDouble()),
            FittedBox(
              child: Text(
                '${localizations.question} ${state.currentIndex + 1} ${localizations.of} ${test.questions.length}',
                style: TextStyle(fontSize: 10.sp),
              ),
            ),
            Row(
              mainAxisAlignment: state.currentIndex == 0
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.spaceBetween,
              children: [
                if (state.currentIndex > 0)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      elevation: 2,
                    ),
                    onPressed: cubit.previousQuestion,
                    child: Text(
                      localizations.previous,
                      style: TextStyle(color: secoundryColor),
                    ),
                  ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    elevation: 2,
                  ),
                  onPressed: () {
                    if (state.selectedAnswers.containsKey(state.currentIndex)) {
                      cubit.nextQuestion(test.questions.length);
                      if (state.isComplete) {
                        if (test.testTitle == "Personality Disorders Test") {
                          Navigator.of(context).pushReplacementNamed(
                            AppRoutes.personalityDisorderResult,
                            arguments: {
                              'answers':
                                  state.selectedAnswers, // ← Map<int, String>
                            },
                          );
                        } else {
                          Navigator.of(context).pushReplacementNamed(
                            AppRoutes.depressionScaleResult,
                            arguments: {
                              'test': test,
                              'totalScore': state.totalSorce,
                            },
                          );
                        }
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: Duration(seconds: 1),
                          content: Text(localizations.selectAnswerWarning),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: Text(
                    state.currentIndex == test.questions.length - 1
                        ? localizations.submit
                        : localizations.next,
                    style: const TextStyle(color: secoundryColor),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  Widget linearQuestionAndAnswer(double question, double totalQuestion) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: primaryColor)),
        child: LinearProgressIndicator(
          value: question / totalQuestion,
          backgroundColor: secoundryColor,
          valueColor: const AlwaysStoppedAnimation<Color>(primaryColor),
          minHeight: 7,
        ),
      ),
    );
  }
}
