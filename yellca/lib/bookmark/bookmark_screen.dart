import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_switch/sliding_switch.dart';
import 'package:yellca/models/favorite_provider.dart';
import 'package:yellca/models/auth_provider.dart';
import 'package:yellca/home/home_screen.dart';

class BookmarkScreen extends StatefulWidget {
  final List<String> favoritePlaces; // 즐겨찾기 장소 목록을 위한 필드

  const BookmarkScreen({Key? key, required this.favoritePlaces})
      : super(key: key); // 생성자에서 필드를 받습니다.

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  bool isLocation = true;

  @override
  Widget build(BuildContext context) {
    // FavoriteProvider에서 즐겨찾기 목록 가져오기
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final favoritePlaces =
        widget.favoritePlaces; // 여기에서 widget.favoritePlaces를 사용합니다.
    final favoriteRoutes = favoriteProvider.favoriteRoutes;

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
                    final authProvider =
                        Provider.of<AuthProvider>(context, listen: false);
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
                              'a bookmarked place',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'PublicSans-Regular',
                              ),
                            ),
                            Text(
                              '즐겨찾기',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'PontanoSans-Regular',
                              ),
                            ),
                          ],
                        ),
                        Image.asset(
                          'assets/image/home/bookmark-icon_heart.png',
                          width: 90,
                          fit: BoxFit.cover,
                        ),
                      ],
                    )),
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
                          padding: const EdgeInsets.all(20.0),
                          child: SlidingSwitch(
                            value: isLocation,
                            width: 250,
                            onSwipe: () {},
                            onDoubleTap: () {},
                            onChanged: (bool value) {
                              setState(() {
                                isLocation = value;
                              });
                            },
                            onTap: () {
                              print(
                                  '스위치가 클릭되었습니다. 현재 상태: ${isLocation ? "장소" : "경로"}');
                            },
                            height: 55,
                            animationDuration:
                                const Duration(milliseconds: 400),
                            textOff: "경로",
                            textOn: "장소",
                            iconOff: Icons.directions,
                            iconOn: Icons.place,
                            colorOn: const Color(0xffdc6c73),
                            colorOff: const Color(0xff6682c0),
                            background: const Color(0xffe4e5eb),
                            buttonColor: const Color(0xfff7f5f7),
                            inactiveColor: const Color(0xff636f7b),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: isLocation
                                ? favoritePlaces.length
                                : favoriteRoutes.length,
                            itemBuilder: (context, index) {
                              String item = isLocation
                                  ? favoritePlaces[index]
                                  : favoriteRoutes[index];
                              return ListTile(
                                title: Text(item),
                                trailing: IconButton(
                                  icon: Icon(
                                    favoriteProvider.isFavorite(item)
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: favoriteProvider.isFavorite(item)
                                        ? Colors.red
                                        : null,
                                  ),
                                  onPressed: () {
                                    // 하트 아이콘 클릭 시 즐겨찾기 추가/제거
                                    favoriteProvider.toggleFavorite(item);
                                    setState(() {}); // 상태 업데이트
                                  },
                                ),
                                onTap: () {
                                  print('$item 클릭됨');
                                },
                              );
                            },
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
