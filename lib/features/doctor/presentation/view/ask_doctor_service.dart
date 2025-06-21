import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mindmed_project/generated/l10n.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/colors.dart';

class AskDoctor extends StatefulWidget {
  const AskDoctor({super.key});

  @override
  State<AskDoctor> createState() => _AskDoctorState();
}

class _AskDoctorState extends State<AskDoctor> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  String? selectedQuestionFor;
  String? selectedGender;

  @override
  void dispose() {
    _questionController.dispose();
    _descriptionController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Widget _headerAskDoctor(String title) {
    return Padding(
      padding: EdgeInsets.only(top: 12.h, bottom: 8.h),
      child: Text(
        title,
        style: TextStyle(
          color: mainBlueColor,
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _textInputField({
    required TextEditingController controller,
    required String hint,
    int? maxLength,
    TextInputType inputType = TextInputType.text,
    int maxLines = 1,
    required BuildContext context, // Added context parameter
  }) {
    final localizations = S.of(context);

    return Card(
      elevation: 4,
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        maxLength: maxLength,
        maxLines: maxLines,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return localizations.fieldCannotBeEmpty;
          }
          return null;
        },
        inputFormatters: [
          LengthLimitingTextInputFormatter(maxLength),
        ],
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: grayColor.withAlpha(200)),
          counterText: '',
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        ),
      ),
    );
  }

  Widget _optionSelector(String option, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: primaryColor, width: 1.5),
        ),
        child: Text(
          option,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: isSelected ? primaryColor : grayColor,
          ),
        ),
      ),
    );
  }

  Widget _buildOptionsRow({
    required List<String> options,
    required String? selectedOption,
    required Function(String) onSelect,
  }) {
    return Row(
      children: options
          .map((option) => Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: _optionSelector(
                    option,
                    selectedOption == option,
                    () => onSelect(option),
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _script(BuildContext context) {
    final localizations = S.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      child: Text(
        localizations.answerDisclaimer,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12.sp,
          color: Colors.blueGrey,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = S.of(context);

    return Scaffold(
      backgroundColor: secoundryColor,
      appBar: AppBar(
        title: Text(
          localizations.askADoctor,
          style: TextStyle(color: primaryColor),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _headerAskDoctor(localizations.yourQuestion),
                _textInputField(
                  controller: _questionController,
                  hint: localizations.questionExample,
                  maxLength: 50,
                  context: context,
                ),
                SizedBox(height: 4.h),
                _textInputField(
                  controller: _descriptionController,
                  hint: localizations.questionDescriptionHint,
                  maxLength: 250,
                  maxLines: 3,
                  context: context,
                ),
                _headerAskDoctor(localizations.thisQuestionFor),
                _buildOptionsRow(
                  options: [
                    localizations.forYourself,
                    localizations.forSomeoneElse
                  ],
                  selectedOption: selectedQuestionFor,
                  onSelect: (value) {
                    setState(() => selectedQuestionFor = value);
                  },
                ),
                SizedBox(height: 12.h),
                _headerAskDoctor(localizations.gender),
                _buildOptionsRow(
                  options: [localizations.male, localizations.female],
                  selectedOption: selectedGender,
                  onSelect: (value) {
                    setState(() => selectedGender = value);
                  },
                ),
                _headerAskDoctor(localizations.age),
                _textInputField(
                  controller: _ageController,
                  hint: localizations.enterYourAge,
                  inputType: TextInputType.number,
                  context: context,
                ),
                SizedBox(height: 8.h),
                _ButtonSend(formKey: _formKey),
                _script(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ButtonSend extends StatelessWidget {
  const _ButtonSend({
    super.key,
    required GlobalKey<FormState> formKey,
  }) : _formKey = formKey;

  final GlobalKey<FormState> _formKey;

  @override
  Widget build(BuildContext context) {
    final localizations = S.of(context);
    _handleSendAction() {
      return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.done_outline_rounded,
              color: greenColor,
            ),
            SizedBox(
              width: 4.w,
            ),
            const Text(
              'Your question has been sent successfully!',
              style: TextStyle(color: secoundryColor),
            ),
          ],
        ),
        behavior: SnackBarBehavior.fixed,
        duration: const Duration(milliseconds: 550),
      ));
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            _handleSendAction();
            Future.delayed(
              const Duration(seconds: 1),
              () => Navigator.pop(context),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          elevation: 4,
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: Text(
          localizations.send,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
