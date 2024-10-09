import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yellca/bookmark/bookmark_screen.dart';
import 'package:yellca/home/home_screen.dart';
import 'package:yellca/models/favorite_provider.dart';
import 'package:yellca/models/auth_provider.dart';

class DestinationSetting extends StatefulWidget {
  const DestinationSetting({super.key});

  @override
  State<DestinationSetting> createState() => _DestinationSettingState();
}

class _DestinationSettingState extends State<DestinationSetting> {
  late List<bool> isSelected;

  final Map<int, List<String>> floorPlaces = {
    0: [
      '입구',
      '6101 컴퓨터강의실',
      '6103 컴퓨터강의실',
      '6104 컴퓨터강의실',
      '6105 반도체 소프트웨어과',
      '6106 김병국 교수',
      '6107 평생교육원상담실',
      '화장실'
    ],
    1: [
      '6201 소프트웨어공학과',
      '6202 컴퓨터강의실',
      '6203 컴퓨터강의실',
      '6204 최윤경 교수',
      '6205 지승현 교수',
      '6206 스마트IT학과'
    ],
    2: ['6301 컴퓨터강의실', '6302 컴퓨터강의실', '6303 김현우 교수', '6304 김지영 교수'],
    3: ['6401 컴퓨터강의실', '6402 컴퓨터강의실', '6403 황혜정 교수', '6404 강정호 교수'],
    4: [
      '6501 컨퍼런스룸',
      '6502 컴퓨터공학과 전용실습실',
      '6503 원종권 교수',
      '6504 박종열 교수',
      '6505 소회의실'
    ],
    5: ['6601 소프트웨어공학과 전용실습실', '6602 글로벌호스피탈리지 라운지', '6603 전통문화체험실'],
  };

  @override
  void initState() {
    super.initState();
    isSelected = List.generate(6, (index) => index == 0); // 1층을 기본으로 선택
  }

  void toggleSelect(int index) {
    setState(() {
      isSelected = List.generate(6, (i) => i == index); // 선택된 층만 true
    });
  }

  @override
  Widget build(BuildContext context) {
    int selectedIndex = isSelected.indexOf(true);
    List<String> places = floorPlaces[selectedIndex] ?? [];

    // FavoriteProvider에서 즐겨찾기 목록 가져오기
    final favoriteProvider = Provider.of<FavoriteProvider>(context);

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
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              iconTheme: IconThemeData(color: Colors.white), // 아이콘 색상 변경
              actions: [
                IconButton(
                  icon: Icon(Icons.home), // 홈 아이콘
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
            body: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            'a place in a building',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'PublicSans',
                            ),
                          ),
                          Text(
                            '목적지 찾기',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'PontanoSans',
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          // FavoriteProvider에서 즐겨찾기 목록 가져오기
                          final favoriteProvider = Provider.of<FavoriteProvider>(
                              context,
                              listen: false);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookmarkScreen(
                                  favoritePlaces:
                                      favoriteProvider.favorites), // 수정된 부분
                            ),
                          );
                        },
                        child: Image.asset(
                          'assets/image/home/place-icon_check.png',
                          width: 100,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: ToggleButtons(
                            children: const [
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Text('1F')),
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Text('2F')),
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Text('3F')),
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Text('4F')),
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Text('5F')),
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Text('6F')),
                            ],
                            isSelected: isSelected,
                            onPressed: toggleSelect,
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: places.length,
                          itemBuilder: (context, index) {
                            String place = places[index];
                            return ListTile(
                              title: Text(place),
                              trailing: IconButton(
                                icon: Icon(
                                  favoriteProvider.isFavorite(place)
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: favoriteProvider.isFavorite(place)
                                      ? Colors.red
                                      : null,
                                ),
                                onPressed: () {
                                  // 하트 아이콘 클릭 시 즐겨찾기 추가/제거
                                  favoriteProvider.toggleFavorite(place);
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
