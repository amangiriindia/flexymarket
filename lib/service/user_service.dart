
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constant/user_constant.dart';


class UserService {
static const String _baseUrl = 'https://backend.boostbullion.com';

// Fetch login history
Future<Map<String, dynamic>> getLoginHistory({int page = 1, int sizePerPage = 10}) async {
final url = Uri.parse('$_baseUrl/user/auth/login/history?page=$page&sizePerPage=$sizePerPage');
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
}
