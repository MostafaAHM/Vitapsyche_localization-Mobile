import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class Api {
  static const String _baseUrl = "https://abdokh.pythonanywhere.com";

  Future<Map<String, dynamic>> registerDoctor(
      Map<String, dynamic> doctorData, File? profileImage, File? cvFile) async {
    final url = Uri.parse("$_baseUrl/api/register/doctor/");
    final request = http.MultipartRequest("POST", url);

    // Add text fields
    doctorData.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    // Attach profile image if available
    if (profileImage != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          profileImage.path,
          filename: basename(profileImage.path),
        ),
      );
    }

    // Attach CV file if available
    if (cvFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'cv',
          cvFile.path,
          filename: basename(cvFile.path),
        ),
      );
    }

    request.headers.addAll({'accept': 'application/json'});

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        return {
          'error': 'Failed to register doctor',
          'status': response.statusCode
        };
      }
    } catch (e) {
      return {'error': 'An error occurred: $e'};
    }
  }
}