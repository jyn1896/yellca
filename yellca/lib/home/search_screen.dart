import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.00, -1.00),
                end: Alignment(0, 1),
                colors: [Color(0xFF020056), Colors.black],
                stops: [0.0, 0.22],
              ),
            ),
            child: Opacity(
              opacity: 0.4,
              child: Image.asset(
                'assets/image/yellca/app-symbol.png',
                height: 606,
                fit: BoxFit.cover,
              ),
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            top: _isFocused ? 40 : 200, // 위치 조정
            left: 16,
            right: 16,
            child: Hero(
              tag: 'searchFocused',
              child: TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color.fromRGBO(255, 255, 255, 0.26),
                  hintText: '목적지를 입력하세요',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40.0),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.keyboard_voice, color: Colors.white),
                        onPressed: () {
                          // 음성 검색 눌렀을 시
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.search, color: Colors.white),
                        onPressed: () {
                          // 검색 버튼 클릭 시
                        },
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  setState(() {
                    _isFocused = true;
                  });
                  FocusScope.of(context).requestFocus(FocusNode());
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
