import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  static const String _baseUrl = 'https://backend.boostbullion.com';

  // Login method (unchanged)
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/user/auth/login'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'userName': username,
          'password': password,
        },
      );

      final responseData = jsonDecode(response.body);

      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200 && responseData['status'] == true) {
        return responseData;
      } else {
        throw responseData['message'] ?? 'Login failed';
      }
    } catch (e) {
      throw e.toString().startsWith('Exception: ')
          ? e.toString().replaceFirst('Exception: ', '')
          : '$e';
    }
  }

  // Signup method
  Future<Map<String, dynamic>> signup(String email, String password, String country) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/user/auth/signup'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'email': email,
          'password': password,
          'country': country,
        },
      );

      final responseData = jsonDecode(response.body);

      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200 && responseData['status'] == true) {
        return responseData;
      } else {
        throw responseData['message'] ?? 'Signup failed';
      }
    } catch (e) {
      throw e.toString().startsWith('Exception: ')
          ? e.toString().replaceFirst('Exception: ', '')
          : '$e';
    }
  }

  // Send OTP to email
  Future<void> sendOtpToEmail(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/user/auth/send/otp'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'email': email},
      );

      final responseData = jsonDecode(response.body);

      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200 && responseData['status'] == true) {
        return;
      } else {
        throw responseData['message'] ?? 'Failed to send OTP to email';
      }
    } catch (e) {
      throw e.toString().startsWith('Exception: ')
          ? e.toString().replaceFirst('Exception: ', '')
          : '$e';
    }
  }

  // Send OTP to phone
  Future<void> sendOtpToPhone(String mobile) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/user/auth/send/otp'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'mobile': mobile},
      );

      final responseData = jsonDecode(response.body);

      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200 && responseData['status'] == true) {
        return;
      } else {
        throw responseData['message'] ?? 'Failed to send OTP to phone';
      }
    } catch (e) {
      throw e.toString().startsWith('Exception: ')
          ? e.toString().replaceFirst('Exception: ', '')
          : '$e';
    }
  }

  // Verify OTP for email
  Future<void> verifyOtpForEmail(String email, String otp) async {
    try {
      final response = await http.patch(
        Uri.parse('$_baseUrl/user/auth/verify/otp'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'email': email,
          'otp': otp,
        },
      );

      final responseData = jsonDecode(response.body);

      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200 && responseData['status'] == true) {
        return;
      } else {
        throw responseData['message'] ?? 'Email OTP verification failed';
      }
    } catch (e) {
      throw e.toString().startsWith('Exception: ')
          ? e.toString().replaceFirst('Exception: ', '')
          : '$e';
    }
  }

  // Verify OTP for phone
  Future<void> verifyOtpForPhone(String mobile, String otp) async {
    try {
      final response = await http.patch(
        Uri.parse('$_baseUrl/user/auth/verify/otp'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'mobile': mobile,
          'otp': otp,
        },
      );

      final responseData = jsonDecode(response.body);

      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200 && responseData['status'] == true) {
        return;
      } else {
        throw responseData['message'] ?? 'Phone OTP verification failed';
      }
    } catch (e) {
      throw e.toString().startsWith('Exception: ')
          ? e.toString().replaceFirst('Exception: ', '')
          : '$e';
    }
  }
}