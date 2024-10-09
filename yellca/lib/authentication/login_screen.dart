import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';

import 'package:yellca/home/home_screen.dart';
import 'package:yellca/authentication/signup_screen.dart';
import 'package:yellca/models/auth_provider.dart';
import 'package:yellca/authentication/login_to_cane_screen.dart';

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
              // 로그인 상태를 가져와서 HomeScreen으로 전달
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(
                    isLoggedIn: authProvider.isLoggedIn,
                    nickname: authProvider.nickname,
                    profileImagePath: authProvider.profileImagePath,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'yellca',
                style: TextStyle(
                  fontSize: 60,
                  color: Color(0xFF020056),
                  fontFamily: 'PaytoneOne',
                ),
              ),
              SizedBox(height: 16),
              const LoginForm(),
              SizedBox(height: 6.0),
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
                  // 아이디 비밀번호 찾기 창으로 이동
                },
                child: Text('아이디 | 비밀번호 찾기'),
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text('  간편 로그인  '),
                    ),
                    Expanded(
                      child: Divider(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginToCaneScreen()));
                          },
                          child: Image.asset(
                            'assets/image/login/otherlogin_cane.png',
                            width: 50,
                            height: 50,
                          ),
                        ),
                        Text('스마트지팡이'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/image/login/otherlogin_naver.png',
                          width: 50,
                          height: 50,
                        ),
                        Text(' 네이버 '),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/image/login/otherlogin_kakao.png',
                          width: 50,
                          height: 50,
                        ),
                        Text(' 카카오톡 '),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/image/login/otherlogin_google.png',
                          width: 50,
                          height: 50,
                        ),
                        Text('  구글  '),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
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
      Uri.parse('http://192.168.154.52:8081/api/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': user_id,
        'password': user_pw,
      }),
    );

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      String nickname = responseData['nickname'];
      String profileImagePath = 'assets/image/user/koongya_img.png';

      // 로그인 성공 시 HomeScreen으로 이동하며 로그인 상태를 전달
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            isLoggedIn: true,
            nickname: nickname,
            profileImagePath: profileImagePath,
          ),
        ),
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
                    _formKey.currentState!.save();
                    print('유효성 검사 통과 - 아이디: $user_id, 비밀번호: $user_pw');
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
