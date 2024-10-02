import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user.dart';

Future<User?> login(String username, String password) async {
  final response = await http.post(
    Uri.parse('http://your-api-url/api/auth/login'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': username,
      'password': password,
    }),
  );

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    return User(
      userName: jsonResponse['username'],
      profileImageUrl: jsonResponse['profileImageUrl'],
    );
  } else {
    return null; // 로그인 실패 처리
  }
}
