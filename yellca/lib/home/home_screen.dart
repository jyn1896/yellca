import 'dart:math';

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:provider/provider.dart';

import 'package:yellca/authentication/login_screen.dart';
import 'package:yellca/bookmark/bookmark_screen.dart';
import 'package:yellca/location/bt_test.dart';
import 'package:yellca/models/profile_screen.dart';
import 'package:yellca/destination/destination_screen.dart';
import 'package:yellca/models/favorite_provider.dart';



class HomeScreen extends StatefulWidget {
  final bool isLoggedIn;
  final String? nickname;
  final String? profileImagePath;

  HomeScreen({
    required this.isLoggedIn,
    this.nickname,
    this.profileImagePath,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  String _currentBuilding = '현재 건물 정보';
  String _currentkoongya = '현재 건물 내 내위치';

  void _updatelocation(String updatedBuilding) {
    setState(() {
      _currentBuilding = updatedBuilding;
    });
  }


  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _text = '';
  OverlayEntry? _overlayEntry;

  void _startListening() async {
    if (await _speech.initialize()) {
      print("음성 인식 초기화 성공");
      setState(() {
        _isListening = true;
        _text = ''; // 초기 텍스트 설정
      });

      _speech.listen(onResult: (result) {
        // 음성 인식 결과가 업데이트 될 때마다 로그 출력
        print("인식된 단어: ${result.recognizedWords}");
        setState(() {
          _text = result.recognizedWords; // 인식된 단어를 UI에 업데이트
          print("현재 _text: $_text");
        });

        // 최종 결과인 경우 결과 화면으로 전환
        if (result.finalResult) {
          _showResultOverlay(); // 음성 인식이 끝나면 결과 화면 표시
        }
      });
    } else {
      print("음성 인식 초기화 실패");
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() {
      _isListening = false;
    });
  }

  void _showOverlay() {
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height / 2 - 230,
        left: MediaQuery.of(context).size.width / 2 - 125,
        child: Material(
          borderRadius: BorderRadius.circular(10),
          elevation: 8,
          child: Container(
            width: 250,
            height: 450,
            padding: EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // 닫기 버튼
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.black),
                    onPressed: () {
                      _stopListening(); // 음성 인식 중지
                      if (_overlayEntry != null) {
                        _overlayEntry!.remove(); // 오버레이 제거
                        _overlayEntry = null; // 오버레이 엔트리 null로 설정
                      }
                    },
                  ),
                ),
                SizedBox(height: 20),

                // 인식 중... 아이콘
                Image.asset(
                  'assets/image/voice/listening-icon.png', // 원하는 이미지 경로로 변경하세요
                  width: 80,
                  height: 80,
                ),

                SizedBox(height: 20),

                // 인식 중... 텍스트
                Text(
                  '인식 중...',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),

                // 음성 인식 결과
                Text(
                  _text.isEmpty ? '목적지를 말씀해주세요' : _text,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context)?.insert(_overlayEntry!);
    _startListening(); // 음성 인식 시작
  }

  void _showResultOverlay() {
    _overlayEntry?.remove(); // 기존 오버레이 제거
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height / 2 - 230,
        left: MediaQuery.of(context).size.width / 2 - 125,
        child: Material(
          borderRadius: BorderRadius.circular(10),
          elevation: 8,
          child: Container(
            width: 250,
            height: 450,
            padding: EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // 닫기 버튼
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.black),
                    onPressed: () {
                      _stopListening(); // 음성 인식 중지
                      if (_overlayEntry != null) {
                        _overlayEntry!.remove(); // 오버레이 제거
                        _overlayEntry = null; // 오버레이 엔트리 null로 설정
                      }
                    },
                  ),
                ),
                SizedBox(height: 20),

                // 새 이미지
                Image.asset('assets/image/home/location-icon_cube.gif', width: 100, height: 100),

                SizedBox(height: 20),

                // 인식된 텍스트
                Text(
                  _text,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 20),

                // 확인 멘트
                Text(
                  '말씀하신 목적지가 맞나요?',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 20),

                // 버튼들
                ElevatedButton(
                  onPressed: () {
                    print('해당 목적지 검색: $_text');
                    _stopListening();
                    _overlayEntry?.remove();
                    _overlayEntry = null;
                    // 검색 화면으로 이동하는 코드 추가
                  },
                  child: Text("해당 목적지 검색"),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _text = ''; // 텍스트 초기화
                    });
                    _showOverlay(); // 다시 인식
                  },
                  child: Text("다시 말하기"),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context)?.insert(_overlayEntry!);
  }



  @override
  Widget build(BuildContext context) {
   return Stack(
     children: [
       Container(
         decoration: BoxDecoration(
           gradient: LinearGradient(
             begin: Alignment(0.00, -1.00),
             end: Alignment(0.0, 1.0),
             colors: [Color(0xFF020056), Colors.black],
             stops: [0.0, 0.22],
           ),
         ),
         child: Center(
           child: Opacity(
             opacity: 0.4,
             child: Image.asset(
               'assets/image/yellca/app-symbol.png',
               height: 606,
               fit: BoxFit.cover,
             ),
           ),
         ),
       ),
       Padding(
         padding: const EdgeInsets.all(8.0),
         child: Scaffold(
           backgroundColor: Colors.transparent,
           body: CustomScrollView(
             slivers: [
               SliverAppBar(
                 pinned: true,
                 expandedHeight: 130,
                 backgroundColor: Colors.transparent,
                 automaticallyImplyLeading: false,
                 flexibleSpace: FlexibleSpaceBar(
                   title: Row(
                     mainAxisAlignment: MainAxisAlignment.start,
                     children: [
                       Text(
                         'yellca',
                         style: TextStyle(
                           fontSize: 38,
                           color: Colors.white,
                           fontFamily:'PaytoneOne',
                         ),
                       ),
                     ],
                   ),
                 ),
                 actions: [
                   GestureDetector(
                     onTap: widget.isLoggedIn ? null : () {
                       // 로그인 상태가 아닐 때만 LoginScreen으로 이동
                       Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                     },
                     child: Row(
                       children: [
                         Text(
                           widget.isLoggedIn && widget.nickname != null
                               ? '${widget.nickname}님'
                               : '로그인 해주세요',
                           style: TextStyle(
                             fontSize: 16,
                             color: widget.isLoggedIn && widget.nickname != null
                                 ? Colors.white // 로그인 상태일 때 글자색 흰색
                                 : Colors.redAccent, // 로그인 하지 않았을 때 글자색 빨간색
                           ),
                         ),
                         SizedBox(
                           width: 16,
                         ),
                         GestureDetector(
                           onTap: () {
                             //로그인 상태일 때 프로필 이미지 클릭하면 프로필 페이지로 이동
                             if (widget.isLoggedIn) {
                               Navigator.push(
                                 context,
                                 MaterialPageRoute(builder: (context) => ProfileScreen())
                               );
                             }
                           },
                           child: CircleAvatar(
                             radius: 25,
                             backgroundImage:
                             AssetImage(
                               widget.isLoggedIn && widget.profileImagePath != null
                                     ? 'assets/image/login/koongya_profile.png'
                                     : 'assets/image/login/default_profile.png',
                                 )
                           ),
                         ),
                       ],
                     ),
                   ),
                 ],
               ),

               SliverPersistentHeader(
                 pinned: true,
                 floating: false,
                 delegate: MySliverPersistentHeaderDelegate(
                   minHeight: 77.0,
                   maxHeight: 77.0,
                   child: Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: TextField(
                       style: TextStyle(color: Colors.white),
                       decoration: InputDecoration(
                         filled: true,
                         fillColor: Color.fromRGBO(255, 255, 255, 0.26),
                         hintText: '목적지를 입력하세요',
                         hintStyle: TextStyle(color: Colors.white70),
                         border: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(40.0),
                           borderSide:
                           BorderSide(color: Colors.white),
                         ),
                         enabledBorder: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(16.0),
                           borderSide: BorderSide(
                               color: Colors.transparent), // 기본 테두리 색상
                         ),
                         suffixIcon: Row(
                           mainAxisSize: MainAxisSize.min,
                           children: [
                             ElevatedButton(
                               onPressed: _isListening ? null : _showOverlay,
                               child: Icon(Icons.keyboard_voice, color: Colors.white),
                               style: ButtonStyle(
                                 backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                       (Set<MaterialState> states) {
                                     return Colors.transparent; // 투명 배경 설정
                                   },
                                 ),
                                 elevation: MaterialStateProperty.all(0), // 그림자 없애기
                               ),
                             ),
                             IconButton(
                               icon: const Icon(Icons.search,
                                   color: Colors.white),
                               // 아이콘 색상
                               onPressed: () {

                               },
                             ),
                           ],
                         ),
                       ),
                     ),
                   ),
                 ),
               ),

               SliverToBoxAdapter(
                 child: Container(
                   height: 900,
                   child: Column(
                     children: [
                       // 현재위치 컨테이너
                       Expanded(
                         flex: 2,
                         child: GestureDetector(
                           onTap: () {
                             // 건물 정보 업데이트
                             setState(() {
                               _currentBuilding = '배화여자대학교 목련관';
                             });
                           },
                           child: Container(
                             width: double.infinity,
                             margin: EdgeInsets.all(8.0),
                             decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(25.0),
                               color: Colors.white.withOpacity(0.5),
                             ),
                             child: Padding(
                               padding: const EdgeInsets.all(16.0),
                               child: Column(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 children: [
                                   Row(
                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                     children: [
                                       Column(
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                         children: [
                                           Text(
                                             'location',
                                             style: TextStyle(
                                               fontSize: 16,
                                               fontWeight: FontWeight.w400,
                                               fontFamily: 'PublicSans',
                                             ),
                                           ),
                                           Text(
                                             '현재 위치',
                                             style: TextStyle(
                                               fontSize: 24,
                                               fontWeight: FontWeight.w400,
                                               fontFamily: 'PontanoSans',
                                             ),
                                           ),
                                           SizedBox(height: 8.0),
                                           Text(
                                             _currentBuilding,
                                             style: TextStyle(
                                               color: Colors.white,
                                               fontSize: 20,
                                             ),
                                           ),
                                           // 이거 건물 내부 위치로 변경해야함
                                           // Text(
                                           //   _currentBuilding,
                                           //   style: TextStyle(
                                           //     color: Colors.white,
                                           //     fontSize: 20,
                                           //   ),
                                           // ),
                                         ],
                                       ),
                                       Image.asset(
                                         'assets/image/home/location-icon_cube.png',
                                         width: 120,
                                         fit: BoxFit.cover,
                                       ),
                                     ],
                                   ),
                                 ],
                               ),
                             ),
                           ),
                         ),
                       ),

                       Expanded(
                         flex: 2,
                         child: Row(
                           children: [

                             //목적지 설정 컨테이너
                             Expanded(
                               flex: 1,
                               child: GestureDetector(
                                 onTap: () {
                                   Navigator.push(
                                     context,
                                     MaterialPageRoute(builder: (context) => DestinationSetting())
                                   );
                                 },
                                 child: Container(
                                   width: double.infinity,
                                   margin: EdgeInsets.all(8.0),
                                   decoration: BoxDecoration(
                                     borderRadius: BorderRadius.circular(25.0),
                                     color: Colors.white.withOpacity(0.77),
                                   ),
                                   child: Center(
                                     child: Column(
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       mainAxisAlignment: MainAxisAlignment.center,
                                       children: [
                                         Image.asset(
                                           'assets/image/home/place-icon_check.png',
                                           width: 90,
                                           fit: BoxFit.cover,
                                         ),
                                         Text(
                                           'a place in a building',
                                           style: TextStyle(
                                             fontSize: 16,
                                             fontWeight: FontWeight.w400,
                                             fontFamily: 'PublicSans',
                                           ),
                                         ),
                                         Text(
                                           '목적지 찾기',
                                           style: TextStyle(
                                             fontSize: 30,
                                             fontWeight: FontWeight.w400,
                                             fontFamily: 'PontanoSans',
                                           ),
                                         ),
                                       ],
                                     ),
                                   ),
                                 ),
                               ),
                             ),

                             //즐겨찾기 컨테이너
                             Expanded(
                               flex: 1,
                               child: GestureDetector(
                                 onTap: (){
                                   //FavoriteProvider에서 즐겨찾기 목록 가져오기
                                   final favoriteProvider = Provider.of<FavoriteProvider>(context, listen: false);

                                   Navigator.push(
                                     context,
                                     MaterialPageRoute(builder: (context) => BookmarkScreen(favoritePlaces: favoriteProvider.favorites), //즐겨찾기목록 전
                                     )
                                   );
                                   },
                                 child: Container(
                                   width: double.infinity,
                                   margin: EdgeInsets.all(8.0),
                                   decoration: BoxDecoration(
                                       borderRadius: BorderRadius.circular(25.0),
                                       color: Color.fromRGBO(203, 221, 255, 0.8),
                                   ),
                                   child: Center(
                                     child: Column(
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       mainAxisAlignment: MainAxisAlignment.center,
                                       children: [
                                         Image.asset(
                                           'assets/image/home/bookmark-icon_heart.png',
                                           width: 90,
                                           fit: BoxFit.cover,
                                         ),
                                         Text(
                                           'a bookmarked place',
                                           style: TextStyle(
                                             fontSize: 16,
                                             fontWeight: FontWeight.w400,
                                             fontFamily: 'PublicSans-Regular',
                                           ),
                                         ),
                                         Text(
                                           '즐겨찾기',
                                           style: TextStyle(
                                             fontSize: 30,
                                             fontWeight: FontWeight.w400,
                                             fontFamily: 'PontanoSans-Regular',
                                           ),
                                         ),
                                       ],
                                     ),
                                   ),
                                 ),
                               ),
                             ),
                           ],
                         ),
                       ),
                       //커넥트 컨테이너
                       Expanded(
                         flex: 3,
                         child: GestureDetector(
                           onTap: () {
                             ///커넥트 컨테이너 클릭 시
                           },
                           child: Container(
                             width: double.infinity,
                             margin: EdgeInsets.all(8.0),
                             decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(25.0),
                               color: Color.fromRGBO(216, 223, 233, 1),
                             ),
                             child: Center(
                               child: Column(
                                 children: [
                                   ///커넥트 컨테이너 내부
                                 ],
                               ),
                             ),
                           ),
                         ),
                       ),
                       Expanded(
                         flex: 1,
                         child: Row(
                           children: [

                             //비상 연락처 컨테이너
                             Expanded(
                               flex: 1,
                               child: GestureDetector(
                                 onTap: () {
                                   //비상 연락처 컨테이너 클릭 시
                                 },
                                 child: Container(
                                   width: double.infinity,
                                   margin: EdgeInsets.all(8.0),
                                   decoration: BoxDecoration(
                                     borderRadius: BorderRadius.circular(25.0),
                                     color: Colors.white.withOpacity(0.95),
                                   ),
                                   child: Center(
                                     child: Row(
                                       mainAxisAlignment: MainAxisAlignment.center,
                                       children: [
                                         Image.asset(
                                           'assets/image/home/emergency-icon_contact.png',
                                           width: 65,
                                           fit: BoxFit.cover,
                                         ),
                                         Column(
                                           crossAxisAlignment: CrossAxisAlignment.start,
                                           mainAxisAlignment: MainAxisAlignment.center,
                                           children: [
                                             Text(
                                               'Emergency Contact',
                                               style: TextStyle(
                                                 fontSize: 12,
                                                 fontWeight: FontWeight.w400,
                                                 fontFamily:
                                                 'PublicSans-Regular',
                                               ),
                                             ),
                                             Text(
                                               '비상연락처',
                                               style: TextStyle(
                                                 fontSize: 25,
                                                 fontWeight: FontWeight.w400,
                                                 fontFamily:
                                                 'PontanoSans-Regular',
                                               ),
                                             ),
                                           ],
                                         ),
                                       ],
                                     ),
                                   ),
                                 ),
                               ),
                             ),

                             //사용설명서 컨테이너
                             Expanded(
                               flex: 1,
                               child: GestureDetector(
                                 onTap: () {
                                   ///사용설명서 컨테이너 클릭 시
                                 },
                                 child: Container(
                                   width: double.infinity,
                                   margin: EdgeInsets.all(8.0),
                                   decoration: BoxDecoration(
                                     borderRadius: BorderRadius.circular(25.0),
                                     color: Colors.white.withOpacity(0.95),
                                   ),
                                   child: Center(
                                     child: Row(
                                       mainAxisAlignment: MainAxisAlignment.center,
                                       children: [
                                         Image.asset(
                                           'assets/image/home/manual-icon.png',
                                           width: 65,
                                           fit: BoxFit.cover,
                                         ),
                                         Column(
                                           crossAxisAlignment: CrossAxisAlignment.start,
                                           mainAxisAlignment: MainAxisAlignment.center,
                                           children: [
                                             Text(
                                               'Manual',
                                               style: TextStyle(
                                                 fontSize: 12,
                                                 fontWeight: FontWeight.w400,
                                                 fontFamily: 'PublicSans-Regular',
                                               ),
                                             ),
                                             Text(
                                               '사용 설명서',
                                               style: TextStyle(
                                                 fontSize: 25,
                                                 fontWeight: FontWeight.w400,
                                                 fontFamily: 'PontanoSans-Regular',
                                               ),
                                             ),
                                           ],
                                         ),
                                       ],
                                     ),
                                   ),
                                 ),
                               ),
                             ),
                           ],
                         ),
                       ),

                       ///위치 상의해서 넣어야함
                       Expanded(
                         flex: 1,
                         child: GestureDetector(
                           onTap: () {
                             Navigator.push(
                                 context,
                                 MaterialPageRoute(builder: (context) => BtTest()),
                             );
                           },
                           child: Container(
                             width: double.infinity,
                             margin: EdgeInsets.all(8.0),
                             decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(25.0),
                               color: Colors.white.withOpacity(0.95),
                             ),
                             child: Center(
                               child: Text(
                                   '지팡이'
                               ),
                             ),
                           ),
                         ),
                       ),
                     ],
                   ),
                 ),
               ),
             ],
           ),
         ),
       ),
     ],
   );
  }
}


class MySliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  MySliverPersistentHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxExtent ||
        minHeight != oldDelegate.minExtent ||
        child != (oldDelegate as MySliverPersistentHeaderDelegate).child;
  }
}