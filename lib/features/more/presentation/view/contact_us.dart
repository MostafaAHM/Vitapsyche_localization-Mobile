import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_mindmed_project/core/theme/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_mindmed_project/generated/l10n.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  Future<void> sendEmail() async {
    final localizations = S.of(context);
    final Email email = Email(
      body: '''
${localizations.firstName}: ${_firstNameController.text}
${localizations.lastName}: ${_lastNameController.text}
${localizations.email}: ${_emailController.text}
${localizations.phone}: ${_phoneController.text}
${localizations.message}: ${_messageController.text}
''',
      subject: localizations.contactUsFormSubmission,
      recipients: ['graduation.team2025@gmail.com'],
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizations.emailSentSuccessfully)),
      );

      // Clear all text fields after sending the email
      _firstNameController.clear();
      _lastNameController.clear();
      _emailController.clear();
      _phoneController.clear();
      _messageController.clear();
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${localizations.failedToSendEmail}: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = S.of(context);
    
    return Scaffold(
      backgroundColor: secoundryColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        foregroundColor: primaryColor,
        backgroundColor: secoundryColor,
        title: Text(
          localizations.youAreOurPriority,
          style: TextStyle(
            color: primaryColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(localizations),
            SizedBox(height: 20.h),
            _buildNameFields(localizations),
            SizedBox(height: 10.h),
            _buildEmailField(localizations),
            SizedBox(height: 10.h),
            _buildPhoneField(localizations),
            SizedBox(height: 10.h),
            _buildMessageField(localizations),
            SizedBox(height: 20.h),
            _buildSendButton(localizations),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(S localizations) {
    return Align(
      alignment: Alignment.center,
      child: Text(
        localizations.contactUsMessage,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
          color: mainBlueColor,
        ),
      ),
    );
  }

  Widget _buildNameFields(S localizations) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _firstNameController,
            decoration: InputDecoration(
              labelText: localizations.firstName,
              border: const UnderlineInputBorder(),
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: TextField(
            controller: _lastNameController,
            decoration: InputDecoration(
              labelText: localizations.lastName,
              border: const UnderlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField(S localizations) {
    return TextField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: localizations.email,
        border: const UnderlineInputBorder(),
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _buildPhoneField(S localizations) {
    return TextField(
      controller: _phoneController,
      decoration: InputDecoration(
        labelText: localizations.phone,
        border: const UnderlineInputBorder(),
      ),
      keyboardType: TextInputType.phone,
    );
  }

  Widget _buildMessageField(S localizations) {
    return TextField(
      controller: _messageController,
      maxLines: 5,
      decoration: InputDecoration(
        labelText: localizations.writeYourMessage,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildSendButton(S localizations) {
    return Center(
      child: ElevatedButton(
        onPressed: sendEmail,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        child: Text(
          localizations.sendComment,
          style: TextStyle(color: Colors.white, fontSize: 14.sp),
        ),
      ),
    );
  }
}