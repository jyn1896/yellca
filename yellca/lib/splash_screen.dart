import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yellca/home/home_screen.dart';
import 'package:yellca/models/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _firstWidgetController;
  late AnimationController _secondWidgetController;
  bool _showFirstWidget = true;

  @override
  void initState() {
    super.initState();

    _firstWidgetController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _secondWidgetController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    // 화면이 켜졌을 때 자동으로 애니메이션 시작
    Future.delayed(Duration(seconds: 1), () {
      _firstWidgetController.forward().then((_) {
        setState(() {
          _showFirstWidget = false; // 첫 번째 위젯 숨김
        });
        _secondWidgetController.forward(); // 두 번째 위젯 커짐 애니메이션 시작

        // 2초 후 로그인 상태에 따라 HomeScreen으로 이동
        Future.delayed(Duration(seconds: 2), () {
          final authProvider = Provider.of<AuthProvider>(context, listen: false);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(
                isLoggedIn: authProvider.isLoggedIn,
                nickname: authProvider.nickname,
                profileImagePath: authProvider.profileImagePath,
              ),
            ),
          );
        });
      });
    });
  }

  @override
  void dispose() {
    _firstWidgetController.dispose();
    _secondWidgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff020056),
              Color(0xff000000),
            ],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment(0.0, 0.0), // 정가운데
              child: Opacity(
                opacity: 0.3,
                child: Image.asset(
                  'assets/image/yellca/app-symbol.png',
                  height: 606,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // 첫 번째 위젯: 가운데를 중심으로 작아지며 사라짐
            ScaleTransition(
              scale: Tween<double>(begin: 1.0, end: 0.0).animate(
                CurvedAnimation(
                  parent: _firstWidgetController,
                  curve: Curves.easeInOut,
                ),
              ),
              child: _showFirstWidget
                  ? Column(
                key: ValueKey(1),
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/image/yellca/app-icon-circle.png',
                        width: 63.96,
                        fit: BoxFit.cover,
                      ),
                      Image.asset(
                        'assets/image/yellca/yellca_text.png',
                        width: 245,
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    "시각장애인을 위한 프리미엄 실내 내비게이션 앱",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ],
              )
                  : Container(),
            ),
            // 두 번째 위젯: 이미지 위쪽으로, 텍스트 아래쪽으로 커지기
            Positioned(
              top: MediaQuery.of(context).size.height / 2 - 80, // 이미지 위로 80만큼 올리기
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                    parent: _secondWidgetController,
                    curve: Curves.easeInOut,
                  ),
                ),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/image/yellca/app-icon-circle.png',
                      width: 63.96,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 64), // 이미지와 텍스트 사이의 간격
                    ScaleTransition(
                      scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                          parent: _secondWidgetController,
                          curve: Curves.easeInOut,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            "옐카와 함께",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "실내 어디든 자유롭게",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
