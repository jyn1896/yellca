// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
//
// class UpdateBuilding extends StatefulWidget {
//   @override
//   _UpdateBuildingState createState() => _UpdateBuildingState();
// }
//
// class _UpdateBuildingState extends State<UpdateBuilding> {
//   @override
//   void initState() {
//     super.initState();
//     _getBuildingName();
//   }
//
//   void _getBuildingName() async {
//     // 위치 권한 요청
//     LocationPermission permission = await Geolocator.checkPermission();
//
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         // 권한이 거부된 경우
//         Navigator.pop(context, '위치 권한이 필요합니다.');
//         return;
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       // 권한이 영구히 거부된 경우
//       Navigator.pop(context, '위치 권한이 영구히 거부되었습니다.');
//       return;
//     }
//
//     // 현재 위치 가져오기
//     Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//     print('현재 위치: (${position.latitude}, ${position.longitude})'); // 현재 좌표 출력
//     String buildingName = await _fetchBuildingNameFromCoordinates(position.latitude, position.longitude);
//
//
//     // 반환할 정보 결정
//     String returnInfo = buildingName.isNotEmpty ? buildingName : '현재 건물 내부가 아니에요';
//
//     // 서버에 정보 전송
//     //_sendBuildingInfo(returnInfo);
//
//     print('현재 위치: (${position.latitude}, ${position.longitude})');
//
//     // 정보 넘기기
//     Navigator.pop(context, returnInfo);
//   }
//
//   // 건물 이름 조회 메서드
//   Future<String> _fetchBuildingNameFromCoordinates(double latitude, double longitude) async {
//     final String clientId = 'k5qk4x5ccv'; // 클라이언트 ID
//     final String clientSecret = '8daHnKVeflzZY9PTurCjR5xbCjQ1LQJ2SBeI7m9m'; //클라이언트 시크릿
//     final String url =
//         'https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?coords=${Uri.encodeComponent(longitude.toString())},${Uri.encodeComponent(latitude.toString())}&orders=roadaddr&output=json';
//
//     try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: {
//           'X-NCP-APIGW-API-KEY-ID': clientId,
//           'X-NCP-APIGW-API-KEY': clientSecret,
//         },
//       );
//
//       // 응답 상태 코드 확인
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//
//         // 응답 데이터 구조 확인
//         if (data != null && data['result'] != null && data['result']['items'] != null && data['result']['items'].isNotEmpty) {
//           return data['result']['items'][0]['address']['roadAddress']; // 도로명 주소 반환
//         } else {
//           print('API 응답에 예상한 데이터가 없습니다: ${response.body}');
//         }
//       } else {
//         print('API 호출 실패: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('오류 발생: $e');
//     }
//
//     return ""; // 기본적으로 빈 문자열 반환
//   }
//
//   void _sendBuildingInfo(String buildingName) {
//     // 서버에 정보를 전송하는 로직을 구현합니다.
//     print('서버에 전송: $buildingName');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // 로딩 중 화면이나 기본 UI를 반환
//     return Center(child: CircularProgressIndicator());
//   }
// }
