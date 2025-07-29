import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../../constant/user_constant.dart';
import '../authloginservice/auth_check_vaild_user.dart';


class WalletService {
  static const String _baseUrl = 'https://backend.boostbullion.com';


  Future<Map<String, dynamic>> fetchUserData() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/user/updated/data'),
        headers: {
          'Authorization': UserConstants.TOKEN ?? '',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );
      print(response.statusCode);
      print(response.body);
      await checkValidUser(response.statusCode);
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to fetch user data: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error fetching user data: $e');
    }
  }

  // Submit withdrawal request
  Future<Map<String, dynamic>> submitWithdrawalRequest(double amount, String remark) async {
    final url = Uri.parse('$_baseUrl/user/bank/withdraw');
    final response = await http.post(
      url,
      headers: {
        'Authorization': UserConstants.TOKEN ?? '',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'amount': amount.toString(),
        'remark': remark,
      },
    );
    print(response.statusCode);
    print(response.body);
    await checkValidUser(response.statusCode);
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to submit withdrawal request: ${response.statusCode} - ${response.body}');
    }
  }

  // Submit deposit request
  Future<Map<String, dynamic>> submitDepositRequest({
    required double amount,
    required String transactionReference,
    required String remark,
    required File? image,
  }) async {
    final url = Uri.parse(
      '$_baseUrl/user/bank/deposit?transactionReference=$transactionReference&amount=$amount&remark=$remark',
    );
    final request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = UserConstants.TOKEN ?? ''
      ..headers['Content-Type'] = 'multipart/form-data';

    if (image != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          image.path,
          contentType: MediaType('image', 'jpeg'), // Adjust based on image type
        ),
      );
    }

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    print(response.statusCode);
    print(responseBody);
    await checkValidUser(response.statusCode);
    if (response.statusCode == 200) {
      return jsonDecode(responseBody) as Map<String, dynamic>;
    } else {
      if (responseBody.contains('<html') || responseBody.contains('<pre>')) {
        final errorMessage = responseBody.replaceAll(RegExp(r'<[^>]+>'), '').trim();
        throw Exception('Server error: ${response.statusCode} - $errorMessage');
      }
      throw Exception('Failed to submit deposit request: ${response.statusCode} - $responseBody');
    }
  }

  // Fetch deposit and withdraw transaction list
  Future<Map<String, dynamic>> fetchTransactionList({
    int page = 1,
    int sizePerPage = 10,
  }) async {
    final url = Uri.parse('$_baseUrl/user/deposit-withdraw/list?page=$page&sizePerPage=$sizePerPage');
    final response = await http.get(
      url,
      headers: {
        'Authorization': UserConstants.TOKEN ?? '',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );
    print(response.statusCode);
    print(response.body);
    await checkValidUser(response.statusCode);
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      if (response.body.contains('<html') || response.body.contains('<pre>')) {
        final errorMessage = response.body.replaceAll(RegExp(r'<[^>]+>'), '').trim();
        throw Exception('Server error: ${response.statusCode} - $errorMessage');
      }
      throw Exception('Failed to fetch transaction list: ${response.statusCode} - ${response.body}');
    }
  }

  // Fetch user transaction list
  Future<Map<String, dynamic>> fetchUserTransactionList({
    int page = 1,
    int sizePerPage = 10,
  }) async {
    final url = Uri.parse('$_baseUrl/user/transaction/list?page=$page&sizePerPage=$sizePerPage');
    final response = await http.get(
      url,
      headers: {
        'Authorization': UserConstants.TOKEN ?? '',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );
    print(response.statusCode);
    print(response.body);
    await checkValidUser(response.statusCode);
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      if (response.body.contains('<html') || response.body.contains('<pre>')) {
        final errorMessage = response.body.replaceAll(RegExp(r'<[^>]+>'), '').trim();
        throw Exception('Server error: ${response.statusCode} - $errorMessage');
      }
      throw Exception('Failed to fetch user transaction list: ${response.statusCode} - ${response.body}');
    }
  }
}