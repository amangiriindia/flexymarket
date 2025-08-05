import 'dart:convert';
import 'package:http/http.dart' as http;

class ForgotPasswordService {
  static const String _baseUrl = 'https://backend.boostbullion.com';
  static const String _consumerKey = 'b53737e85e3ae186fbb21e16b22757ba';
  static const String _consumerSecret = 'bCSdm382HawO7hkGlVzqXLoPEcr4jFDt';

  Future<Map<String, dynamic>> sendOtp(String email) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/user/auth/forgot/password/send/otp'),
      headers: {
        'accept': 'application/json',
        'Authorization': _consumerSecret,
        'consumerKey': _consumerKey,
        'consumerSecret': _consumerSecret,
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'email': email,
      },
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> verifyOtp(String email, String otp, String authToken) async {
    final response = await http.patch(
      Uri.parse('$_baseUrl/user/auth/forgot/password/verify/otp'),
      headers: {
        'Authorization': authToken,
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'email': email,
        'otp': otp,
      },
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> resetPassword(String newPassword, String confirmPassword, String authToken) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/user/auth/reset/password'),
      headers: {
        'Authorization': authToken,
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'newPassword': newPassword,
        'cnfPassword': confirmPassword,
      },
    );

    return _handleResponse(response);
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final Map<String, dynamic> responseBody = jsonDecode(response.body);
    if (response.statusCode == 200 && responseBody['status'] == true) {
      return responseBody;
    } else {
      throw Exception(responseBody['message'] ?? 'Request failed with status: ${response.statusCode}');
    }
  }
}