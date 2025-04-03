import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_mindmed_project/core/theme/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    final Email email = Email(
      body: '''
First Name: ${_firstNameController.text}
Last Name: ${_lastNameController.text}
Email: ${_emailController.text}
Phone: ${_phoneController.text}
Message: ${_messageController.text}
''',
      subject: 'Contact Us Form Submission',
      recipients: ['graduation.team2025@gmail.com'],
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email Sent Successfully!')),
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
        SnackBar(content: Text('Failed to send email: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
          'You are our priority',
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
            _buildHeader(),
            SizedBox(height: 20.h),
            _buildNameFields(),
            SizedBox(height: 10.h),
            _buildEmailField(),
            SizedBox(height: 10.h),
            _buildPhoneField(),
            SizedBox(height: 10.h),
            _buildMessageField(),
            SizedBox(height: 20.h),
            _buildSendButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Align(
      alignment: Alignment.center,
      child: Text(
        'We appreciate your comments and inquiries! Feel free to contact us.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
          color: mainBlueColor,
        ),
      ),
    );
  }

  Widget _buildNameFields() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _firstNameController,
            decoration: const InputDecoration(
              labelText: 'First Name',
              border: UnderlineInputBorder(),
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: TextField(
            controller: _lastNameController,
            decoration: const InputDecoration(
              labelText: 'Last Name',
              border: UnderlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return TextField(
      controller: _emailController,
      decoration: const InputDecoration(
        labelText: 'Email Address',
        border: UnderlineInputBorder(),
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _buildPhoneField() {
    return TextField(
      controller: _phoneController,
      decoration: const InputDecoration(
        labelText: 'Phone Number',
        border: UnderlineInputBorder(),
      ),
      keyboardType: TextInputType.phone,
    );
  }

  Widget _buildMessageField() {
    return TextField(
      controller: _messageController,
      maxLines: 5,
      decoration: const InputDecoration(
        labelText: 'Write your message..',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildSendButton() {
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
          'Send a Comment',
          style: TextStyle(color: Colors.white, fontSize: 14.sp),
        ),
      ),
    );
  }
}
