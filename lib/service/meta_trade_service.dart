import 'package:flexy_markets/constant/user_constant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MetaTradeService {
  static const String _baseUrl = 'https://backend.boostbullion.com';

  Future<Map<String, dynamic>> getMT5AccountList({int page = 1, int sizePerPage = 10}) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/user/mt5/account/list?page=$page&sizePerPage=$sizePerPage'),
        headers: {
          'Authorization': UserConstants.TOKEN ?? '',
        },
      );

      final responseData = json.decode(response.body);

      print(responseData);
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
          'message': responseData['message'] ?? 'Failed to fetch MT5 account list',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: ${e.toString()}',
      };
    }
  }


  Future<Map<String, dynamic>> getMT5GroupList({int page = 1, int sizePerPage = 10}) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/user/mt5/group/list?page=$page&sizePerPage=$sizePerPage'),
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
          'message': responseData['message'] ?? 'Failed to fetch MT5 group list',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> createMT5Account({
    required int groupId,
    required String leverage,
    required String mainPassword,
    required String investorPassword,
  }) async {
    try {
      print(leverage);
      final response = await http.post(
        Uri.parse('$_baseUrl/user/mt5/create/account'),
        headers: {
          'Authorization': UserConstants.TOKEN ?? '',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'groupId': groupId.toString(),
          'Leverage': leverage,
          'PassMain': mainPassword,
          'PassInvestor': investorPassword,
        },
      );
      print(response.body);
      print(response.statusCode);
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
          'message': responseData['message'] ?? 'Failed to create MT5 account',
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