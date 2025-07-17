import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../constant/user_constant.dart';
import 'package:http_parser/http_parser.dart';


class UserService {
  static const String _baseUrl = 'https://backend.boostbullion.com';

  // Fetch login history
  Future<Map<String, dynamic>> getLoginHistory({
    int page = 1,
    int sizePerPage = 10,
  }) async {
    final url = Uri.parse(
      '$_baseUrl/user/auth/login/history?page=$page&sizePerPage=$sizePerPage',
    );
    final response = await http.get(
      url,
      headers: {
        'Authorization': UserConstants.TOKEN ?? '',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to fetch login history: ${response.statusCode}');
    }
  }


  Future<Map<String, dynamic>> updateProfile({
    required String name,
    required String dob,
    required String gender,
    required String address,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/user/profile/update'),
        headers: {
          'Authorization': UserConstants.TOKEN ?? '',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {'name': name, 'dob': dob, 'gender': gender, 'address': address},
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200 && responseData['status'] == true) {
        return {
          'success': true,
          'message': responseData['message'],
          'data': responseData['data'],
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to update profile',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }


  Future<Map<String, dynamic>> addBankDetails({
    required String holderName,
    required String accountNo,
    required String ifscCode,
    required String ibanNo,
    required String bankName,
    required String bankAddress,
    required String country,
    required File image,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/user/compliance/add/bank?holderName=$holderName&accountNo=$accountNo&ifscCode=$ifscCode&ibanNo=$ibanNo&bankName=$bankName&bankAddress=$bankAddress&country=$country'),
      );
      request.headers['Authorization'] = UserConstants.TOKEN ?? '';
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          image.path,
          contentType: MediaType('image', 'png'),
        ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['status'] == true) {
        return {
          'success': true,
          'message': responseData['message'],
          'data': responseData['data'],
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to add bank details',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: ${e.toString()}',
      };
    }
  }



  Future<Map<String, dynamic>> getBankDetails() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/user/compliance/bank/details'),
        headers: {
          'Authorization': UserConstants.TOKEN ?? '',
        },
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200 && responseData['status'] == true) {
        return {
          'success': true,
          'message': responseData['message'],
          'data': responseData['data'],
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to fetch bank details',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: ${e.toString()}',
      };
    }




  }



  Future<Map<String, dynamic>> uploadDocuments({
    required File poi,
    required File poa,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/user/compliance/upload/doc'),
      );
      request.headers['Authorization'] = UserConstants.TOKEN ?? '';
      request.files.add(
        await http.MultipartFile.fromPath(
          'poi',
          poi.path,
          contentType: MediaType('image', 'png'),
        ),
      );
      request.files.add(
        await http.MultipartFile.fromPath(
          'poa',
          poa.path,
          contentType: MediaType('image', 'png'),
        ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final responseData = json.decode(response.body);
        print(response.body);
        print(response.statusCode);

      if (response.statusCode == 200 && responseData['status'] == true) {
        return {
          'success': true,
          'message': responseData['message'],
          'data': responseData['data'],
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to upload documents',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> getDocumentDetails() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/user/compliance/document/details'),
        headers: {
          'Authorization':UserConstants.TOKEN ?? '',
        },
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200 && responseData['status'] == true) {
        return {
          'success': true,
          'message': responseData['message'],
          'data': responseData['data'],
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to fetch document details',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: ${e.toString()}',
      };
    }
  }


  Future<Map<String, dynamic>> changeLoginPassword({
    required String oldPassword,
    required String newPassword,
    required String cnfPassword,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/user/auth/change/login/password'),
        headers: {
          'Authorization': UserConstants.TOKEN ?? '',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'oldPassword': oldPassword,
          'newPassword': newPassword,
          'cnfPassword': cnfPassword,
        },
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200 && responseData['status'] == true) {
        return {
          'success': true,
          'message': responseData['message'],
          'data': responseData['data'],
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to change password',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: ${e.toString()}',
      };
    }
  }

}
