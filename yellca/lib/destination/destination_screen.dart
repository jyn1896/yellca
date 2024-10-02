// import 'package:flutter/material.dart';
//
// import 'package:yellca/home/home_screen.dart';
//
// class DestinationScreen extends StatefulWidget {
//   const DestinationScreen({super.key});
//
//   @override
//   State<DestinationScreen> createState() => _DestinationScreenState();
// }
//
// class _DestinationScreenState extends State<DestinationScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Center(
//             child: Text(
//               '목적지 설정',
//               style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold
//               ),
//             ),
//           ),
//           actions: [
//             IconButton(
//               icon: Icon(Icons.home),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => HomeScreen()),
//                 );
//                 },
//             ),
//           ],
//       ),
//
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             //목적지 검색 컨테이너
//             Container(
//               padding: EdgeInsets.all(16.0),
//               child: SearchBar(
//                 //검색창의 오른쪽 아이콘
//                 trailing: [
//                   IconButton(
//                     icon: const Icon(Icons.keyboard_voice),
//                     onPressed: (){
//                       ///음성검색 눌렀을 시
//                     },
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.search),
//                     onPressed: (){
//                       ///검색버튼 클릭 시
//                     },
//                   ),
//                 ],
//                 hintText: '목적지를 입력하세요',
//               ),
//             ),
//             SizedBox(height: 8.0),
//
//             // //종류에 따른 분류 ex) 예를 들어 학교라면 -  층별 보기, 교무실학과별로 보기
//             // Container(
//             //   clipBehavior: Clip.antiAlias,
//             //   decoration: BoxDecoration(
//             //     gradient: LinearGradient(
//             //       begin: Alignment(-0.00, -1.00),
//             //       end: Alignment(0, 1),
//             //       colors: [Color(0xA545B0C5), Color(0xFF4580C5), Color(0xFF4580C5)],
//             //     ),
//             //   ),
//             //   child: FutureBuilder(
//             //     future: getDestinationCategory(),
//             //     builder: (context, snapshot) {
//             //     if (snapshot.hasData) {
//             //       // 데이터가 있을 때의 화면 구성
//             //     } else {
//             //       // 데이터를 기다리는 동안의 로딩 화면
//             //     }
//             //   },
//             //   ),
//             // )
//           ],
//         ),
//       ),
//     );
//   }
//
//   getDestinationCategory() {
//
//   }
// }
