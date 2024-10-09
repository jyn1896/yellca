import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:yellca/models/auth_provider.dart';
import 'package:yellca/models/favorite_provider.dart';
import 'package:yellca/splash_screen.dart';

void main() {
  runApp(
    MultiProvider( // 여러 Provider를 등록할 수 있는 MultiProvider 사용
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => FavoriteProvider()), // FavoriteProvider 추가
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
    );
  }
}