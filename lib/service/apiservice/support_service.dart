import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../constant/user_constant.dart';
import '../authloginservice/auth_check_vaild_user.dart';


class SupportService {
  static const String _baseUrl = 'https://backend.boostbullion.com';

  // Fetch ticket list with optional status filter
  Future<Map<String, dynamic>> fetchTicketList({
    int page = 1,
    int sizePerPage = 10,
    String? status,
  }) async {
    final url = Uri.parse(
      '$_baseUrl/user/support/list?page=$page&sizePerPage=$sizePerPage${status != null ? '&status=$status' : ''}',
    );
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
      throw Exception('Failed to fetch ticket list: ${response.statusCode} - ${response.body}');
    }
  }

  // Create a new ticket
  Future<Map<String, dynamic>> createTicket({
    required String subject,
    required String priority,
    required String message,
  }) async {
    final url = Uri.parse('$_baseUrl/user/support/create');
    final response = await http.post(
      url,
      headers: {
        'Authorization': UserConstants.TOKEN ?? '',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'subject': subject,
        'priority': priority.toUpperCase(),
        'message': message,
      },
    );
     print(response.statusCode);
     print(response.body);
    await checkValidUser(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      if (response.body.contains('<html') || response.body.contains('<pre>')) {
        final errorMessage = response.body.replaceAll(RegExp(r'<[^>]+>'), '').trim();
        throw Exception('Server error: ${response.statusCode} - $errorMessage');
      }
      throw Exception('Failed to create ticket: ${response.statusCode} - ${response.body}');
    }
  }

  // Fetch ticket details by ID
  Future<Map<String, dynamic>> fetchTicketDetails(int ticketId) async {
    final url = Uri.parse('$_baseUrl/user/support/$ticketId');
    final response = await http.get(
      url,
      headers: {
        'Authorization': UserConstants.TOKEN ?? '',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );
     print(response.body);
     print(response.statusCode);
    await checkValidUser(response.statusCode);
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      if (response.body.contains('<html') || response.body.contains('<pre>')) {
        final errorMessage = response.body.replaceAll(RegExp(r'<[^>]+>'), '').trim();
        throw Exception('Server error: ${response.statusCode} - $errorMessage');
      }
      throw Exception('Failed to fetch ticket details: ${response.statusCode} - ${response.body}');
    }
  }

  // Close a ticket
  Future<Map<String, dynamic>> closeTicket(int ticketId) async {
    final url = Uri.parse('$_baseUrl/user/support/close');
    final response = await http.post(
      url,
      headers: {
        'Authorization': UserConstants.TOKEN ?? '',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'ticketId': ticketId.toString(),
      },
    );
    print(response.statusCode);
    print(response.body);
    await checkValidUser(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      if (response.body.contains('<html') || response.body.contains('<pre>')) {
        final errorMessage = response.body.replaceAll(RegExp(r'<[^>]+>'), '').trim();
        throw Exception('Server error: ${response.statusCode} - $errorMessage');
      }
      throw Exception('Failed to close ticket: ${response.statusCode} - ${response.body}');
    }
  }

  // Send a reply to a ticket
  Future<Map<String, dynamic>> sendReply(int ticketId, String message) async {
    final url = Uri.parse('$_baseUrl/user/support/replay');
    final response = await http.put(
      url,
      headers: {
        'Authorization': UserConstants.TOKEN ?? '',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'ticketId': ticketId.toString(),
        'message': message,
      },
    );
    print(response.statusCode);
    print(response.body);
    await checkValidUser(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      if (response.body.contains('<html') || response.body.contains('<pre>')) {
        final errorMessage = response.body.replaceAll(RegExp(r'<[^>]+>'), '').trim();
        throw Exception('Server error: ${response.statusCode} - $errorMessage');
      }
      throw Exception('Failed to send reply: ${response.statusCode} - ${response.body}');
    }
  }
}