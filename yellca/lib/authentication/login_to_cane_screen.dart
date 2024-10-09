import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:provider/provider.dart';
import 'package:yellca/authentication/login_screen.dart';
import 'package:yellca/home/home_screen.dart';
import 'package:yellca/models/auth_provider.dart';

class LoginToCaneScreen extends StatefulWidget {
  const LoginToCaneScreen({Key? key}) : super(key: key);

  @override
  State<LoginToCaneScreen> createState() => _LoginToCaneScreenState();
}

class _LoginToCaneScreenState extends State<LoginToCaneScreen> {
  List<BluetoothDevice> devicesList = [];
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  BluetoothDevice? connectedDevice;
  String imagePath = 'assets/image/login/nodevice.png'; // 초기 이미지 경로
  String changeButton = 'assets/image/login/red_button.png'; // 초기 버튼 경로
  String changeText = '지팡이 연동가능 리스트';

  @override
  void initState() {
    super.initState();
    // 블루투스 초기화
    initBluetooth();
  }

  void initBluetooth() async {
    // 블루투스 상태 확인
    _bluetoothState = await FlutterBluetoothSerial.instance.state;
    // 블루투스 장치 검색
    getDevices();
  }

  void getDevices() async {
    // 장치 목록 가져오기
    List<BluetoothDevice> devices = await FlutterBluetoothSerial.instance.getBondedDevices();
    setState(() {
      devicesList = devices;
    });
  }

  void connectToDevice(BluetoothDevice device) async {
    // 장치에 연결되는 로직 구현
    setState(() {
      connectedDevice = device;
      // 연동 완료 이미지로 변경
      imagePath = 'assets/image/cane/cane.png';
      changeButton = 'assets/image/login/green_button.png';
      changeText = '${connectedDevice!.name}와 연동되었습니다.';
    });
    print('Connecting to ${device.name}');
  }

  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
          },
          icon: Icon(Icons.arrow_back_ios_rounded), // 원래 쓰던 아이콘으로 바꿔야 함
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(isLoggedIn: false))); // 홈 스크린으로 변경
            },
            icon: Icon(Icons.home), // 원래 쓰던 아이콘으로 바꿔야 함
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Text('스마트지팡이 로그인'),
            SizedBox(height: 32.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 250,
                height: 410,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // 그림자 위치
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      imagePath, // 현재 이미지 경로에 따라 표시될 이미지가 변경됨
                      width: 190,
                      height: 190,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          changeButton,
                          width: 22,
                        ),
                        SizedBox(width: 8),
                        Text(
                          changeText,
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    connectedDevice == null
                        ? Expanded(
                      child: ListView.builder(
                        itemCount: devicesList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(devicesList[index].name ?? "Unknown Device"),
                            subtitle: Text(devicesList[index].address),
                            onTap: () => connectToDevice(devicesList[index]),
                          );
                        },
                      ),
                    )
                        : Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // 로그인 버튼 눌렀을 때 HomeScreen으로 이동하면서 로그인된 상태로 넘어감
                            print('로그인 버튼 클릭됨');
                            String nickname = "쿵야";

                            // AuthProvider를 통해 로그인 상태 업데이트
                            Provider.of<AuthProvider>(context, listen: false).login(nickname, 'assets/image/login/koongya_profile.png');

                            // 로그인 성공 시 HomeScreen으로 이동하면서 로그인 상태를 true로 전달
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(
                                  isLoggedIn: true,
                                  nickname: nickname,
                                  profileImagePath: 'assets/image/user/koongya_img.png',
                                ),
                              ),
                            );
                          },
                          child: Text('로그인'),
                        )
                      ],
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
