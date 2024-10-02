import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:yellca/home/home_screen.dart';
import 'package:yellca/authentication/signup_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            '로그인',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.asset(
              'assets/image/yellca/yellca_text.png',
              width: 100,
              height: 100,
            ),
            const LoginForm(),
            SizedBox(height: 24.0),

            //회원가입 또는 비밀번호 찾기 링크
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignupScreen()),
                );
              },
              child: Text('회원가입'),
            ),
            TextButton(
              onPressed: () {
                //아이디 비밀번호 찾기 창으로 이동
              },
              child: Text('아이디 | 비밀번호 찾기'),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  late String user_id;
  late String user_pw;

  Future<void> login() async {

    final response = await http.post(
      Uri.parse('http://192.168.154.52:8081/api/auth/login'), // 정확한 URL 확인
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8', // 헤더 확인
      },
      body: jsonEncode(<String, String>{
        'username': user_id,
        'password': user_pw,
      }), // 본문 형식 확인
    );



    if (response.statusCode == 200) {
      // 로그인 성공
      print('로그인 성공 - 아이디: $user_id, 비밀번호: $user_pw');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      print('로그인 실패: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('아이디 또는 비밀번호가 올바르지 않습니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                labelText: '아이디',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return '아이디를 입력하세요';
                }
                return null;
              },
              onSaved: (value) {
                user_id = value!;
              },
            ),
            SizedBox(height: 16.0),
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: '비밀번호',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return '비밀번호를 입력하세요';
                }
                return null;
              },
              onSaved: (value) {
                user_pw = value!;
              },
            ),
            SizedBox(height: 16.0),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save(); // 폼 데이터 저장
                    print('유효성 검사 통과 - 아이디: $user_id, 비밀번호: $user_pw');

                    // login() 메서드 호출 추가
                    login();
                  }
                },
                child: Text(
                  '로그인',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
